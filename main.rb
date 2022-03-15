require_relative './tree.rb'

##
# Pretty print method from The Odin Project lesson
def pretty_print(node = @root, prefix = '', is_left = true)
  pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
  puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
  pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
end
##

def print_elements(tree)
  puts '', 'Print elements', ''

  puts '', "level order: #{tree.level_order.join(' ')}", ''

  puts '', "preorder:    #{tree.preorder.join(' ')}", ''

  puts '', "postorder:   #{tree.postorder.join(' ')}", ''

  puts '', "in order:    #{tree.inorder.join(' ')}", ''
end  

# 1. Create a binary search tree from an array of random numbers

array = Array.new(15) { rand(1..100) }
puts 'Create a binary search tree from an array of random numbers', ''

tree = Tree.new(array)

pretty_print(tree.root)

# 2. Confirm that the tree is balanced by calling #balanced?

puts '', "Tree is#{tree.balanced? ? '' : ' NOT'} balanced.", ''

# 3. Print out tree's elements 

print_elements(tree)

# 4. Unbalance the tree by adding several numbers > 100

puts '', 'Unbalance the tree', ''

5.times { tree.insert(rand(101..200)) }

pretty_print(tree.root)

# 5. Confirm that the tree is unbalanced by calling #balanced?

puts '', "Tree is #{tree.balanced? ? '' : 'NOT'} balanced.", ''

# 6. Balance the tree by calling #rebalance

puts '', '(Re)balance the tree', ''

tree.rebalance

# 7. Confirm that the tree is balanced by calling #balanced?

puts '', "Tree is #{tree.balanced? ? '' : 'NOT'} balanced.", ''

pretty_print(tree.root)

# 8. Print out all elements in level, pre, post, and in order

print_elements(tree)
