class OfficialQuicksort
    def sort(elements)
        start_index = 0
        end_index = elements.length - 1
        quicksort(elements, start_index, end_index)
    end

    def quicksort(elements, start_index, end_index)
        if start_index < end_index
          pivot_index = partition(elements, start_index, end_index)
          quicksort(elements, start_index, pivot_index - 1)
          quicksort(elements, pivot_index + 1, end_index)
        end
    end

    def partition(elements, start_index, end_index)
        initial_pivot_index = (end_index + start_index).div(2)
        pivot_value = elements[initial_pivot_index] 
        pivot_index = start_index
        current_index = start_index
        while current_index <= end_index
            current_value = elements[current_index] 
            if current_value <= pivot_value && current_index != initial_pivot_index
                elements[current_index] = elements[pivot_index]
                elements[pivot_index] = current_value
                pivot_index += 1
                if pivot_index == initial_pivot_index
                    pivot_index += 1
                end
            end
            current_index += 1
        end
        if pivot_index > initial_pivot_index
            pivot_index = pivot_index - 1
        end
        swap_temp = elements[pivot_index]
        elements[pivot_index] = pivot_value
        elements[initial_pivot_index] = swap_temp
        return pivot_index
    end
end
