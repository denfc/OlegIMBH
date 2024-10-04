"""t
	Written with two `radec`s as well as two indices because when testing the case where 10^-5 had been added, wanted to put two different types of catalogs as well as different catalogs
"""
function crossmatchTwo(radec1::Array{Array{Float64, 2}, 1}, radec2::Array{Array{Float64, 2}, 1}, i, j)
	firstName = threeFrequencies[i]
	secondName = threeFrequencies[j]
	combinedNames = firstName*"_"*secondName
	print("Crossmatching catalog $i $firstName with catalog $j $secondName: ")
	ids, ds = crossmatch_angular(radec1[i], radec2[j])
	ids = collect(ids) # to turn the indices into a regular array (from an adjoint array)
	ds = collect(ds)

    # Transform indices using the appropriate label array
    transformed_ids = transform_indices(ids, labels[j])	
	return transformed_ids, ds, combinedNames
end