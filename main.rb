require_relative './tree.rb'

##
# Pretty print method from The Odin Project lesson
def pretty_print(node = @root, prefix = '', is_left = true)
  pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
  puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
  pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
end
##

# 1. Create a binary search tree from an array of random numbers

array = Array.new(15) { rand(1..100) }
puts 'Create a binary search tree from an array of random numbers', ''

tree = Tree.new(array)

pretty_print(tree.root)

# 3. Print out tree's elements 

puts '', 'Print level order', ''

tree.level_order { |node| print node.data, ' ' }; puts
puts tree.level_order.join(' ')

puts '', 'Print in order', ''

tree.inorder { |node| print node.data, ' ' }; puts
puts tree.inorder.join(' ')

puts '', 'Print preorder', ''

tree.preorder { |node| print node.data, ' ' }; puts
puts tree.preorder.join(' ')

puts '', 'Print postorder', ''

tree.postorder { |node| print node.data, ' ' }; puts
puts tree.postorder.join(' ')

# 4. Unbalance the tree by adding several numbers > 100

puts '', 'Unbalance the tree', ''

5.times { tree.insert(rand(101..200)) }

pretty_print(tree.root)

# X. Test depth

5.times do
  val = array.sample
  puts '', "Depth of #{val} is #{tree.depth(tree.find(val))}", ''
end
