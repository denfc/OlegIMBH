function crossmatchTwo(radec1::Array{Array{Float64, 2}, 1}, radec2::Array{Array{Float64, 2}, 1}, i, j)
	firstName = threeFrequencies[i]
	secondName = threeFrequencies[j]
	combinedNames = firstName*"_"*secondName
	print("Crossmatching catalog $i $firstName with catalog $j $secondName: ")
	ids, ds = crossmatch_angular(radec1[i], radec2[j])
	ids = collect(ids) # to turn the indices into a regular array (from an adjoint array)
	ds = collect(ds)
	return ids, ds, combinedNames
end