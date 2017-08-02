#this script will set the employees and genesys.agents tables for the db snapshots for for genesys testing

us_snapshot = { :host => "qassdb-03-obr.cashnetusa.com", :port => 5432, :database => "cnuapp_prod", :username => "postgres", :password => "cnuappusqa"}
uk_snapshot = { :host => "qassdb-25-nut.cashnetusa.com", :port => 5432, :database => "cnuapp_prod_uk", :username => "postgres", :password => "cnuappukqa"}
jv_snapshot = { :host => "qassdb-06-obr.cashnetusa.com", :port => 5432, :database => "cnuapp_prod_jv", :username => "postgres", :password => "cnuappjvqa"}



users_us = [
  { :login => '33391_username', :agent_id => 809, :employee_id => 11373, :extension => 33391 },
  { :login => 'kjavvaji', :agent_id => 423, :employee_id => 11374, :extension => 33318 },
  { :login => '33390_username', :agent_id => 537, :employee_id => 11471, :extension => 33390 },
  { :login => 'jmurphy1', :agent_id => 396, :employee_id => 11472, :extension => 33319 },
  { :login => '33381_username', :agent_id => 810, :employee_id => 11850, :extension => 33381 },
  { :login => 'pchengalasetty', :agent_id => 570, :employee_id => 11851, :extension => 33316 },
  { :login => '33388_username', :agent_id => 350, :employee_id => 12521, :extension => 33388 },
  { :login => 'smittapalli', :agent_id => 812, :employee_id => 12522, :extension => 33317 }
]

users_uk = [
  { :login => '33391_username', :agent_id => 663, :employee_id => 307, :extension => 33391 },
  { :login => 'kjavvaji', :agent_id => 659, :employee_id => 308, :extension => 33318 },
  { :login => '33390_username', :agent_id => 521, :employee_id => 354, :extension => 33390 },
  { :login => 'jmurphy1', :agent_id => 661, :employee_id => 355, :extension => 33319 },
  { :login => '33381_username', :agent_id => 664, :employee_id => 10870, :extension => 33381 },
  { :login => 'pchengalasetty', :agent_id => 662, :employee_id => 10871, :extension => 33316 },
  { :login => '33388_username', :agent_id => 665, :employee_id => 11569, :extension => 33388 },
  { :login => 'smittapalli', :agent_id => 660, :employee_id => 11570, :extension => 33317 }
  #production test users folder
  { :login => 'gurfive', :agent_id => 658, :employee_id => 306, :extension => 39110 },
  { :login => 'gurfour', :agent_id => 657, :employee_id => 305, :extension => 39109 },
  { :login => 'gurthree', :agent_id => 656, :employee_id => 304, :extension => 39108 },
  { :login => 'gurtwo', :agent_id => 655, :employee_id => 303, :extension => 39107 },
  { :login => '39106_username', :agent_id => 654, :employee_id => 302, :extension => 39106 }
]

users_jv = [
  { :login => '33391_username', :agent_id => 283, :employee_id => 11373, :extension => 33391 },
  #{ :login => 'kjavvaji', :agent_id => 279, :employee_id => 11374, :extension => 33318 },
  { :login => 'kjavvaji', :agent_id => 8, :employee_id => 11374, :extension => 33318 },
  { :login => '33390_username', :agent_id => 284, :employee_id => 11494, :extension => 33390 },
  #{ :login => 'jmurphy1', :agent_id => 280, :employee_id => 11495, :extension => 33319 },
  { :login => 'jmurphy1', :agent_id => 21, :employee_id => 11495, :extension => 33319 },
  { :login => '33381_username', :agent_id => 204, :employee_id => 11541, :extension => 33381 },
  #{ :login => 'pchengalasetty', :agent_id => 281, :employee_id => 11542, :extension => 33316 },
  { :login => 'pchengalasetty', :agent_id => 287, :employee_id => 11542, :extension => 33316 },
  { :login => '33388_username', :agent_id => 286, :employee_id => 11766, :extension => 33388 },
  #{ :login => 'smittapalli', :agent_id => 282, :employee_id => 11767, :extension => 33317 }
  { :login => 'smittapalli', :agent_id => 9, :employee_id => 11767, :extension => 33317 }
]

puts "set verbose environment variable to see additional info"

users_us.each do |user| 
  #create_using_psql(user,us_snapshot)
end

users_uk.each do |user| 
  #create_using_psql(user,uk_snapshot)
end

users_jv.each do |user| 
  #create_using_psql(user,jv_snapshot)
end

def create_using_psql(user,dbparams)
  puts "attempting to update employee id: #{user[:employee_id]}, with login: #{user[:login]}"
  command = "UPDATE employees SET login = '#{user[:login]}', active_flg = true WHERE id = #{user[:employee_id]}"
  result = `PGPASSWORD=#{dbparams[:password]} psql -h #{dbparams[:host]} -p #{dbparams[:port]} #{dbparams[:database]} -U #{dbparams[:username]} -c "#{command}"`
  puts result if ENV['verbose']

  puts "attempting to update agent #{user[:agent_id]}, using extension: #{user[:extension]}, employee id: #{user[:employee_id]}"
  command = "UPDATE genesys.agents SET employee_id = #{user[:employee_id]}, extension = #{user[:extension]} where id=#{user[:agent_id]}"
  result = `PGPASSWORD=#{dbparams[:password]} psql -h #{dbparams[:host]} -p #{dbparams[:port]} #{dbparams[:database]} -U #{dbparams[:username]} -c "#{command}" 2>&1`
  puts result if ENV['verbose']

  if result.include?("ERROR") || result.include?("UPDATE 0")
    puts "UPDATE-ing agent failed, will INSERT"
    puts "attempting to insert agent #{user[:agent_id]}, using extension: #{user[:extension]}, employee id: #{user[:employee_id]}"
    command = "INSERT into genesys.agents (employee_id,extension) VALUES (#{user[:employee_id]},#{user[:extension]})"
    result = `PGPASSWORD=#{dbparams[:password]} psql -h #{dbparams[:host]} -p #{dbparams[:port]} #{dbparams[:database]} -U #{dbparams[:username]} -c "#{command}"`
    puts result if ENV['verbose']
  end
end

def create_using_rails(user)
  puts "attempting to update employee id: #{user[:employee_id]}, with login: #{user[:login]}"
  e = Employee.find user[:employee_id]
  e.login = user[:login]
  e.active_flg = true
  e.save!

  puts "attempting to update agent #{user[:agent_id]}, using extension: #{user[:extension]}, employee id: #{user[:employee_id]}"
  begin 
    ga = Agent.find user[:agent_id]
  rescue ActiveRecord::RecordNotFound
    puts "Agent #{user[:agent_id]} not found in db, creating a new agent"
    Agent.create(:extension => user[:extension], :employee_id => user[:employee_id]) 
    return
  end
  ga.extension = user[:extension]
  ga.employee_id = user[:employee_id]
  ga.save!
end

def is_rails_enabled?
  begin
    return true if Rails
  rescue NameError => ne
    puts "Rails is not enabled, error: #{ne.message}"
    return false
  end  
end

AGENT_TB_INSERT="INSERT into genesys.agents (employee_id,extension) VALUES ($EMPLOYEE_ID,$EXTENSION)"
EMP_TB_UPDATE="UPDATE employees SET login = 'username_$EXTENSION', active_flg = true WHERE id = $EMPLOYEE_ID"

