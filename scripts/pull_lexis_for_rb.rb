#This script reads pairs of account_ids,loan_numbers from a csv file
#It then makes a call to identity to retrieve lexis nexis flex id and risk view reports

#USAGE: execute 'ruby pull_lexis_for_rb.rb <name of csv file>"
#will look for rb_decline.csv if you dont pass a filename as argument

BASE_IDENTITY_URL = "http://identity.netcredit.com/v1"

require 'pry'

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
  csv_filename = "rb_decline.csv"
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
  CSV.foreach csv_filename, { :col_sep => ";"} do |row|
    accounts << row[0]
  end
  accounts
end

def pull_lexis_nexis(account)
  res = HTTParty.get("#{BASE_IDENTITY_URL}/accounts/#{account}/credit_reports?purchase=true&purchaser=netcredit_republic_bank&reports[]=risk_view&reports[]=flex_id")
  if res.code == 200 && res.message == "OK"
    puts "successfully made request to pull for account #{account}"
  else
    puts ">>> FAILURE: could not retrieve contract for account: #{account}, error_code: #{res.code}, error_message: #{res.message}"
  end
end

accounts = get_accounts
accounts.each { |account| pull_lexis_nexis(account) }

puts 'ALL DONE'
