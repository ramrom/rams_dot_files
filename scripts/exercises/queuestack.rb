# implement a queue using only stacks
class SQueue
  def initialize
    @stk = []
    @stk2 = []
  end

  def print
    puts "#{@stk}, #{@stk2}"
  end

  def enqueue(int)
    @stk << int
  end

  def dequeue
    while !@stk.empty?
      @stk2 << @stk.pop
    end
    val = @stk2.pop
    while !@stk2.empty?
      @stk << @stk2.pop
    end
    val
  end
end

sq = SQueue.new
sq.enqueue(1)
sq.enqueue(4)
sq.enqueue(5)
sq.enqueue(2)
sq.print
puts sq.dequeue
sq.print
puts sq.dequeue
sq.print
