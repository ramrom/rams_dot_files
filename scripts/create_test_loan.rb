# !!!NOTE: This script requires authentication on called services (identity and helios for this one) 
# in order to work. this script changes time and enova_api_authentication validates time of requests

require 'timecop'

class CreateTestLoan
  def initialize(account_id)
    @account = Identity::Account.find account_id
  end

  def self.call(account_id)
    new(account_id).call
  end

  def call
    Timecop.return
    Timecop.freeze Date.today - 30
    loan_app = CreateLoanApplication.call(entity: account, requested_loan_amount: "5002.0", stated_loan_purpose: "Car Repair", visit_id: 1)
    loan_agreement = create_loan_agreement(loan_app)
    sign_contract(loan_app, loan_agreement)
    SignContractWorker.perform(loan_agreement.contract.id)
    approve_and_issue_loan_application(loan_app)
    issue_and_make_loan_current(loan_app)
    progress_loan(30)
    Timecop.return
  end

  private
  attr_accessor :account, :loan

  def create_loan_agreement(loan_application)
    offer = loan_application.loan_offers.suitable.first
    lg = CreateLoanAgreement.new(
      loan_application.entity,
      loan_application,
      loan_application.loan_offers.suitable.first,
      offer.max_amount.to_f,
      RepaymentMethod['ach'],
      loan_application.loan_number
    ).call

    loan_application.reload
    loan_application.ready_for_contract!
    lg
  end

  def sign_contract(loan_app, loan_agreement)
    signer = CustomerContractSigner.new(loan_agreement)
    sign_params =
      {
        first_name:    account.first_name,
        last_name:     account.last_name,
        ssn:           account.social_security_number,
        ssn_last4:     account.social_security_number_last4,
        date_of_birth: account.date_of_birth,
        ip:            '127.0.0.1'
      }
    signer.sign(sign_params)
  end

  def approve_and_issue_loan_application(loan_app)
    # NOTE: I have to load loan app model again here other wise the `state` = 'contract_unsigned' 
    # when it should be 'ready_for_lp', loan_application_status is correct
    loan_app = LoanApplication.find loan_app.id
    loan_app.entered_lp!
    loan_app.approve!
    loan_app.approve!
  end

  def issue_and_make_loan_current(loan_app)
    @loan = Loan.find_by_loan_number(loan_app.loan_number)
    loan.issue!
    loan.mark_funding_success!
  end

  def pgs_payment_update(action, payment_id)
    raise ArgumentError, 'invalid payment action' unless %w[rejected submitted].include?(action)
    p = Payment.find payment_id
    params =
      {
        payment_status:   action,
        payment_uri:      p.gateway_uri || 'http://pgs.enova.dev/api/v3/payments/0',
        rejected_for_nsf: 'false',
        account_status:   'open',
        occurred_at:      Time.current.to_s
      }
    PaymentNotificationProcessor.call(p, params)
  end

  def progress_loan(days)
    counter = 0
    raise ArgumentError, 'no loan' unless loan
    while counter < days
      Timecop.freeze Date.today + 1
      counter += 1
      loan.perform_daily_accounting!
      perform_payment_accounting
      perform_payment_settlements
      generate_send_and_mock_pgs_submissions_of_payments_for_loan
    end
  end

  def perform_payment_settlements
    payment_ids = SettlementWorker.generate_for_payment_with_a_settlement_date(Brand['netcredit'])
    payment_ids.each { |p_id| SettlementWorker.perform(p_id) }
  end

  def perform_payment_accounting
    payments = PaymentAccountingWorker.payments_scope('netcredit')
    payments = payments.select { |p| p.loan_id == loan.id }
    payments.each { |p| PaymentAccountingWorker.perform(p.loan_id) }
  end

  def generate_send_and_mock_pgs_submissions_of_payments_for_loan
    scheduled_payments = AchEcldPaymentCreatorWorker.payments_to_create(Brand['netcredit'])
    scheduled_payments = scheduled_payments.select { |sp| sp.loan_id == loan.id }
    scheduled_payments.each do |sp| 
      AchEcldPaymentCreatorWorker.perform(sp.id)
      sp.reload
      send_payment(sp)
      pgs_payment_update('submitted', sp.payment.id)
    end
  end

  def send_payment(scheduled_payment)
    scheduled_payment.payment.update(payment_status: PaymentStatus['created'])
    # TODO: maybe send to PGS for real esp when authnetication isnt a prob
    #PaymentSenderWorker.perform(sp.payment.id)
  end
end
