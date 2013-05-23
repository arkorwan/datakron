module DataStructure

  module BinarySearchTree

    module Direction
      NIL={:id=>0}
      LEFT={:id=>1, :retrieve=>:left, :assign=>:"left=" }
      RIGHT={:id=>2, :retrieve=>:right, :assign=>:"right=" }
      LEFT[:reverse]=RIGHT
      RIGHT[:reverse]=LEFT
    end

    require 'singleton'
    # A singleton Leaf for all trees. Hold no values.
    class Leaf
      include Singleton

      def leaf?
        true
      end

      def height
        0
      end

      def to_s
        "Leaf"
      end

      def inspect
        to_s
      end

    end

    class Node

      attr_accessor :left, :right, :parent
      attr_reader :key, :tree

      def initialize(tree, key, level=0)
        @tree=tree
        @key=key
        @left=leaf_instance
        @right=leaf_instance
      end

      def leaf?
        false
      end

      def leaf_instance
        Leaf.instance
      end

      # Recursive - might throw StackLevelTooDeep!
      def height
        [@left.height,@right.height].max+1
      end

      def sibling
        if @parent==nil
          nil
        else
          @parent.left==self ? @parent.right : @parent.left
        end
      end

      def get_child(direction)
        self.send(direction[:retrieve])
      end

      def set_child(direction, node)
        self.send(direction[:assign], node)
      end

      # add a new Node with the specified key on the appropriate side
      # do nothing if there's already a child Node on that side, or if the key is the same as this Node

      def add_child(key)
        if key<@key && @left.leaf?
          @left=Node.new(@tree, key)
          @left.parent=self
        elsif key>@key && @right.leaf?
          @right=Node.new(@tree, key)
          @right.parent=self
        end
      end

      # Remove this node. Reassign parent-child relationship for all Nodes involved,
      # including the root property of the tree
      def delete
        if @left.leaf? && @right.leaf?
          if @parent==nil
            @tree.root=leaf_instance
          elsif @parent.left==self
            @parent.left=leaf_instance
          else
            @parent.right=leaf_instance
          end
        elsif @left.leaf?
          @right.reset_parent(@parent)
        elsif @right.leaf?
          @left.reset_parent(@parent)
        else
          cascade_node = rand > 0.5 ? previous_node : next_node
          copy_value_from(cascade_node)
          cascade_node.delete
        end
      end

      def copy_value_from(node)
        @key = node.key
      end

      def next_node
        next_order(Direction::RIGHT)
      end

      def previous_node
        next_order(Direction::LEFT)
      end

      # Find the closest in-order Node in the specified direction (:left / :right)
      def next_order(direction)
        if get_child(direction).leaf?
          parent=@parent
          node=self
          parent,node=parent.parent,parent while parent!=nil && parent.get_child(direction)==node
          parent #could be nil
        else
          parent=self
          node=get_child(direction)
          parent,node=node,node.get_child(direction[:reverse]) until node.leaf?
          parent
        end
      end

      def rotate(direction)
        child=get_child(direction[:reverse])
        set_child(direction[:reverse], child.get_child(direction))
        get_child(direction[:reverse]).parent = self unless get_child(direction[:reverse]).leaf?
        child.reset_parent(@parent)
        child.set_child(direction, self)
        @parent=child
        #child=self.send(r_direction)
        #self.send(r_assign, child.send(direction))
        #self.send(r_direction).parent = self unless self.send(r_direction).leaf?
        #child.reset_parent(@parent)
        #child.send(assign, self)
        #@parent=child
      end

      def rotate_left
        rotate(Direction::LEFT)
      end

      def rotate_right
        rotate(Direction::RIGHT)
      end

      def reset_parent(parent)
        if parent==nil
          @tree.root=self
          @parent=nil
        elsif @key<parent.key
          parent.left=self
          @parent=parent
        elsif @key>parent.key
          parent.right=self
          @parent=parent
        end
      end

    end #class Node

    class BinarySearchTree

      attr_accessor :not_found_policy, :root
      attr_reader :size

      def initialize(policy=Direction::NIL)
        @root=Leaf.instance
        @not_found_policy=policy
        @size=0
      end

      def empty?
        @size==0
      end

      def height
        @root.height
      end

      def create_root_node(key)
        @root=Node.new(self,key)
      end

      def traverse_node(key)
        node=@root
        parent_node=nil

        until node.leaf?
          if key<node.key
            parent_node=node
            node=node.left
          elsif key>node.key
            parent_node=node
            node=node.right
          else
            break
          end
        end

        {:node=>node, :parent_node=>parent_node, :found=>!node.leaf?}

      end

      def add(key)
        result=traverse_node(key)
        if !result[:found]
          if result[:node]==@root
            create_root_node(key)
          else
            result[:parent_node].add_child(key)
          end
          @size+=1
        end
      end

      def delete(key)
        result=traverse_node(key)
        if result[:found]
          result[:node].delete
          @size-=1
        end
      end

      def min
        get_min_or_max(:left)
      end

      def max
        get_min_or_max(:right)
      end

      def get(key)
        result = traverse_node(key)
        if result[:found]
          result[:node]
        else
          handle_not_found(result[:parent_node], key)
        end
      end

      private

      def get_min_or_max(direction)
        if empty?
          nil
        else
          node=@root
          parent_node=node.parent
          until node.leaf?
            parent_node=node
            node=node.send(direction)
          end
          parent_node
        end
      end

      def handle_not_found(parent_node, key)
        return nil if parent_node==nil

        case @not_found_policy[:id]
        when Direction::NIL[:id]
          nil
        when Direction::LEFT[:id]
          key<parent_node.key ? parent_node.previous_node : parent_node
        when Direction::RIGHT[:id]
          key<parent_node.key ? parent_node : parent_node.next_node
        end
      end

    end #class BinarySearchTree

  end #module BinarySearchTree

end #module DataStructure

