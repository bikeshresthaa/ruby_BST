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

  def pre_order(root = @root, visited = [], &block)
    return root if root.nil?
    block_given? ? block.call(root) : visited << root
    pre_order(root.left_child, visited, &block) if !root.left_child.nil?
    pre_order(root.right_child, visited, &block) if !root.right_child.nil?
    return visited if !block_given?
  end

  def inorder(root = @root, visited = [], &block)
    return if root.nil?
    inorder(root.left_child, visited, &block)
    block_given? ? block.call(root) : visited << root
    inorder(root.right_child, visited, &block)
    return visited unless block_given?
  end

  def postorder(root = @root, visited = [], &block)
    return root if root.nil?
    postorder(root.left_child, visited, &block)
    postorder(root.right_child, visited, &block)
    block_given? ? block.call(root) : visited << root
    return visited unless block_given?
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

  def level_order_recursion(queue = [@root], visited_nodes = [], &block)
    root = queue.shift
    return root if root.nil? && block
    return visited_nodes if root.nil? && !block
    block ? block.call(root) : visited_nodes << root.data
    queue << root.left_child if !root.left_child.nil?
    queue << root.right_child if !root.right_child.nil?
    level_order_recursion(queue, visited_nodes, &block)
  end

  def height(node = @root.data)
    found = find(node)
    found ? get_height(found) : found
  end

  def get_height(root)
    return -1 if root.nil?
    left_height = get_height(root.left_child) 
    right_height = get_height(root.right_child) 
    return ( [left_height, right_height].max + 1 )
  end

  def depth(root = @root, deep = 0, key)
    return root if root.nil?
    if root.data == key
      return deep
    elsif root.data > key
      return depth(root.left_child, deep + 1, key)
    else
      return depth(root.right_child, deep + 1, key)
    end
  end
end

tree = Tree.new([0,1,2,3,4,5,6,7,8,9])
tree.array_to_bst
tree.pretty_print
p tree.depth(4)
