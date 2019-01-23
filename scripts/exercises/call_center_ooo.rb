class Employee
  attr_accessor :busy
  def initialize
    @busy = false
  end
end

class CallCenter
  @@respondents = []
  @@managers = []
  @@directors = []

  def self.add_respons(*args)
    args.each { |a| @@respondents << a }
  end

  def self.add_managers(*args)
    args.each { |a| @@managers << a }
  end

  def self.add_directors(*args)
    args.each { |a| @@directors << a }
  end

  def self.managers
    @@managers
  end
  def self.respondents
    @@respondents
  end

  def self.dispatchCall
    if @@respondents.all?(&:busy)
      puts "need to escalate"
      escalate
    else
      @@respondents.find { |r| !r.busy }.busy=true
    end
  end

  def self.escalate
    if @@managers.all?(&:busy)
      puts "need director"
      dir_escalate
    else
      @@managers.find { |r| !r.busy }.busy=true
    end

    def self.dir_escalate
    if @@directors.all?(&:busy)
      puts "shit out of luck"
    else
      @@directors.find { |r| !r.busy }.busy=true
    end
    end
  end
end

CallCenter.add_respons(Employee.new, Employee.new)
CallCenter.add_managers(Employee.new, Employee.new)
CallCenter.add_directors(Employee.new, Employee.new)
p CallCenter.respondents
CallCenter.dispatchCall
CallCenter.dispatchCall
CallCenter.dispatchCall
CallCenter.dispatchCall
CallCenter.dispatchCall
p CallCenter.respondents
p CallCenter.managers
