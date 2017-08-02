#my scripts with shortcuts for testing

def helloworld
  puts 'hello world'
end

class RT

  def self.hello
    puts "hello world"
  end

  def self.indtime
    QA_dsl.independent_wallclock
  end

  def self.settime (t=0)
    QA_dsl.set_xen_time Date.today + t
  end
 
  def self.resettime_to_ntp
    QA_dsl.reset_railsrunners_and_backend_to_ntpdate
  end

  def self.settimeduedate(l,t)
    if l.oec_statements.length > 1
      QA_dsl.set_xen_time l.oec_statements[-2].due_date.add_business_days(t)
    else
      QA_dsl.set_xen_time l.oec_statements[-1].due_date.add_business_days(t)
    end
  end

  def self.settimeenddate(l,t)
    QA_dsl.set_xen_time l.oec_statements.last.end_date.add_business_days(t)
  end

  def self.markachlines(achlinenum)
    achline = [ AchLine.find achlinenum]
    QA_dsl.mark_ach_lines_returned achline
  end

  def self.curl
    QA_dsl.curl_webpage
  end
  
  def self.simulatebatchrun(batch_name)
    QA_dsl.simluate_batch_run batch_name
    #Batchrun.find
  end

  def self.rollstat
    QA_dsl.simulate_batch_run 'roll_statements'
  end

  def self.genpdfs
    QA_dsl.simulate_batch_run 'generate_statement_pdfs'
  end

  def self.rollstatpdfs
    QA_dsl.simulate_batch_run 'roll_statements'
    QA_dsl.simulate_batch_run 'generate_statement_pdfs'
  end

  def self.createachl
    QA_dsl.simulate_batch_run 'create_ach_lines'
  end

  def self.settleachl
    QA_dsl.simulate_batch_run 'settle_ach_lines_nacha'
  end

  def self.genusbank
    QA_dsl.simulate_batch_run 'generate_and_upload_usbank'
  end

  def self.settleloans
    QA_dsl.simulate_batch_run 'settle_loans'
  end

  def self.returns
    QA_dsl.simulate_batch_run 'returns'
  end

  def self.genpayoec
    QA_dsl.simulate_batch_run 'generate_payments_oec'
  end

  def self.reqCnuMailer
    require 'ruby/svc/mailer/mailer.rb'
    puts "required ruby/svc/mailer/mailer.rb"
  end

  def self.configoverride(configspace)
    CnuConfig._config_files(configspace).reverse.select{|x| x[3]}
  end

  def self.getoecstates
    if ENV['CNU_CLUSTER']=='US'
      oecstates = []
      CnuConfig.loanrules.rules.keys.each do |s|
        if CnuConfig.loanrules.rules[s].kind_of?(CnuConfig::HashConfig) && CnuConfig.loanrules.rules[s].loan_types && CnuConfig.loanrules.rules[s].loan_types.include?('oec')
          oecstates.insert(0,s)
        end
      end
      oecstates
    else
      puts "#{ENV['CNU_CLUSTER']} is current cluster, only US supports oec states"
    end
  end

  def self.au_bring_base_to_paidoff(base_loan,verbose=false)
    indtime
    if base_loan.extended? then 
      ext_loan = base_loan.extended_by 
    else
      puts "this loan has no extensions"
      return 
    end
    
    puts "running settle task, settle_direct_entry, genanduploaddirentry batches now" if verbose
    QA_dsl.simulate_batch_run("cso_create_settle_tasks")
    QA_dsl.simulate_batch_run("create_settle_direct_entry_lines")
    QA_dsl.simulate_batch_run("generate_and_upload_direct_entry")
    
    puts "setting time to due date: #{base_loan.due_date} for loan id: #{base_loan.id}" if verbose
    QA_dsl.set_xen_time(12.hours.since base_loan.due_date.to_time)

    puts "approving and issuing extension loan id: #{ext_loan.id}" if verbose
    ext_loan.approve if ext_loan.status_cd=="applied"
    ext_loan.reload
    ext_loan.issue if !ext_loan.issued?

    puts "running settle task, settle_direct_entry, genanduploaddirentry batches now" if verbose
    QA_dsl.simulate_batch_run("cso_create_settle_tasks")
    QA_dsl.simulate_batch_run("create_settle_direct_entry_lines")
    QA_dsl.simulate_batch_run("generate_and_upload_direct_entry")

    puts "set time to 3 biz days after due date: #{base_loan.due_date.add_business_days(3)} for loan id: #{base_loan.id}" if verbose
    QA_dsl.set_xen_time(12.hours.since base_loan.due_date.add_business_days(3).to_time)
  
    puts "running settle_direct_entry batch and settling base loan now" if verbose
    QA_dsl.simulate_batch_run("settle_direct_entry_lines")
    base_loan.reload
    if base_loan.status_cd=="issued_pmt_proc"
      base_loan.settle 
    else
      puts "loan (id #{base_loan.id}) is not in issued_pmt_proc status, cannot settle"
    end

    #QA_dsl.set_xen_time(12.hours.since.ext_loan.due_date.add_business_days(-1).to_time)
  end
end

