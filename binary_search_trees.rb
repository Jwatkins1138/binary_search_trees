class Node
  
  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  attr_accessor :value 
  attr_accessor :left 
  attr_accessor :right

  def left(node)
    @left = node
  end

  def right(node)
    @right = node
  end

  def get_value
    return @value
  end

  def get_left
    return @left
  end

  def get_right
    return @right
  end

end

class Tree

  def initialize(array)
    @root = build_tree(array)
  end

  attr_accessor :root
  attr_accessor :p_array

  def build_tree(array)
    array = array.sort.uniq
    if array.empty?
      return nil
    end 
    mid = (array.length - 1)/2
    tmp_root = Node.new(array[mid])
    tmp_root.left(build_tree(array[0 ... mid]))
    tmp_root.right(build_tree(array[(mid + 1) ... (array.length)]))
    return tmp_root
  end

  def search(value, node = @root)
    if node == nil
      return "no match"
    elsif node.get_value == value
      return node
    elsif node.get_value > value
      search(value, node.get_left)
    elsif node.get_value < value
      search(value, node.get_right)
    end
  end

  def find_parent(node)
    level_order_node { |x| 
      if x.get_left == node || x.get_right == node
        return x
      end}
  end

  def find_next(value)
    ordered_array = inorder()
    if value == ordered_array[-1]
      return nil
    else
      return search(ordered_array[ordered_array.index(value) + 1])
    end
  end

  def insert(value, node = @root)
    if value == node.get_value
      p "duplicate value"
    elsif value < node.get_value
      if node.get_left == nil
        node.left(Node.new(value))
      else 
        insert(value, node.get_left)
      end
    elsif value > node.get_value
      if node.get_right == nil
        node.right(Node.new(value))
      else
        insert(value, node.get_right)
      end
    end
  end

  def delete(value)
    node = search(value)
    if node == "no match"
      p node
      return
    end
    next_node = find_next(value)
    next_parent = find_parent(next_node)
    if node == @root
      next_parent.left(nil)
      next_node.left(node.get_left)
      next_node.right(node.get_right)
      @root = next_node
    else
      parent = find_parent(node)
      if parent.get_left == node
        is_left = true
      end
      if node.get_left == nil && node.get_right == nil
        if is_left
          parent.left(nil)
        else 
          parent.right(nil)
        end
      elsif node.get_left != nil && node.get_right == nil
        if is_left
          parent.left(node.get_left)
        else
          parent.right(node.get_left)
        end
      elsif node.get_left == nil && node.get_right != nil
        if is_left
          parent.left(node.get_right)
        else
          parent.right(node.get_right)
        end
      elsif node.get_left != nil && node.get_right != nil
        if is_left 
          next_node.left(node.get_left)
          next_node.right(node.get_right)
          parent.left(next_node)
          next_parent.left(nil)
        else
          next_node.left(node.get_left)
          next_node.right(node.get_right)
          parent.right(next_node)
          next_parent.left(nil)
        end
      end
    end
  end



  def level_order(&block)
    node_que = Array.new
    node_que.push(@root)
    out_array = Array.new
    while node_que.length > 0
      if block_given?
        yield node_que[0].get_value
      else
        out_array.push(node_que[0].get_value)
      end
      if node_que[0].get_left != nil
        node_que.push(node_que[0].get_left)
      end
      if node_que[0].get_right != nil
        node_que.push(node_que[0].get_right)
      end
      node_que.shift
    end
    if !block_given?
      out_array
    end
  end

  def level_order_node(&block)
    node_que = Array.new
    node_que.push(@root)
    out_array = Array.new
    while node_que.length > 0
      if block_given?
        yield node_que[0]
      else
        out_array.push(node_que[0].get_value)
      end
      if node_que[0].get_left != nil
        node_que.push(node_que[0].get_left)
      end
      if node_que[0].get_right != nil
        node_que.push(node_que[0].get_right)
      end
      node_que.shift
    end
    if !block_given?
      out_array
    end
  end

  def preorder(node = @root, out_array = Array.new, &block)
    if node == nil
      return
    end
    if block_given?
      yield node.get_value
    else
      out_array.push(node.get_value)
    end
    preorder(node.get_left, out_array, &block)
    preorder(node.get_right, out_array, &block)
    if !block_given?
      out_array
    end
  end

  def inorder(node = @root, out_array = Array.new, &block)
    if node == nil
      return
    end
    inorder(node.get_left, out_array, &block)
    if block_given?
      yield node.get_value
    else
      out_array.push(node.get_value)
    end
    inorder(node.get_right, out_array, &block)
    if !block_given?
      out_array
    end
  end

  def postorder(node = @root, out_array = Array.new, &block)
    if node == nil
      return
    end
    postorder(node.get_left, out_array, &block)
    postorder(node.get_right, out_array, &block)
    if block_given?
      yield node.get_value
    else
      out_array.push(node.get_value)
    end
    if !block_given?
      out_array
    end
  end

  def height(node = @root)
    if node == nil
      return -1
    else
      left = (height(node.get_left))
      right = (height(node.get_right))
      if left > right
        return left + 1
      else
        return right + 1
      end
    end
  end

  def left_height
    height(@root.get_left)
  end

  def depth(target, node = @root, counter = 0)
    value = target.get_value
    if node == nil
      return "no match"
    elsif node.get_value == value
      return counter
    elsif node.get_value > value
      counter += 1
      p counter
      depth(target, node.get_left, counter)
    elsif node.get_value < value
      counter += 1
      p counter
      depth(target, node.get_right, counter)
    end

  end

  def balanced?(node = @root)
    lheight = height(@root.get_left)
    rheight = height(@root.get_right)
    p lheight
    p rheight
    if (-1..1).include?(lheight - rheight)
      return true
    else
      return false
    end
  end

  def rebalance
    build_array = level_order()
    @root = build_tree(build_array)

  end

  def display
    p @root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.get_right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.get_right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.get_value}"
    pretty_print(node.get_left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.get_left
  end

end

#driver script

tree = Tree.new(Array.new(15) { rand(1..100) })

tree.pretty_print

p "tree is currently balanced? : #{tree.balanced?}"
p tree.level_order
p tree.preorder
p tree.inorder
p tree.postorder

tree.insert(rand(50..100))
tree.insert(rand(50..100))
tree.insert(rand(50..100))
tree.insert(rand(50..100))
tree.insert(rand(50..100))
tree.insert(rand(50..100))


tree.pretty_print

p "tree is currently balanced? : #{tree.balanced?}"

tree.rebalance

p "tree is currently balanced? : #{tree.balanced?}"

tree.pretty_print
p tree.level_order
p tree.preorder
p tree.inorder
p tree.postorder

