class Node
  include Comparable

  attr_accessor :data
  attr_accessor :right
  attr_accessor :left

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    self.data <=> other.data
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  private

  # Recursive implementation
  # def build_tree(array)
  #   return nil if array == []
  #   return Node.new(array.first) if array.length == 1

  #   mid = array.length / 2
  #   Node.new(array[mid], build_tree(array[0...mid]), build_tree(array[(mid+1)..]))
  # end

  def build_tree(array)
    ##
    # First, sets up the root node from the middle of the (assumed sorted) array.
    # Then continuously appends left-side nodes, while adding the righthand part of the array on a stack; until there are no more 'left' data left.
    # When that happens, gets previous node from stack and starts building its right subtree with this same process. 
    ##
 
    return nil if array.nil? || array.empty?

    last = array.length - 1
    middle = last / 2

    @root = node = Node.new(array[middle])  # create root, set up (current) node variable

    stack = [[node, middle + 1, last]] # setup stack; add right side to stack

    # set up loop variables
    first, last = 0, middle - 1
    to_branch = :left=

    loop do
      # terminaton conditions
      if last - first < 0 # can't create subtree from negative range, should contnue from stack
        break if stack.empty? # terminate process if there's nothing remaining in stack

        # otherwise, pop stack to create right subtree
        node, first, last = stack.pop
        to_branch = :right=
        next  # restart loop
      end

      middle = (first + last) / 2
      node = node.send(to_branch, Node.new(array[middle]))  # set new node to left branch of previous, then assign it to be current node
      stack << [node, middle + 1, last] # push right side to stack
      
      # set up next loop
      last = middle - 1
      to_branch = :left=
    end
    root
  end
end
