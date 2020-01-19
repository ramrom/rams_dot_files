require 'capybara'
require 'capybara/poltergeist'
require 'selenium-webdriver'
require 'spreadsheet'
require 'pry'

BASE_URL = 'https://freida.ama-assn.org'

SEARCH_URL = 'https://freida.ama-assn.org/Freida/user/search/programSearch.do'

SEARCH_RESULTS_URL = 'https://freida.ama-assn.org/Freida/user/search/programSearchSubmit.do?specialtiesToSearch=120&statesToSearch=&regionsToSearch=&keywordBlobToSearch='

USERNAME = 'foo'
PASSWORD = 'bar'

class Program
  ATTRIBUTES =  [:program_name, :program_id, :city_state, :last_updated]
  ATTRIBUTES += [:contact_name, :contact_address, :contact_phone, :contact_fax, :contact_email]
  ATTRIBUTES += [:web_address]

  ATTRIBUTES += [:total_program_size, :program_desc, :average_current_res_step1_score]
  ATTRIBUTES += [:trainee_percent_img, :trainee_percent_do]

  # national resident matching programs
  ATTRIBUTES += [:participates_in_main_nrmp, :main_nrmp_codes]
  ATTRIBUTES += [:required_letters_of_rec]

  #requirement for interview consideration
  ATTRIBUTES += [:usmle_step1_min_score, :usmle_step2_min_score]
  ATTRIBUTES += [:accepting_2016_apps, :offers_prelim_positions]

  ATTRIBUTES += [:yr1_most_taxing_schedule, :yr1_beeper_or_home_call]
  ATTRIBUTES += [:yr2_most_taxing_schedule, :yr2_beeper_or_home_call]
  ATTRIBUTES += [:yr3_most_taxing_schedule, :yr3_beeper_or_home_call]
  ATTRIBUTES += [:yr4_most_taxing_schedule, :yr4_beeper_or_home_call]

  attr_accessor *ATTRIBUTES

  def self.attributes
    ATTRIBUTES
  end
end

