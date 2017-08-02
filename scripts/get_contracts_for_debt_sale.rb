#This script reads pairs of account_ids,loan_numbers from a csv file
#It then makes a call to portfolio and retrieves the contract in html for it
#Then it writes it to a file with the filename as the loan number

#USAGE: execute 'ruby get_contracts_for_debt_sale.rb <name of csv file>"
#will look for contract.csv if you dont pass a filename as argument

BASE_PORTFOLIO_URL = "http://portfolio.netcredit.com/v1"

begin
  require "HTTParty"
rescue Exception
  puts "!!! FAILURE: failed to require HTTParty library, might try running 'gem install httparty'"
  exit
end

def get_accounts
  return read_csv_file
end

def read_csv_file
  require 'csv'
  csv_filename = "contracts.csv"
  csv_filename = ARGV[0] if !ARGV[0].nil?
  if File.exists? csv_filename
    accounts = parse_csv_file(csv_filename)
  else
    puts ">>> FAILURE: file #{csv_filename} not found, exiting"
    exit
  end
end

def parse_csv_file(csv_filename)
  accounts = []
  CSV.foreach csv_filename do |row|
    accounts << [row[0],row[1]]
  end
  accounts
end

def write_contract_to_file(loan_number,content)
  filename = "#{loan_number}.html"
  f = File.open filename,'a'
  f.write content
  f.close
  puts "Successfully created file for loan_number: #{loan_number}"
end

def retrieve_and_write_contract(account,loan_number)
  filename = "#{loan_number}.html"
  if File.exists? filename
    puts ">>> WARNING: Filename #{filename} already exists, skipping writing to this file"
    return
  end
  res = HTTParty.get("#{BASE_PORTFOLIO_URL}/accounts/#{account}/loans/#{loan_number}/contract")
  if res.code == 200 && res.message == "OK"
    cont_body = res['body']
    cust_sig = res['customer_signature']
    brand_sig = res['brand_signature']
    file_content = cont_body + cust_sig + brand_sig
    write_contract_to_file(loan_number,file_content)
  else
    puts ">>> FAILURE: could not retrieve contract for account: #{account}, loan_number: #{loan_number}, error_code: #{res.code}, error_message: #{res.message}"
  end
end

accounts = get_accounts

Dir.mkdir "./contracts" if !File.directory?("./contracts")
Dir.chdir "./contracts"

accounts.each do |account|
  retrieve_and_write_contract(account[0],account[1])
end
