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

  def insert(value)
    node = Node.new(value)
    current = @root

    loop do
      case node <=> current
      when -1
        current.left = node if current.left.nil?
        current = current.left
      when 0
        return current
      when 1
        current.right = node if current.right.nil?
        current = current.right
      end
    end
  end

  # Searches for a value, emiting nodes along the path to block
  # Returns the value's node if found
  def path(value, start_node = nil)
    node = start_node || @root
    until node.nil?
      return node if node.data == value

      yield node if block_given?

      node = value < node.data ? node.left : node.right
    end
  end

  def find(value)
    path(value)
  end

  # Deletes a node from the tree. Returns the deleted node
  def delete(value, start_node = nil)
    parent = nil

    node = path(value, start_node) { |path_node| parent = path_node } # find target node and it's parent

    return if node.nil? # quit if no node is found

    # Proc to be called when a node's place is to be taken by another
    replace_with = Proc.new do |node, parent, replacement|
      if parent
        parent < node ? parent.right = replacement : parent.left = replacement
      else
        @root = replacement
      end
    end

    # delete
    case [node.left, node.right]
    in [nil, nil] | [_, nil] | [nil, _] # zero children, only one (L) child, only one (R) child
      # replace with child
      replace_with.call(node, parent, node.left || node.right)  # child is nil in zero children case
    else # two children
      # find next largest node
      successor_parent, successor = node, node.right
      loop do
        break if successor.left.nil?
        successor_parent, successor = successor, successor.left
      end

      # replace successor with its children, i.e. delete successor from its original place
      replace_with.call(successor, successor_parent, successor.left || successor.right)

      # replace node with successor
      successor.left = node.left    # copy links
      successor.right = node.right  #
      replace_with.call(node, parent, successor)
    end

    return node # return deleted node
  end

  def level_order
    queue = [@root]

    out = []

    until queue.empty?
      node = queue.shift
      queue << node.left if node.left
      queue << node.right if node.right
      if block_given?
        yield node
      else
        out << node.data
      end
    end

    out unless block_given? # return output array if a block wasn't provided
  end

  def inorder
    node, stack = @root, []

    output = []

    loop do
      break if node.nil? && stack.empty?

      unless node.nil?
        # drill to the left
        stack << node
        node = node.left
      else
        # pop, yield and continue to the right
        node = stack.pop
        unless node.nil?
          if block_given? then yield node else output << node.data end
          node = node.right
        end
      end
    end

    output unless block_given?
  end

  def preorder
    node = @root
    stack = []
    output = []

    loop do
      break if node.nil? && stack.empty?
      
      if block_given? then yield node else output << node.data end
    
      stack << node.right if node.right
      node = node.left || stack.pop
    end

    output unless block_given?
  end    

  def postorder(start = nil)
    node, command = start || @root, :visit
    stack = []
    output = []

    loop do
      break if node.nil? && stack.empty?

      case command
      when :visit
        stack << [node, :print]
        stack << [node.right, :visit] if node.right
        node, command = node.left && [node.left, :visit] || stack.pop
      when :print
        if block_given? then yield node else output << node.data end
        node, command = stack.pop
      end
    end

    output unless block_given?
  end

  def height(start)
    # Travese postorder; set parent nodes height as childrens' + 1 
    heights = []

    postorder(start) do |node|
      if node.left.nil? && node.right.nil?  # leaf node
        heights << 0
      else
        heights << [node.left && heights.pop || 0, node.right && heights.pop || 0].max + 1
      end
    end

    heights[0]
  end

  def depth(node)
    # Same as #find but count levels
    depth = 0
    current = @root
    until current == node || current.nil?
      current = node > current ? current.right : current.left
      depth += 1
    end
    depth
  end

  def balanced?
    # Same as #height, but check height difference at each parent
    heights = []

    postorder do |node|
      if node.left.nil? && node.right.nil?  # leaf node
        heights << 0
      else
        # parent
        right_subtree_height = node.right && heights.pop || 0 
        left_subtree_height = node.left && heights.pop || 0
        
        return false if (left_subtree_height - right_subtree_height).abs > 1  # foud one unbalanced node, whole tree is unbalanced

        heights << [left_subtree_height, right_subtree_height].max + 1
      end
    end

    true
  end

  def rebalance
    build_tree(inorder)
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
