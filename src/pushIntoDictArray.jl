function pushIntoDictArray(matchingIDs, ds, names, k, l)
	nearestNeighbors = matchingIDs[:, 1]
	print(length(nearestNeighbors), " matches found;")

	u1 = unique(nearestNeighbors)
	lenU1 = length(u1)
	println(" unique indices: ", lenU1)
	
	# Step 1: Count occurrences using `countmap`, which returns a dictionary with the keys being the unique values in the array and the values being the counts of each value
	counts = countmap(nearestNeighbors) # only the nearest neighbors are to be scanned for duplicates at first
	
	# Step 2: Create an array to store indices of non-unique values; `enumerate` is used to get the index and value of each element in the array directly without needing to know the length of the array
    enum = enumerate(nearestNeighbors)
	
	processed_values = Set{Int}()
	for (i, x) in enum
		if x in processed_values
			continue # with the above `for` loop
		end
		if counts[x] > 1
			# println("Processing duplicated value at Index: $i, Value: $x")
			_ind = findall(y -> y == x, nearestNeighbors)
			# println("Number of indices with value $x: ", length(_ind))
			for i in _ind
				# Add your processing code with nearestNeighbors[i] here
			end
			push!(processed_values, x)
		else
			# set the indices beyond the nearest neighbor negative to show that the nn itself has no duplicates
			matchingIDs[i, 2:NN_level] .= -matchingIDs[i, 2:NN_level]
		end
	end 
	noDupes_n = length(findall(x -> x<0, matchingIDs[:, 2]))
	
	# sum(isEx), the number of extended sources in the match, is there only as a check; it should be zero.
	isEx = [threeSourceCats[l].is_extended[id] for id in u1]
	push!(ind_DistsUniqueIDs, Dict("twoCats" => names, "Catalog 1" => Int.(RA_Dec_noExt[k][1, :]), "matching labels" => matchingIDs, "dists" => ds, "uniquN" => lenU1, "no dupes" => noDupes_n, "N Ext" => sum(isEx)))
end