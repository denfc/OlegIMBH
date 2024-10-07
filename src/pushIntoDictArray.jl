function pushIntoDictArray(matchingIDs, ds, names, k, l)
	lenMat = length(matchingIDs)
	print(lenMat, " matches found;")
	# combined_matrix = hcat(idxs, dists) # when you `hcat` them, their adjoint nature is removed and they become regular column vectors ('cause you're stacking their individual elements horizontally), but we went to a bigger dictionary so we no longer need this matrix
	u1 = unique(matchingIDs[:, 1])
	lenU1 = length(u1)
	println(" unique indices: ", lenU1)
	
	# Step 1: Count occurrences using `countmap`, which returns a dictionary with the keys being the unique values in the array and the values being the counts of each value
	counts = countmap(matchingIDs)
	
	# Step 2: Create an array to store indices of non-unique values; `enumerate` is used to get the index and value of each element in the array directly without needing to know the length of the array
    enum = enumerate(matchingIDs)
	
	non_unique_indices = [i for (i, x) in enum if counts[x] > 1]
	
	# create dRatio, the ratio of the second ds distance to the first ds distance
	dRatio = ds[:, 2] ./ ds[:, 1]
	# dRatio = 0

	# sum(isEx), the number of extended sources in the match, is there only as a check; it should be zero.
	isEx = [threeSourceCats[l].is_extended[id] for id in u1]
	push!(ind_DistsUniqueIDs, Dict("twoCats" => names, "Cat 1 labels" => Int.(RA_Dec_noExt[k][1, :]), "matching labels" => matchingIDs, "dists" => ds, "uniqNN" => lenU1, "N Ext" => sum(isEx), "ds2/ds1" => dRatio))
end