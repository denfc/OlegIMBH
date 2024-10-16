using StatsBase

a = [1, 2, 3, 3, 3, 4, 4, 5, 6, 3]

# Step 1: Count occurrences using `countmap`, which returns a dictionary with the keys being the unique values in the array and the values being the counts of each value
counts = countmap(a)

# Step 2: Create an array to store indices of non-unique values; `enumerate` is used to get the index and value of each element in the array directly without needing to know the length of the array
enum = enumerate(a)
non_unique_indices = [i for (i, x) in enum if counts[x] > 1]

# Output the indices of non-unique values
println(non_unique_indices)

processed_values = Set{Int}()

for (i, x) in enum
    if x in processed_values
        continue # with the above `for` loop
    end

    if counts[x] > 1
        println("Processing duplicated value at Index: $i, Value: $x")
        _ind = findall(y -> y == x, a)
        println("Indices with value $x: ", _ind)
        for i in _ind
            # Add your processing code with a[i] here
        end
        push!(processed_values, x)
    else
        println("Unique value at Index: $i, Value: $x")
    end
end
