# For loan ID 22378

class InstallmentAccountant < FinanceXL::Accountant
  ledger :operational do
    activity :correction do |amount|
      entry :principal_called_due, :principal_past_due , 382
      entry :principal_past_due, :principal_current, 0.96
      entry :principal_current, :cash, 0.96
      entry :cash, :interest_current, 0.96
      entry :interest_current, :interest_revenue, 0.96
    end
  end

  ledger :financial do
    activity :correction do |amount|
      entry :unrecognized_interest_past_due, :unrecognized_interest_revenue, 237.18
    end
  end
end

class CorrectLoan
  def self.correct(loan_id, amt)
    l = Loan.find(loan_id)
    l.accounting do |accountant|
      a = accountant.activity(:correction, l.today, amt)
      a.entries.each do |e|
        e.memo = 'negative interest, manual correction fix'
        e.save!
      end
      accountant.save!
    end
  end
end
