class Node
  attr_accessor :left, :right, :value
  def initialize(value, left, right)
    @value = value
    @left = left
    @right = right
  end

  def leaf?
    !@left && !@right
  end
end

def create_binary_tree(list)
end

create_binary_tree([1,2,3,4,5,6])
l1 = Node.new(1, nil, nil)
l2 = Node.new(10, nil, nil)
lroot = Node.new(3, l1, l2)
r1 = Node.new(13, nil, nil)
r2 = Node.new(30, nil, nil)
rroot = Node.new(20, r1, r2)
root = Node.new(11, lroot, rroot) 

# recursively build double linked list from binary search tree
def bstllrec(node)
  return [node, node] if node.leaf?

  lefthead, lefttail, righthead, righttail = nil, nil, nil, nil
  if node.left
    lefthead, lefttail = bstllrec(node.left)
  end
  if node.right
    righthead, righttail = bstllrec(node.right)
  end

  if lefttail != nil
    lefttail.right = node
    node.left = lefttail
  else
    lefthead = node
  end

  if righthead != nil
    righthead.left = node
    node.right = righthead
  else
    righttail = node
  end

  [lefthead, righttail]
end

h, t = bstllrec(root)
puts h.value, h.right.value, h.right.right.value, h.right.right.right.value
puts t.value, t.left.value, t.left.left.value, t.left.left.left.value


# iteratively **WIP**
def bst_to_ll(bst)
  curr_node = bst
  ll = nil
  while !curr_node.leaf?
    if curr_node.left
      curr_node = curr_node.left
    else
      curr_node = curr_node.right
    end
  end
  ll = curr_node
end
