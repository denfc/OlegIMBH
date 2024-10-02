function pushIntoDictArray(ids, ds, names, k)
	print(length(ids), " matches found;")
	# combined_matrix = hcat(idxs, dists) # when you `hcat` them, their adjoint nature is removed and they become regular column vectors ('cause you're stacking their individual elements horizontally), but we went to a bigger dictionary so we no longer need this matrix
	u = unique(ids)
	lenU = length(u)
	println(" unique indices: ", lenU)

	isEx = [threeSourceCats[k].is_extended[id] for id in u]
	push!(ind_DistsUniqueIDs, Dict("twoCats" => names, "ids" => ids, "dists" => ds, "uniqueIDs" => u, "extended?" => isEx, "N_unique" => lenU, "N Ext" => sum(isEx)))
end