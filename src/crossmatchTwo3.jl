"""t
	Written with two `radec`s as well as two indices because when testing the case where 10^-5 had been added, wanted to put two different types of catalogs as well as different catalogs
"""

#= used in earlier version only?
function transform_indices(ids::Matrix{Int64}, labels::Vector{Float64})
    return [(radec1[1, ids[1, k]], radec2[1, ids[2, k]]) for k in 1:size(ids, 2)]
end
=#
function crossmatchTwo3(radec1::Array{Array{Float64, 2}, 1}, radec2::Array{Array{Float64, 2}, 1}, i, j)
	firstName = threeFrequencies[i]
	secondName = threeFrequencies[j]
	combinedNames = "$firstName to $secondName"
	print("Crossmatching catalog A, $firstName, with catalog B, $secondName: ")
	ids, ds = crossmatch_angular(radec1[i][2:3, :], radec2[j][2:3, :])
	ids = collect(ids) # to turn the indices into a regular array (from an adjoint array)
	# change the ids into the labels that correspond to the original indices
	# ids = transform_indices(ids, radec2[j][1, :])

	ds = collect(ds)

	return ids, ds, combinedNames
end