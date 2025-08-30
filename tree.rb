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

  def insert(root = @root, key)
    return Node.new(key) if root.nil?
    return root if root.data == key
    if key > root.data
      root.right_child = insert(root.right_child, key)
    else
      root.left_child = insert(root.left_child, key)
    end
    root
  end

  def in_order_successor(node)
    successor = node.right_child
    while successor && successor.left_child
      successor = successor.left_child
    end
    successor
  end

  def delete(root = @root, key)
    return root if root.nil?

    if key > root.data
      root.right_child = delete(root.right_child, key)
    elsif key < root.data
      root.left_child = delete(root.left_child, key)
    else
      if root.left_child == nil
        return root.right_child
      end
      if root.right_child == nil
        return root.left_child
      end

      successor = in_order_successor(root)
      root.data = successor.data
      root.right_child = delete(root.right_child, successor.data)
    end
    root
  end

  def find_by_iteration(root = @root, key)
    while root
      return root if root.data == key
      if root.data > key
        root = root.left_child
      else
        root = root.right_child
      end
    end
    return root if root.nil?
  end

  def find(root = @root, key)
    return root if root.nil?
    if root.data == key
      return root
    elsif root.data < key
      find(root.right_child, key)
    else
      find(root.left_child, key)
    end
  end
  
  def level_order
    block = block_given?
    root = @root
    return root if root.nil?
    queue = [root]
    visited_nodes = []
    while !queue.empty?
      root = queue.shift
      queue.push(root.left_child) if !root.left_child.nil?
      queue.push(root.right_child) if !root.right_child.nil?
      block ? yield(root) : visited_nodes << root
    end
    visited_nodes if !block
  end

  def level_order_recursion(root = @root, res = [], level = 0)
    return res if root.nil?
    res.push([]) if res.length <= level
    res[level] << root.data
    level_order_recursion(root.left_child, res, level + 1)
    level_order_recursion(root.right_child, res, level + 1)
  end
end

tree = Tree.new([1,2,3,4,5,6,7,8,9])
tree.array_to_bst
tree.pretty_print
p tree.level_order_recursion