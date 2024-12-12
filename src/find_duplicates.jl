"""
    find_duplicates(arr)

Find all duplicate elements in an array, returning each duplicate value once.

# Arguments
- `arr`: Input array of any type that supports equality comparison

# Returns
- Array containing unique values that appear more than once in input

# Example
```julia
julia> find_duplicates([1, 2, 2, 3, 3, 3, 4])
2-element Vector{Int64}:
 2
 3
 """
function find_duplicates(arr)
    return unique(filter(x -> count(==(x), arr) > 1, arr))
end