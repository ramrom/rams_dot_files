class SendNoaa
  attr_reader :loan_application_id

  def self.call(loan_application_id)
    new(loan_application_id).call
  end

  def initialize(loan_application_id)
    @loan_application_id = loan_application_id
  end

  def call
    loan_application = LoanApplication.find(loan_application_id)

    case loan_application.state.to_s
    when "underwriting_declined"
      clerk(loan_application).underwriting_declined
    when "lp_declined"
      clerk(loan_application).lp_declined            # Damn, cant do this, need employment verification
    when "withdrawn"
      clerk(loan_application).withdrawn_application  # Damn can't do this, need employment verification
    when "superseded"
      clerk(loan_application).counter_offer
    else
      puts "Loan Application id: #{loan_application.id}, state: #{loan_application.state}, not a valid status for NOAA emails"
    end

  rescue ActiveRecord::RecordNotFound => e
    puts "loan application_id #{loan_application_id} not found!, skipping!"
  end

  private

  def clerk(loan_application)
    entity = loan_application.entity

    preapproved_offer = nil
    if entity && entity.brand == 'netcredit'
      preapproved_offer = PreapprovedLoanOffer.find_valid_offer(
        entity.id,
        entity.social_security_number,
        entity.date_of_birth,
        Region[entity.address.region],
        entity.first_name,
        entity.last_name
      )
    end

    AdverseAction::Clerk.new(
      loan_application,
      preapproved_offer
    )
  end
end
