require 'httparty'
$puid = 286
$counter = 0

def post_payment(payment)
  params = {
      loan_number:        payment[1],
      status:             :paid,
      is_outgoing:        false,
      effective_date:     "2015/02/15",
      #effective_date:     Date.parse payment[3],
      repayment_method:   "waiver",
      amount:             payment[2].to_f,
      portal_user_id:     $puid
      #collected_by:       puid,
    }

  url = "http://portfolio.lancelot.enova.com/v1/loans/#{payment[1]}/payments"
  post_params = {
      headers: { "Content-Type" => "application/json" },
      body:    params.to_json
    }

  res = HTTParty.post(url, post_params)
end

def add_errors(response, payment)
  return if response.code == 201
  $errors << "Account #{payment[0]}, Loan Number: #{payment[1]}, FAILED, code: #{response.code}, message: #{response.message}"
end

def post_payments(payments)
  $errors = []
  payments.each do |payment|
    puts "COUNT #{$counter}, POSTING: Account #{payment[0]}, Loan Number: #{payment[1]}, amount: #{payment[2]}"
    res = post_payment(payment)
    add_errors(res, payment)
    $counter = $counter + 1
  end
  $errors
end

def write_errors(errors)
  File.open('TILA_errors','w') do |f|
    errors.each do |error|
      f.write(error)
      f.write("\n")
    end
  end
end

def console_make_payments(payments)
  payments.each do |payment|
    l = Loan.by_number! payment[1]
    params = {
        loan_number:        payment[1],
        status:             :paid,
        is_outgoing:        false,
        effective_date:     Date.parse("2015/02/15"),
        #effective_date:     Date.parse payment[3],
        repayment_method:   RepaymentMethod.where(repayment_method: "waiver").first,
        amount:             payment[2].to_f,
        portal_user_id:     $puid
        #collected_by:       puid,
      }
     
    c = CreateRetroactivePayment.new(l, params)
    c.save
  
    errors << c.payment.errors
    #res = post_payment(params)
    #$errors << [res.code, res.message, res["body"].to_s]
  end
end

def sanity_check(payments)
  puts "SANITY CHECKS!"
  errors = []
  payments.each do |payment|
    l = Loan.by_number! payment[1]
    if l.account_id != payment[0].to_i
      puts "Loan num: #{payment[1]}, account #{l.account_id} on loan number doesnt match given account id of #{payment[0]}"
      errors << payment[0]
    end
  end
  errors
end

$non_legal = CSV.read('./TILA_non_legal.csv')
$legal = CSV.read('./TILA_legal.csv')

$non_legal.shift
$legal.shift

puts "non legal payments count: #{$non_legal.count}"
puts "legal payments count: #{$legal.count}"


#errors = console_make_payments
#sanity_check($non_legal)
#post_payments($non_legal)
#write_errors(errors)
