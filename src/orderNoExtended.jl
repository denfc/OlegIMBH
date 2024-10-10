"""
dfc 10 October 2024
	- Remove the extended sources from the RA_Dec matrix and returns the remaining ones.
	- It also returns an ordered dictionary that contains the number of (unextended) sources in each catalog.
	  - The `DataStructures` package is necessary for the `OrderedDict` type.
"""
function orderNoExtended(RA_Dec, threeSourceCats)
	# By finding the true "is_extended" indices in each `threeSourceCat`, remove the extended sources from RA_Dec and put the remaining ones into the new matrix called radecNoX
	# Initialize `radecNoX`
	radecNoX = deepcopy(RA_Dec)
	for i in eachindex(threeSourceCats)
		# Find indices where is_extended is false
		available_indices = findall(!, threeSourceCats[i][:, :is_extended])
		
		# Update radecNoX by removing the extended sources
		radecNoX[i] = RA_Dec[i][:, available_indices]
	end

	# Now count the number of sources in each catalog and store the results in a dictionary with the frequency as the key.
	source_Ns = [size(radecNoX[i])[2] for i in eachindex( radecNoX)]
	# Create an array of pairs directly
	freq_Ns = Pair.(threeFrequencies, source_Ns)
	sortedFreq = sort(freq_Ns, by = x -> x.second)
	# Convert the sorted array of pairs to an OrderedDict
	freq_Ns = OrderedDict(sortedFreq)
	return radecNoX, freq_Ns
end