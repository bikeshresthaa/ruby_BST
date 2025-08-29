require_relative 'node'

class Tree
  attr_accessor :root, :array, :start, :last

  def initialize(array)
    @array = array.uniq.sort
    @start = @array.index(@array.first)
    @last = @array.index(@array.last)
  end

  def build_tree(array, start, last)
    return if start > last
    mid = (start + last) / 2
    root = Node.new(array[mid])
    root.left_child = build_tree(array, start, mid - 1)
    root.right_child = build_tree(array, mid + 1, last)

    return root
  end

  def array_to_bst
    @root = build_tree(@array, @start, @last)
  end

  def pre_order(root)
    return if root.nil?
    puts root.data
    pre_order(root.left_child)
    pre_order(root.right_child)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end


end

tree = Tree.new([9,8,7,6,5,4,3,2,1,0])

tree.array_to_bst
tree.pretty_print
