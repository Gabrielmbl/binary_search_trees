class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
  
  
end

class Tree
  attr_accessor :root
  
  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(sorted_array)
    return nil if sorted_array.empty?

    mid = sorted_array.length / 2
    root = Node.new(sorted_array[mid])
    root.left = build_tree(sorted_array[0...mid])
    root.right = build_tree(sorted_array[mid+1..-1])

    root
  end

  def insert(value, node = @root)
    return Node.new(value) if node.nil?

    if value < node.data
      node.left = insert(value, node.left)
    elsif value > node.data
      node.right = insert(value, node.right)
    end

    node
  end

  def delete(value, node = @root)
    return node if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      if node.left.nil?
        return node.right
      elsif node.right.nil?
        return node.left
      end

      node.data = min_value(node.right)
      node.right = delete(node.data, node.right)
    end

    node
  end


  def min_value(node)
    current = node
    current = current.left until current.left.nil?
    current.data
  end

  def find(value, node = @root)
    return nil if node.nil?

    if value < node.data
      find(value, node.left)
    elsif value > node.data
      find(value, node.right)
    else
      node
    end
  end

  def level_order(&block)
    return [] unless @root

    result = []
    queue = [@root]

    while !queue.empty?
      node = queue.shift
      block_given? ? yield(node) : result << node.data

      queue << node.left if node.left
      queue << node.right if node.right
    end

    result unless block_given?
  end

  def inorder(node = @root, array = [])
    return array if node.nil?
  
    inorder(node.left, array)
    array << node.data
    inorder(node.right, array)
  
    array
  end
  

  def preorder(node = @root, &block)
    return if node.nil?
  
    if node.is_a?(Node)
      yield(node) if block_given?
      preorder(node.left, &block)
      preorder(node.right, &block)
    else
      yield(node)
    end
  end

  def postorder(node = @root, &block)
    return if node.nil?
  
    if node.is_a?(Node)
      postorder(node.left, &block)
      postorder(node.right, &block)
      yield(node) if block_given?
    else
      yield(node)
    end
  end

  def height(node = @root)
    return -1 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    [left_height, right_height].max + 1
  end

  def depth(node)
    return 0 if node.nil?
    return 0 if node == @root

    parent = find_parent(@root, node)
    1 + depth(parent)
  end

  def find_parent(current, node)
    return nil if current.nil?
    return current if current.left == node || current.right == node

    left = find_parent(current.left, node)
    return left unless left.nil?

    right = find_parent(current.right, node)
    return right unless right.nil?
  end

  def balanced?
    check_balanced(@root) != -1
  end

  def check_balanced(node)
    return 0 if node.nil?

    left_height = check_balanced(node.left)
    return -1 if left_height == -1

    right_height = check_balanced(node.right)
    return -1 if right_height == -1

    diff = (left_height - right_height).abs
    return -1 if diff > 1

    [left_height, right_height].max + 1
  end
  
  def rebalance
    sorted_nodes = inorder(@root)
    @root = build_tree(sorted_nodes)
  end
  
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end



puts "\n1: Create a binary search tree from an array of random numbers"
array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)

puts "\n2: Confirm that the tree is balanced by calling #balanced? #{tree.balanced?}"

puts "\n3: Print out all elements in level, pre, post, and in order"
puts "\nLevel order traversal:"
tree.level_order { |node| print "#{node.data} " }
puts "\n\nPreorder traversal:"
tree.preorder { |node| print "#{node.data} " }
puts "\n\nPostorder traversal:"
tree.postorder { |node| print "#{node.data} " }
puts "\n\nInorder traversal:"
tree.inorder { |node| print "#{node.data} " }

puts "\n4: Unbalance the tree by adding several numbers > 100"
[101, 102, 103, 104].each { |num| tree.insert(num) }

puts "\n\n5: Confirm that the tree is unbalanced by calling #balanced?: #{tree.balanced?}"

puts "\n6: Balance the tree by calling #rebalance"
tree.rebalance

puts "\n\n7: Confirm that the tree is balanced by calling #balanced? #{tree.balanced?}"
puts "\nBalanced tree:"
tree.pretty_print

puts "\n8: Print out all elements in level, pre, post, and in order."
puts "\nLevel order traversal of balanced tree:"
tree.level_order { |node| print "#{node.data} " }
puts "\n\nPreorder traversal of balanced tree:"
tree.preorder { |node| print "#{node.data} " }
puts "\n\nPostorder traversal of balanced tree:"
tree.postorder { |node| print "#{node.data} " }
puts "\n\nInorder traversal of balanced tree:"
tree.inorder { |node| print "#{node.data} " }

