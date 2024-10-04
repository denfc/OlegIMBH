"""
dfc 3 October 2024, copied from `sixCrossMatches.jl` to start, modified by narrowing down list of available IDs
    - "This script performs cross-matching of astronomical source catalogs."
    - `sixCrossMatches.jl` uses `crossmatches.jl`
	- Can read ESCV file either by denoting commenting symbol directly or or by going to header line directly.
    - As written originally, most functions are included in the main script, which means we probably have an excess of global variables.
	- Counts the number of extended sources in each catalog.
	- Crossmatches the catalogs and saves the results.
"""

include("/home/dfc123/Gitted/OlegIMBH/src/intro.jl")
include(srcdir("readSourceCats.jl"))
include(srcdir("crossmatches.jl"))
include(srcdir("crossmatchTwo.jl"))
include(srcdir("pushIntoDictArray.jl"))

threeFrequencies = ["f1130w", "f770w", "f560w"]

RA_Dec, threeSourceCats = readSourceCats() # not run with this originally!

# Count the number of extended sources in each catalog
extended_N = [sum(cat.is_extended) for cat in threeSourceCats]
println("\nNumber of extended sources in each catalog: ", join(extended_N, ", "))
println()

# Remove the extended sources from RA_Dec and put them into a new matrix called RA_Dec_available
# Initialize RA_Dec_available and labels arrays
RA_Dec_available = deepcopy(RA_Dec)
labels = [Int[] for _ in 1:3]  # Create an array of empty integer arrays

for i in 1:3
    # Find indices where is_extended is false
	# transform SentinelArrays threeSourceCats[1].is_extended) to regular array
	regularArray = collect(threeSourceCats[i].is_extended)

    available_indices = findall(.!regularArray)
    
    # Update RA_Dec_available
    RA_Dec_available[i] = RA_Dec[i][:, available_indices]
    
    # Append the corresponding labels to the respective label array
    append!(labels[i], threeSourceCats[i].label[available_indices])
end

# Function to transform indices using the appropriate label array
function transform_indices(idxs, labels)
    transformed_idxs = idxs
    for i in 1:length(idxs)
        if idxs[i] != 0  # Skip indices that are 0 (no match)
            transformed_idxs[i] = labels[idxs[i]]
        end
    end
    return transformed_idxs
end

# Initialize an array to store combined indices, distances, and unique IDs in dictionaries
ind_DistsUniqueIDs = []

# Crossmatch the three catalogs twice
for i in 1:2
    for j in (i+1):3
        idxs, dists, twoNames = crossmatchTwo(RA_Dec_available, RA_Dec_available, i, j) # crossmatch_angular(RA_Dec[i], RA_Dec[j])
		pushIntoDictArray(idxs, dists, twoNames, j)

		# Reversing the order of the two catalogs
		idxs, dists, twoNames = crossmatchTwo(RA_Dec_available, RA_Dec_available, j, i)
		pushIntoDictArray(idxs, dists, twoNames, i)
    end
end

# Can't save dictionary with `wsave` because it isn't a dictionary but a vector of dictionaries
# wsave(joinpath(datadir(), "./sims/ind_DistsUniqueIDs.jld2"), ind_DistsUniqueIDs)

# turn saved dictionary into a DataFrame
df = DataFrame(ind_DistsUniqueIDs)

# JLD2.save("crossMatches_df.jld2", "crossMatches_df" => df) DOES NOT WORK!
JLD2.@save joinpath(projectdir(), "test_df.jld2") notExtended_df = df