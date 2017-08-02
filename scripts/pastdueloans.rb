BAD_LOANS = 
%w[2014CA074485824 2014CA342145895 2014VA042961996 2013UT196603405 2014CA941089263 2014VA433654497 2014AL206152997 2013VA163958653 2014VA109940697 2013CA791531044 2014AL059337927 2013VA149476736 2014CA895507312 2014WI937587308 2014MO997752781 2013AL399718299 2014VA769243527 2013WI395908488 2013CA485598622 2013VA451676437 2013VA040173451]
BAD_LOANS << '2014CA154379340' 
BAD_LOANS << '2014CA756684291'

past_due_amounts = {}

BAD_LOANS.each do |loan|
  l = Loan.where(loan_number: loan).first
  balances = l.accounting &:balances
  
  ledger_pastdue = balances[:past_due].to_f

  total_paid = 0.0
  l.payments.where(payment_status_id: 4, is_outgoing: false).map(&:amount).map(&:to_f).each { |p| total_paid = total_paid + p }
  total_due = 0.0
  #l.scheduled_payments.where('due_date <= ?', Date.parse('2015-01-21')).map(&:original_amount).map(&:to_f).each { |p| total_due = total_due + p }
  l.scheduled_payments.where('due_date <= ?', Date.today).map(&:original_amount).map(&:to_f).each { |p| total_due = total_due + p }
  payments_pastdue = total_due - total_paid

  past_due_amounts[loan] = { ledger_pastdue: ledger_pastdue, payments_pastdue: payments_pastdue.round(2) }  
end

past_due_amounts.each do |loan,vals|
  puts "Loan Number: #{loan}, ledger past due: #{vals[:ledger_pastdue]}"
  puts "Loan Number: #{loan}, payments past due: #{vals[:payments_pastdue]}"
  puts ""
end
