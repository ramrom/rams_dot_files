# make a "max" stack, basically this: https://leetcode.com/articles/max-stack/

class MStack
  def initialize
    @stack = []
    @maxint = nil
    @maxint_index = nil
  end
  
  def print_stack
    puts @stack
  end
  
  def push(intg)
    if @stack.empty?
      @maxint = intg
      @stack << intg
    else
      @stack << intg
      if intg > @maxint
        @maxint = intg
        @maxint_index = @stack.size - 1
      end
    end
  end
  
  def pop
    e = @stack.pop
    @stack.empty? ?  @maxint = nil : update_max
    return e
  end
  
  def peek
    @stack[-1]
  end
  
  def peekMax
    return @maxint
  end
  
  def popMax
    if @stack.empty?
      return nil
    else
      e = @stack.delete_at(@maxint_index)
      update_max
      return e
    end
  end
  
  private
  
  def update_max
    @maxint = @stack[0]
    @maxint_index = 0
    @stack.each_with_index do |val, index|
      if val > @maxint
        @maxint = val
        @maxint_index = index
      end
    end
    puts "stack: #{@stack}, maxint: #{@maxint}, index: #{@maxint_index}"
  end 
end 

s = MStack.new
s.push(3)
s.push(23)
s.push(10)
s.push(-4)
s.push(2)
puts s.peekMax
puts s.popMax
puts s.popMax
puts s.popMax
puts s.pop
