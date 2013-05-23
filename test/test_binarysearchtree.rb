require 'minitest/unit'
require_relative '../lib/binary_search_tree.rb'

include DataStructure::BinarySearchTree


class TestEmptyBST < MiniTest::Test
	def setup
		@tree = BinarySearchTree.new
	end

	def test_empty
		assert_empty @tree
	end

	def test_size
		assert_equal 0, @tree.size
	end

	def test_root
		assert @tree.root.leaf?
	end

	def test_min
		assert_nil @tree.min
	end

	def test_max
		assert_nil @tree.max
	end
end

class TestSimpleBST < MiniTest::Test

	def setup
		@tree = BinarySearchTree.new
		[4,3,1,2,5,7,6].each{|e| @tree.add(e)}
	end

	def test_size
		assert_equal 7, @tree.size
	end

	def test_min
		assert_equal 1, @tree.min.key
	end

	def test_max
		assert_equal 7, @tree.max.key
	end

	def test_forward_order
		node = @tree.min
		expect = 1
		while node!=nil
			assert_equal expect, node.key
			node = node.next_node
			expect+=1
		end
		assert_equal 8, expect
	end

	def test_backward_order
		node = @tree.max
		expect = 7
		while node!=nil
			assert_equal expect, node.key
			node = node.previous_node
			expect-=1
		end
		assert_equal 0, expect
	end

	def test_handle_not_found_using_nil
		@tree.not_found_policy = Direction::NIL
		assert_equal 3, @tree.get(3).key
		assert_nil @tree.get(3.5)
	end

	def test_handle_not_found_using_left
		@tree.not_found_policy = Direction::LEFT
		assert_equal 3, @tree.get(3).key
		assert_equal 3, @tree.get(3.5).key
		assert_nil @tree.get(0.5)
		assert_equal 7, @tree.get(7.5).key
	end

	def test_handle_not_found_using_right
		@tree.not_found_policy = Direction::RIGHT
		assert_equal 3, @tree.get(3).key
		assert_equal 4, @tree.get(3.5).key
		assert_equal 1, @tree.get(0.5).key
		assert_nil @tree.get(7.5)
	end


end
