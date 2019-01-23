class TQueue
  attr_reader :q
  def initialize
    @m = Mutex.new
    @q = []
  end

  def enqueue(item)
    @m.synchronize do
      @q.push(item)
    end
  end

  def dequeue
    @m.synchronize do
      @q.pop
    end
  end
end

class Foo
  def initialize
    @m = Mutex.new
    @first_finished = false
  end

  def first
    puts "did first"
    @m.synchronize { |m| @first_finished = true }
  end

  def check_flag
    @m.synchronize { |m| !@first_finished }
  end

  def second
    while @m.synchronize { |m| !@first_finished } do 
      sleep 1
    end
    puts "did second"
  end
end

f = Foo.new

t2 = Thread.new { f.second }
sleep 3
t1 = Thread.new { f.first }

t1.join
t2.join

tq = TQueue.new
t1 = Thread.new { 1000.times { |i| tq.enqueue(i) } }
t2 = Thread.new { 1000.times { |i| tq.enqueue(i) } }

t1.join
t2.join
puts tq.q.size
