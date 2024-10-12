function findDuplicates(anArray::Array; setNegative::Bool=false)
	# Step 1: Count occurrences using `countmap`, which returns a dictionary with the keys being the unique values in the array and the values being the counts of each value
	counts = countmap(anArray)
	# Why we need `enumerate`:  And, via CoPilot,  why we don't just loop through the dictionary's keys:  "if you only need to process the unique values and their counts, you can loop through the dictionary directly. However, in your current implementation, you are also using the index of each element in the nearestNeighbors array, which is why enumerate is used."
	enum = enumerate(anArray)
	# Step 2: Create an array to store indices of non-unique values; `enumerate` is used to get the index and value of each element in the array directly without needing to know the length of the array
	duplicates = Set{Int}()
	
	# if setNegative is true, then set the indices beyond the nearest neighbor negative to show that the nn itself has no duplicates
	if setNegative
		for (i, x) in enum
			if x in duplicates
				continue
			end
			if counts[x] > 1
				push!(duplicates, x)
			else	
				# set the indices beyond the nearest neighbor negative to show that the nn itself has no duplicates
				anArray[i, 2:NN_level] .= -anArray[i, 2:NN_level]
			end
		end
	else
		for (i, x) in enum
			if x in duplicates
				continue
			end
			if counts[x] > 1
				push!(duplicates, x)
			end
		end
	end
	return duplicates
end