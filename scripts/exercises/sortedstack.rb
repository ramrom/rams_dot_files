# implement a stack that maintains sorted order when pushed
class SortStack
  def initialize
    @stk = []
    @tmpstk = []
  end

  def print
    puts "#{@stk}"
  end

  def push(int)
    if @stk.last.nil?
      @stk << int
    else
      while !@stk.empty? && int > @stk.last
        @tmpstk << @stk.pop
      end
      @stk << int
      while !@tmpstk.empty?
        @stk << @tmpstk.pop
      end
    end
  end

  def pop
    @stk.pop
  end
end

ss = SortStack.new
ss.push(1)
ss.push(3)
ss.push(4)
ss.push(-1)
ss.print
