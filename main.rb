require_relative './tree.rb'

##
# Pretty print method from The Odin Project lesson
def pretty_print(node = @root, prefix = '', is_left = true)
  pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
  puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
  pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
end
##

tree = Tree.new((1..20).to_a.sample(10))

pretty_print(tree.root)
