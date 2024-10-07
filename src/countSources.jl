using StatsBase

a = [1, 2, 3, 3, 3, 4, 4, 5, 6, 3]

# Step 1: Count occurrences using `countmap`, which returns a dictionary with the keys being the unique values in the array and the values being the counts of each value
counts = countmap(a)

# Step 2: Create an array to store indices of non-unique values; `enumerate` is used to get the index and value of each element in the array directly without needing to know the length of the array
enum = enumerate(a)
non_unique_indices = [i for (i, x) in enum if counts[x] > 1]

# Output the indices of non-unique values
println(non_unique_indices)

for (i, x) in enum
	if counts[x] > 1
        println("Processing duplicated value at Index: $i, Value: $x")
        # Add your processing code here
    else
        println("Unique value at Index: $i, Value: $x")
    end
end 
