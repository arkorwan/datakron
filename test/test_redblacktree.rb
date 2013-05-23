require 'minitest/unit'
require_relative '../lib/red_black_tree.rb'
require_relative 'test_binarysearchtree.rb'

class TestEmptyRBT < TestEmptyBST
	def setup
		@tree = RedBlackTree.new
	end
end

class TestSimpleRBT < TestSimpleBST
	def setup
		@tree = RedBlackTree.new
		[1,2,3,4,5,6,7].each{|e| @tree.add(e)}
	end
end

class TestLargeRBT < MiniTest::Test
	
	class DataStructure::BinarySearchTree::RedBlackLeaf
		def valid_color_and_black_length
			[true, 1]
		end
	end

	class DataStructure::BinarySearchTree::RedBlackNode
		def valid_color_and_black_length
			v_left = @left.valid_color_and_black_length
			v_right = @right.valid_color_and_black_length
			v = v_left[0] && v_right[0] && (@color==0 || (@left.color==0 && @right.color==0)) && (v_left[1]==v_right[1])
			blacks = v_left[1]
			blacks+=1 if @color==0
			[v, blacks]
		end
	end


	def setup
		@tree = RedBlackTree.new
		100000.times{
			@tree.add(rand)
		}
	end

	def test_validity
		assert @tree.root.valid_color_and_black_length[0]
	end
end
