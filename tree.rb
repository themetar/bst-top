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
  def build_tree(array)
    return nil if array == []
    return Node.new(array.first) if array.length == 1

    mid = array.length / 2
    Node.new(array[mid], build_tree(array[0...mid]), build_tree(array[(mid+1)..]))
  end
end
