class Node
  attr_reader :value, :children
  def initialize(value, children)
    raise ArgumentError unless children.kind_of?(Array)
    @value = value
    @children = children
  end
end

def print_tree(node)
  puts "#{node.value}"
  puts "--------------"
  current_level_nodes = []
  node.children.each { |c| current_level_nodes << c }

  while !current_level_nodes.empty? do
    current_level_nodes.each { |n| print "#{n.value} " }
    puts "\n--------------"
    current_level_nodes = current_level_nodes.map { |n| n.children }.flatten
  end
end

third = [1,2,3,4].map { |v| Node.new(v, []) }
two1 = Node.new(11, [third[0], third[1]])
two2 = Node.new(12, [third[2], third[3]])
root = Node.new(1, [two1, two2])

print_tree(root)
