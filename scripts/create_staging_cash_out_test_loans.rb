# script to create a a bunch of test accs/loans for cash out

ENV['NCONJURE_ENV'] = 'staging'

USER_NAME = 'Sreeram'

INCOME = '5000'
ELIGIBLE_CASH_OUT_STATES = %w[AL DE ID SD UT VA]
CUSTOMERS_PER_PERMUTATION=5

file_output=""

def append_state_header(file_string,state)
  file_string << "-----------------------------------------------------------\n"
  file_string << "---- STATE: #{state} --------------------------------------\n"
  file_string << "-----------------------------------------------------------\n"
end

ELIGIBLE_CASH_OUT_STATES.each do |state|
  CUSTOMERS_PER_PERMUTATION.times do
    append_state_header(file_output,state)
    output = `/Users/#{USER_NAME}/netcredit/gems/nconjure/bin/nconjure account create --region=#{state} --custom_params=income_net_per_check:#{INCOME} paydate_frequency:monthly paydate_schedule_type:specific_date paydate_ordinal:1` + "\n"
    puts output
    file_output << output
    output = `/Users/#{USER_NAME}/netcredit/gems/nconjure/bin/nconjure loan apply --current` + "\n\n\n"
    puts output
    file_output << output
  end
end

File.open('cash_out_loans.txt','a') do |f|
  f.puts file_output
end
