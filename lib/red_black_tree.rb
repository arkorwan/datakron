require_relative 'binary_search_tree'

module DataStructure
  
  module BinarySearchTree
  
    class RedBlackLeaf < Leaf
      def color
        0
      end
      
    end
  
    class RedBlackNode < Node
      
      attr_accessor :color
      
      def initialize(tree, key, color)
        super(tree,key)
        @color=color
      end

      def leaf_instance
        RedBlackLeaf.instance
      end
      
      def add_child(key)
        if key==@key
          return
        elsif key<@key
            @left=RedBlackNode.new(@tree, key, 1)
            @left.parent=self
            @left.rebalance_add
        else
          @right=RedBlackNode.new(@tree, key, 1)
          @right.parent=self
          @right.rebalance_add
        end
      end
      
      def delete
        direction = @parent!=nil && @parent.left==self ? Direction::LEFT : Direction::RIGHT
        internal = !@left.leaf? && !@right.leaf?
        super
        if @color==0 && !internal && @parent!=nil
          if @parent.get_child(direction).color==1
            @parent.get_child(direction).color=0
          else
            @parent.rebalance_delete(direction)
          end
        end
      end
      
      protected
      def rebalance_add
        if @parent==nil
          @color=0
        elsif @parent.color==1
          uncle=@parent.sibling
          if uncle.color==1
            @parent.color=0
            uncle.color=0
            @parent.parent.color=1
            @parent.parent.rebalance_add
          else
            if @parent.right==self && @parent.parent.left==@parent
              @parent.rotate_left
              @color=0
              @parent.color=1
              @parent.rotate_right
            elsif @parent.left==self && @parent.parent.right==@parent
              @parent.rotate_right
              @color=0
              @parent.color=1
              @parent.rotate_left
            else
              @parent.color=0
              @parent.parent.color=1
              if @parent.right==self
                @parent.parent.rotate_left
              else
                @parent.parent.rotate_right
              end
            end
          end
        end
      end
      
      def rebalance_delete(direction)
        
        sibling_node = get_child(direction[:reverse])
        
        if sibling_node.color==1
          sibling_node.color=0
          @color=1
          rotate(direction)
          sibling_node=get_child(direction[:reverse])
        end
        
        if sibling_node.left.color==0 && sibling_node.right.color==0
          sibling_node.color=1
          if @color==0
            if @parent!=nil
              if @parent.left==self
                @parent.rebalance_delete(Direction::LEFT)
              else
                @parent.rebalance_delete(Direction::RIGHT)
              end
            end
          else
            @color=0
          end
        else
          
          if sibling_node.get_child(direction[:reverse]).color==0
            sibling_node.get_child(direction).color=0
            sibling_node.color=1
            sibling_node.rotate(direction[:reverse])
            sibling_node=get_child(direction[:reverse])
          end
          sibling_node.color=@color
          @color=0
          sibling_node.get_child(direction[:reverse]).color=0
          rotate(direction)
          
        end

      end
      
    end
  
    class RedBlackTree < BinarySearchTree
      
      def create_root_node(key)
        @root=RedBlackNode.new(self,key,0)
      end
      
    end

  end #Module BinarySearchTree
  
end #module DataStructure