class Freida
  include Capybara::DSL

  attr_accessor :programs, :program_links, :failed_links

  def initialize
    @file = "programs_#{Time.now.strftime("%Y-%m-%d_%H_%M")}.csv"
    @success_program_file = 'programs_success.csv'
    @success_program_ids = read_current_success_file

    @failure_link_file = 'freida_failures.txt'
    @failure_links = File.readlines(@failure_link_file).map(&:strip)

    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :browser => :firefox)
    end
    Capybara.default_driver = :selenium
    use_poltergeist if ENV['POLTERGEIST']

    @programs = []
    @program_links = []
    @failed_links = []
  end

  def login(username, password)
    visit BASE_URL
    fill_in 'username', with: username
    fill_in 'password', with: password
    click_button 'Sign in'
  end

  def get_data!
    #visit SEARCH_URL
    #agree_to_modal
    #fill_in 'specialtiesToSearch', with: 'Family Medicine'
    #click_button 'Search'
    visit SEARCH_RESULTS_URL
    binding.pry
    extract_program_links
    extract_all_program_data
  end

  def run_file(file)
    links = File.readlines(file).map(&:strip)
    visit SEARCH_RESULTS_URL
    binding.pry
    extract_all_program_data(links)
  end

  def agree_to_modal
    accept_alert do
      execute_script "window.scrollBy(0,10000)"
      click_button 'Agree'
    end
  end

  def write_to_csv(file, program)
    f = File.open(file, 'a')
    Program.attributes.each do |att|
      puts "att: #{att} WAS NIL" if program.send(att).nil?
      f.write program.send(att) + '|'
    end
    f.write "\n"
    f.close
  end

  def extract_program_links
    all('.program-title').each do |el|
      program_links << el['href']
    end
    puts "Extracted #{program_links.count} links"
  end

  def extract_all_program_data(links = program_links)
    index = 0
    links.each do |program_link|
      begin
        index += 1
        #if @failure_links.include? program_link
        #  puts "LINK #{program_link} is marked as failure, SKIPPING!"
        #  next
        #end
        puts "LINK ##{index}: Visiting program link #{program_link}"
        visit program_link
        extract_program_data_from_page
        last_program = programs.last
        write_to_csv(@success_program_file, last_program) if program_new?(last_program)
        `echo "#{program_link}" >> freida_successes.txt`
        break if ENV['LINK_LIMIT'] && ENV['LINK_LIMIT'].to_i <= index
      rescue Capybara::ElementNotFound
        puts "ELEMENTNOTFOUND, Program link #{program_link} FAILED!!!"
        `echo "#{program_link}" >> #{@failure_link_file}`
        failed_links << program_link
      rescue NoMethodError
        puts "NOMETHODERROR, Program link #{program_link} FAILED!!!"
        `echo "#{program_link}" >> #{@failure_link_file}`
        failed_links << program_link
      end
    end
  end

  def extract_program_data_from_page
    p = Program.new
    Program.attributes.each { |a| p.send("#{a}=","???") }

    extract_basic_info(p)
    extract_general_info(p)
    extract_faculty_info(p)
    extract_work_schedule_info(p)

    write_to_csv(@file, p)
    programs << p
  end

  private
  
  def extract_basic_info(p)
    p.web_address                     = find(:xpath, '//a[@target="FREIDAEXT"]')['href']
    p.program_name                    = find('.program-title').text
    p.program_id                      = find('.program-subtitle', match: :first).text.scan(/\d.*/).first
    p.city_state                      = get_city_state
    p.last_updated                    = get_last_updated
 
    p.contact_name                    = all('article.grid-50')[1].first('div.address-line').text
    p.contact_address                 = all('article.grid-50')[1].all('div.address-line')[1].text
    p.contact_phone                   = all('article.grid-50')[1].all('div.address-line')[2].text[4..-1]
    p.contact_fax                     = all('article.grid-50')[1].all('div.address-line')[3].text[4..-1]
    p.contact_email                   = all('article.grid-50')[1].all('div.address-line')[4].text[8..-1]

    p.accepting_2016_apps             = find(:xpath, '//li[.//div[contains(text(),"begins in 2016-2017")]]/div[2]').text

  end

  def extract_general_info(p)
    return unless has_link?('General Information')
    click_link('General Information')

    # This return the size of year 1 (usually same as 2and 3)
    p.total_program_size              = find('section#general-info').all('td')[1].text
    p.program_desc                    = find('section#general-info').all('div')[3].text

    p.average_current_res_step1_score = find(:xpath, '//table[.//div[contains(text(),"Average Step 1 score")]]//td[1]').text
    p.participates_in_main_nrmp       = get_nrmp_info('decision')
    p.main_nrmp_codes                 = get_nrmp_info('code')
    p.required_letters_of_rec         = find(:xpath, '//li[.//div[contains(text(),"Required letters of recommendation")]]/div[2]').text
    p.usmle_step1_min_score           = find(:xpath, '//table[.//th[text()="Step 1 required"]]/tbody//td[2]').text
    p.usmle_step2_min_score           = find(:xpath, '//table[.//th[text()="Step 1 required"]]/tbody//td[4]').text
    p.offers_prelim_positions         = find(:xpath, '//li[.//div[contains(text(),"Offers preliminary")]]/div[2]').text
  end

  def extract_faculty_info(p)
    return unless has_link?('Faculty & Trainees')
    click_link('Faculty & Trainees')

    p.trainee_percent_img             = get_trainee_percent_img
    p.trainee_percent_do              = get_trainee_percent_do
  end
  
  def extract_work_schedule_info(p)
    return unless has_link?('Work Schedule')
    click_link('Work Schedule')

    
    r = find(:xpath, '//h3[text()="Call schedule"]')
    unless r
      puts 'no call schedule found'
      return
    end

    p.yr1_most_taxing_schedule  = r.find(:xpath, '//table//tr[1]/td[2]').text
    p.yr1_beeper_or_home_call   = r.find(:xpath, '//table//tr[1]/td[3]').text

    p.yr2_most_taxing_schedule  = r.find(:xpath, '//table//tr[2]/td[2]').text
    p.yr2_beeper_or_home_call   = r.find(:xpath, '//table//tr[2]/td[3]').text

    p.yr3_most_taxing_schedule  = r.find(:xpath, '//table//tr[3]/td[2]').text
    p.yr3_beeper_or_home_call   = r.find(:xpath, '//table//tr[3]/td[3]').text

    p.yr4_most_taxing_schedule  = r.find(:xpath, '//table//tr[4]/td[2]').text
    p.yr4_beeper_or_home_call   = r.find(:xpath, '//table//tr[4]/td[3]').text
  end

  def program_new?(program)
    !@success_program_ids.include?(program.program_id)
  end

  def read_current_success_file
    #puts "#{file} doesnt exist!!!!!!!" if !File.exists?(file)
    lines = File.readlines(@success_program_file)
    lines.map { |line| line.split("|")[1] }
  end

  def use_poltergeist
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, :browser => :poltergeist)
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
  end

  def get_trainee_percent_img
    r = find('section#program-faculty').all('table')[1]
    return "???" unless r
    r.all('td')[1].text
  end

  def get_trainee_percent_do
    r = find('section#program-faculty').all('table')[1]
    return "???" unless r
    r.all('td')[2].text
  end

  def get_nrmp_info(field)
    @info ||= find(:xpath, '//li[.//div[contains(text(),"Participates in the Main Match")]]/div[2]').text
    field == 'decision' ? @info.scan(/^[^\s]*\s/).first.strip : @info.scan(/:\s(.*)/).first.first
  end

  def get_last_updated
    text = first('div.grid-50.sub-info').text
    text.scan(/\d{2}\/\d{2}\/\d{4}/).first
  end

  #TODO: this only grabs the last word of a city if there are many words
  def get_city_state
    text = all(:xpath, '//article[@class="grid-50"][1]//div[@class="address-line"]')[1].text
    text.scan(/\s([a-zA-Z]*,\s[A-Z]{2})\s\d{5}/).first.first
  end
end

class CreateSpreadsheet
  def initialize
    @file = "programs_#{Time.now.strftime("%Y-%m-%d_%H_%M")}.xls"
  end

  def create_book_from_csv(csv)
    lines = File.readlines(csv).map(&:strip)

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet name: 'programs'

    Program.attributes.each do |attr|    
      sheet.row(0).push attr.to_s
    end

    index = 2
    lines.each do |line|
      line.split('|').each do |val|
        sheet.row(index).push val
      end
      index += 1
    end
  
    book.write @file
  end

  def call(programs, headers)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet name: 'programs'

    Program.attributes.each do |attr|    
      sheet.row(0).push attr.to_s
    end

    index = 2
    programs.each do |p|
      Program.attributes.each do |att|
        sheet.row(index).push p.send(att)
      end
      index += 1
    end
  
    book.write @file
  end
end

if ARGV[0] == 'new'
  frieda = Freida.new
  ss = CreateSpreadsheet.new
  frieda.login(USERNAME, PASSWORD)
  frieda.get_data!
  ss.call(frieda.programs, Program.attributes)
  #binding.pry if ENV['PRY']
elsif ARGV[0] == 'custom'
  frieda = Freida.new
  frieda.login(USERNAME, PASSWORD)
  frieda.run_file('psych_programs.txt')
elsif ARGV[0] == 'pry'
  frieda = Freida.new
  binding.pry
end
