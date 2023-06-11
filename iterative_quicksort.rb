class IterativeQuicksort
    def sort(elements)
        initial_start_index = 0
        initial_end_index = elements.length - 1        
        if initial_start_index >= initial_end_index
            return
        end
        subsets_to_sort = [[initial_start_index, initial_end_index]]
        while subsets_to_sort.length > 0
            start_index, end_index = subsets_to_sort.pop
            sort_subset_around_pivot(elements, subsets_to_sort, start_index, end_index)
        end
    end
    
    private

    def sort_subset_around_pivot(elements, subsets_to_sort, start_index, end_index)
        pivot_index = (end_index + start_index).div(2)
        pivot_value = elements[pivot_index]
        left_set_end_index = pivot_index - 1
        right_set_start_index = pivot_index + 1
        
        # Move elements LARGER than pivot from pivot LEFT to RIGHT
        current_index = start_index
        while current_index <= left_set_end_index && current_index < pivot_index
            current_value = elements[current_index]
            if current_value > pivot_value
                elements[pivot_index] = current_value
                pivot_index -= 1
                elements[current_index] = elements[pivot_index]
            else
                current_index += 1
            end
        end

        # Move elements SMALLER than pivot from pivot RIGHT to LEFT
        current_index = end_index
        while current_index >= right_set_start_index && current_index > pivot_index
            current_value = elements[current_index]
            if current_value < pivot_value
                elements[pivot_index] = current_value
                pivot_index += 1
                elements[current_index] = elements[pivot_index]
            else
                current_index -= 1
            end
        end

        # Set new pivot
        elements[pivot_index] = pivot_value

        # Queue subsets either side of pivot
        if (pivot_index > start_index + 1)
            subsets_to_sort.push([start_index, pivot_index - 1])
        end
        if (pivot_index < end_index - 1)
            subsets_to_sort.push([pivot_index + 1, end_index])
        end
    end
end