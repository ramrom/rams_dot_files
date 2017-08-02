class FixLoanz
  def self.cancel_act(canceled_activity)
    if canceled_activity.cancelled?
      puts 'already canceled'
      return
    end
    loan = Loan.find(canceled_activity.source_id)
      loan.with_lock do
        loan.accounting do |accountant|
        activity = accountant.activity(:cancel, loan.today, canceled_activity.activity_amount,
            effective_date: loan.today,
            payment_id: canceled_activity.payment_id,
            cancels_activity_id: canceled_activity.id
            )
        accountant.save!
      end
    end
  end
end
