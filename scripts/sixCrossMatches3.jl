"""
dfc 4 October 20204
- CoPilot couldn't do what I wanted ...
	- want to remove duplicates but then find the second closest 
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
# Initialize `RA_Dec_available`` and `labels`` arrays
RA_Dec_available = deepcopy(RA_Dec)
labels = [Int[] for _ in 1:3]  # Create an array of empty integer arrays

for i in 1:3
    # Find indices where is_extended is false
    regularArray = collect(threeSourceCats[i].is_extended)
    available_indices = findall(!, regularArray)
    
    # Update RA_Dec_available by removing the extended sources
    RA_Dec_available[i] = RA_Dec[i][:, available_indices]
    
    # Append the corresponding labels to the respective label array
    append!(labels[i], threeSourceCats[i].label[available_indices])
end

# Initialize an array to store combined indices, distances, and unique IDs in dictionaries
ind_DistsUniqueIDs = []

# Crossmatch the three catalogs twice
for i in 1:2
    for j in (i+1):3
        while true
            idxs, dists, twoNames = crossmatchTwo(RA_Dec_available, RA_Dec_available, i, j)
            filter_duplicates!(idxs, dists, valid_idxs)
            
            # Update available RA_Dec and labels for re-matching
            update_available!(idxs, RA_Dec_available, labels)
            
            # Check if there are any duplicates left
        end

        # Push results into ind_DistsUniqueIDs
        pushIntoDictArray(accumulated_idxs, accumulated_dists, accumulated_twoNames, j)

        while true
            idxs, dists, twoNames, valid_idxs = crossmatchTwo(RA_Dec_available, RA_Dec_available, j, i)
            filter_duplicates!(idxs, dists, valid_idxs)
            
        end

        # Push fresults into ind_DistsUniqueIDs
        pushIntoDictArray(accumulated_idxs, accumulated_dists, accumulated_twoNames, i)
    end
end

# Save the DataFrame to a JLD2 file
df = DataFrame(ind_DistsUniqueIDs)
JLD2.@save joinpath(projectdir(), "test_df.jld2") notExtended_df = df