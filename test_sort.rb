require 'Test/Unit'
require_relative 'recursive_quicksort'
require_relative 'iterative_quicksort'
require_relative 'official_quicksort'

class TestSort < Test::Unit::TestCase

    def test_empty_array
        assert_sort([], [])
    end
    
    def test_single_elements
        assert_sort([1], [1])
    end

    def test_two_elements_sorted
        assert_sort([1, 2], [1, 2])
    end
    
    def test_two_elements_unsorted
        assert_sort([2, 1], [1, 2])
    end
    
    def test_two_elements_equal
        assert_sort([1, 1], [1, 1])
    end

    def test_three_elements_123() assert_sort([1, 2, 3], [1, 2, 3]) end
    def test_three_elements_132() assert_sort([1, 3, 2], [1, 2, 3]) end
    def test_three_elements_213() assert_sort([2, 1, 3], [1, 2, 3]) end
    def test_three_elements_231() assert_sort([2, 3, 1], [1, 2, 3]) end
    def test_three_elements_312() assert_sort([3, 1, 2], [1, 2, 3]) end
    def test_three_elements_321() assert_sort([3, 2, 1], [1, 2, 3]) end
    
    def test_four_elements
        assert_sort([1, 2, 3, 4], (1..4).to_a)
        assert_sort([4, 3, 2, 1], (1..4).to_a)
    end
    
    def test_five_elements
        assert_sort([1, 2, 3, 4, 5], (1..5).to_a)
        assert_sort([5, 4, 3, 2, 1], (1..5).to_a)
    end
    
    def test_six_elements
        assert_sort([1, 2, 3, 4, 5, 6], (1..6).to_a)
        assert_sort([6, 5, 4, 3, 2, 1], (1..6).to_a)
    end
    
    def test_seven_elements
        assert_sort([1, 2, 3, 4, 5, 6, 7], (1..7).to_a)
        assert_sort([7, 6, 5, 4, 3, 2, 1], (1..7).to_a)
    end
    
    def test_ten_elements
        assert_sort([8, 3, 5, 4, 10, 1, 6, 7, 2, 9], (1..10).to_a)
    end
    
    def test_ten_elements_partially_sorted
        assert_sort([1, 2, 3, 4, 8, 5, 10, 6, 7, 9], (1..10).to_a)
    end
    
    def test_1000_elements
        random_elements = (Array.new(1000) { rand(1...1000) })
        instantiate_sort_strategy.sort(random_elements)
        assert_equal(1000, random_elements.length)
        assert_ordered_numbers(random_elements)
    end
    
    private

    def instantiate_sort_strategy
        OfficialQuicksort.new
    end

    def assert_sort(elements_passed, expected_elements)
        instantiate_sort_strategy.sort(elements_passed)
        assert_equal(expected_elements, elements_passed)
    end
    
    def assert_ordered_numbers(numbers)
        previous_value = 0
        numbers.each do |next_value| 
            assert_compare(previous_value, "<=", next_value)
            previous_value = next_value
        end
    end
end