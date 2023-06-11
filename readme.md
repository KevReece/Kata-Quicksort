QuickSort Kata
===

Note: the following is a personal "offline" attempt to analyse and implement
quicksort, and should not be taken as an efficient/accurate algorithm.

Problem
---

Given a list of items in memory, sort the items in-place efficiently.

Quicksort high-level
---

The quicksort algorithm uses a selected pivot element to bisect the input set
into the left and right of the pivot, and then the left elements are iterated
and moved right of the pivot where greater than pivot value, the reverse is then
done for the right side, such that the result is left and right set are
sorted relative to the pivot. The left set, and subsequently the right set, is
then recursed into with the same pivot sort. The recursion continues until all the
sets are single elements, and therefore the input set is fully sorted.

The strategy to select the pivot can simply be the middle element, the median
element, a random element, or an element chosen based on expectations of the
initial state of the set (advantages/disadvantages discussed below).

Quicksort deeper dive
---

### Time Complexity

The driver of the quantity of iterations and therefore time complexity is the
number of layers of recursion required, and the number of item operations per
recursion layer. 

The number of item operations needed for a recursion layer is all the items
(minus the current layer and prior layer pivots). The number of recursion levels
for a median pivot strategy will tend to `sqrt(n)` as it would create a balanced
tree, but this would require an additional upfront complex operation to find the
first median, so instead I will describe complexity for a middle pivot strategy,
for which input ordering will affect the recursion tree balance.

- `O(n^2)` - The worst case will be `n` recursion layers, each with up to `n` item
operations. 
- `Omega(n*logn)` - The best case is where the pivot is a guess of the median
each time so that the recursion layer count is minimised to `sqrt(n)`.
- `Theta(n*logn)` - With random inputs the average layer would contain a 3/4 to
  1/4 balance, which is broadly logarithmic.

### Space Complexity

There should be no auxiliary costs greater than the input size therefore the
space complexity is `O(n)`.

### Pivot selection strategy

Changing the pivot selection strategy affects the number of layers of recursion,
by affecting the balance of the recursion tree. 

Using a median value maintains the best balance, and so is optimal vs
alternatives, but itself is a complex operation, possibly equal to sorting.

The index-based strategies (left, right, middle, random) are not based on input
values and therefore will have variable success in balancing the recursion
tree. Some upfront knowledge of the average input ordering would give better
results, for example, generally sorted inputs would be best handled by a middle
pivot strategy. Additionally, a random pivot strategy could protect against
end-user attempts to increase system load. 

In addition to the median strategy, there are some other value-based strategies
to consider. The mean strategy and mode strategy may be easier to calculate
than median, but don't have the same guarantees of tree balance, however, they
may approximate it.

Finally, a practical and good quality strategy would be a 'median of random
strategy', where a random set of inputs are chosen and the median of them is
used. Assuming no prior knowledge of the inputs, this strategy would give the
best recursion tree balance without compromising time complexity. The size of
the subset used could be chosen such that the median operation over it, is less
than the quicksort operation over the full input set, ensuring no time
complexity change. 

### Recursion vs Enumeration

The natural recursion here is tail recursion for in-place sorting, as there is
no post-processing required after recursing down. This means there is no
accumulation of allocated memory per recursion (There will however often be
accumulated language-specific pointers to the layers of recursed functions). 

As with all tail recursion the algorithm can instead be implemented as
enumeration for advantages in debugging the state of all pivots and sets
simultaneously, as well as seeing the level of recursion achieved. The
enumeration would be over a queue of tuples describing the range of elements
(and optionally recursion level for debugging). The enumeration comes at an
additional cost of the Space Complexity of the data sets queue. The queue will
be at its largest before the last recursion layer of a balanced recursion tree,
and so will reach at most `n/2` meaning the total space complexity remains as
`O(n)`.

### Test scenarios

- Extremes:
    - Empty array
    - Single element
- Fundamentals:
    - Two elements unsorted
    - Two elements sorted
    - Two items equal
    - Three elements all permutations
- Pivot bisections:
    - Four/Five/Six/Seven elements reversed
    - Four/Five/Six/Seven elements sorted
- Typical:
    - Ten elements mixed
    - Ten elements part sorted
    - 1000 elements mixed

Psuedo-code
---

```pseudo
elements: ARRAY OF NUMBER

start_index := 1
end_index := LENGTH(elements)
SortSubsetAroundPivot(start_index, end_index)

FUNCTION SortSubsetAroundPivot(start_index: integer, end_index: integer)
    pivot_index := FLOOR((end_index + start_index) / 2)
    pivot_value := elements[pivot_index]
    left_set_end_index = pivot_index - 1
    right_set_start_index = pivot_index + 1
    current_index = start_index
    WHILE current_index <= left_set_end_index AND current_index < pivot_index
        current_value := elements[current_index]
        IF current_value > pivot_value
            elements[pivot_index] := current_value
            pivot_index := pivot_index - 1
            elements[current_index] := elements[pivot_index]
        ELSE
            current_index := current_index + 1
        END IF
    END FOR
    current_index = end_index
    WHILE current_index >= right_set_start_index AND current_index > pivot_index
        current_value := elements[current_index]
        IF current_value < pivot_value
            elements[pivot_index] := current_value
            pivot_index := pivot_index + 1
            elements[current_index] := elements[pivot_index]
        ELSE
            current_index := current_index - 1
        END IF
    END FOR
    elements[pivot_index] := pivot_value
    IF (pivot_index > start_index + 1)
        SortSubsetAroundPivot(start_index, pivot_index - 1)
    END IF
    IF (pivot_index < end_index - 1)
        SortSubsetAroundPivot(pivot_index + 1, end_index)
    END IF
END FUNCTION
```

Iterative psuedocode
---
```pseudo
elements: ARRAY OF NUMBER

initial_start_index := 1
initial_end_index := LENGTH(elements)
subsets_to_sort = [(initial_start_index, initial_end_index)]

WHILE NOT EMPTY(subsets_to_sort)
    start_index, end_index := POP(subsets_to_sort)
    ... as in recursive ...
    IF (pivot_index > start_index + 1)
        PUSH(subsets_to_sort, (start_index, pivot_index - 1))
    END IF
    IF (pivot_index < end_index - 1)
        PUSH(subsets_to_sort, (pivot_index + 1, end_index))
    END IF
END FUNCTION
```

Implementation
---

- Recursive: 'recursive_quicksort.rb'
- Iterative: 'iterative_quicksort.rb'
- Official: 'official_quicksort.rb' (i.e. based on online consensus)

### Test

1. Set the target implementation class in `instantiate_sort_strategy` in `test_sort.rb`
2. `ruby test_sort.rb`

Comparison to online standard "official" algorithm
---

The primary difference is that the standard algorithm iterates the left and
right sets together once in a rightwards direction, by progressively swapping
small elements leftwards of a rightwards-moving pivot. This is a code
simplification compared to my attempt that iterates both the left and right sets
separately. My version may have an incremental advantage of fewer element swaps,
but this optimisation doesn't improve the time complexity. 

Additionally, the default pivot selection given in examples is a left pivot
strategy (I adapted the example implementation to middle strategy for
comparison), which is again a significant code simplification, with a cost as
per the [Pivot selection strategy](#pivot-selection-strategy) section above.
