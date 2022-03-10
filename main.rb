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

puts 'Create a binary search tree from an array of random numbers', ''

tree = Tree.new(Array.new(15) { rand(1..100) })

pretty_print(tree.root)

# 4. Unbalance the tree by adding several numbers > 100

puts '', 'Unbalance the tree', ''

5.times { tree.insert(rand(101..200)) }

pretty_print(tree.root)

# 4.1 Test delete

puts '', 'Delete node', ''

print 'Select value: '; val = gets.strip.to_i

tree.delete(val)

pretty_print(tree.root)
