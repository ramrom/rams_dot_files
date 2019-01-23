class StackStack
  def initialize(stack_size)
    @stack_size = stack_size
    @stacks = [Stack.new(stack_size)]
  end

  def print
    puts "stack state: #{@stacks.map { |s| s.stk }}"
  end

  def push(int)
    if @stacks.last.full?
      @stacks << Stack.new(@stack_size)
    end
    @stacks.last.push(int)
  end

  def pop
    top_stack = @stacks.last
    return nil if top_stack.nil?
    val = top_stack.pop
    if top_stack.empty?
      @stacks.pop # if no more elements in top stack, get rid of it
    end
    val
  end

  class Stack
    attr_reader :stk

    def initialize(maxsize)
      @maxsize = maxsize
      @stk = []
    end

    def pop
      @stk.pop
    end

    def push(int)
      full? ? raise("stack is full!") : @stk << int
    end

    def empty?
      @stk.empty?
    end

    def full?
      @stk.size == @maxsize
    end
  end
end

ss = StackStack.new(2)
(1..10).each { |i| ss.push(i) }
ss.print
5.times { |i| ss.pop }
ss.print
