function pushIntoDictArray(matchingIDs, ds, names, k, l)
	nearestNeighbors = matchingIDs[:, 1]
	print(length(nearestNeighbors), " matches found;")

	uniqNN = unique(nearestNeighbors)
	len_uNN = length(uniqNN)
	println(" unique indices: ", len_uNN)
	
	# Step 1: Count occurrences using `countmap`, which returns a dictionary with the keys being the unique values in the array and the values being the counts of each value
	counts = countmap(nearestNeighbors) # only the nearest neighbors are to be scanned for duplicates at first
	
	# Step 2: Create an array to store indices of non-unique values; `enumerate` is used to get the index and value of each element in the array directly without needing to know the length of the array
	# And, via CoPilot,  why we don't just loop through the dictionary's keys:  "if you only need to process the unique values and their counts, you can loop through the dictionary directly. However, in your current implementation, you are also using the index of each element in the nearestNeighbors array, which is why enumerate is used."
    enum = enumerate(nearestNeighbors)
	
	processed_values = Set{Int}()

	# Why we need `enumerate`: 
	for (i, x) in enum
		if x in processed_values
			continue # with the above `for` loop
		end
		if counts[x] > 1
			# println("Processing duplicated value at Index: $i, Value: $x")
			# _ind = findall(y -> y == x, nearestNeighbors)
			# println("Number of indices with value $x: ", length(_ind))
				# for i in _ind
				# 	# if we want to check distances immediately, it would go here
				# end
			push!(processed_values, x)
		else	
			# set the indices beyond the nearest neighbor negative to show that the nn itself has no duplicates
			matchingIDs[i, 2:NN_level] .= -matchingIDs[i, 2:NN_level]
		end
	end 
	# noDupes_N = length(findall(x -> x < 0, matchingIDs[:, 2]))
	nAnB = (freq_Nsources[threeFrequencies[k]], freq_Nsources[threeFrequencies[l]])
	
	# sum(isEx), the number of extended sources in the match, is there only as a check; it should be zero.
	isEx = [threeSourceCats[l].is_extended[id] for id in uniqNN]
	# push!(ind_DistsUniqueIDs, OrderedDict("Cat A to B" => names, "nA, nB" => nAnB, "Catalog A" => Int.(RA_Dec_noExt[k][1, :]), "Cat B matching labels" => matchingIDs, "distances" => ds, "uniqN" => len_uNN, "!dupes" => noDupes_N, "Ext?" => sum(isEx)))
	push!(ind_DistsUniqueIDs, OrderedDict("Cat A to B" => names, "nA, nB" => nAnB, "Catalog A" => Int.(RA_Dec_noExt[k][1, :]), "Cat B matching labels" => matchingIDs, "distances" => ds, "uniqN" => len_uNN, "Ext?" => sum(isEx)))
	return processed_values
end