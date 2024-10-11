"""
dfc 5 OCtober 2024
- Knowing how to use CoPilot better, and after a talk with Oleg, I have a different way of processing that uses newly learned functions `enumerate` and `countmap`
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

threeFrequencies = ["f1130w", "f770w", "f560w"]
const NN_level = 3  # "nearest neighbor level"; 2 is the minimum

RA_Dec, threeSourceCats = readSourceCats3()
RA_Dec_noExt, freq_Nsources = orderNoExtended(RA_Dec, threeSourceCats)
# use `freq_Nsources`` to reorder `threeFrequencies`
threeFrequencies = collect(keys(freq_Nsources))	# This orders the catalog frequencies, via the `collect` function, into an array of String, just like the original (`keys` is of another type).

# Initialize an array to store combined indices and their labels, distances, and unique IDs in dictionaries
ind_DistsUniqueIDs = []

# Initialize an array to store the `countmap` results returned from `pushIntoDictArray`
catB_dup_matching_label_sets = Vector{Pair}()

# Crossmatch the three catalogs twice
for i in 1:2
    for j in (i+1):3
		# ensure i < j always so the one with the fewer sources always goes first
		if i > j
            i, j = j, i
        end
        idxs, dists, twoNames = crossmatchTwo3(RA_Dec_noExt, RA_Dec_noExt, i, j)
		idxs = Int.(RA_Dec_noExt[j][1, idxs])
		# Push nn results into `ind_DistsUniqueIDs`` and obtain `countmap(nearestNeighbors)` results from function `pushIntoDictArray`
        dupes = pushIntoDictArray(idxs, dists, twoNames, i, j)
        push!(catB_dup_matching_label_sets, Pair(twoNames, dupes))

		idxs, dists, twoNames = crossmatchTwo3(RA_Dec_noExt, RA_Dec_noExt, j, i)
		idxs = Int.(RA_Dec_noExt[i][1, idxs])
		# Push nn results into `ind_DistsUniqueIDs`` and obtain `countmap(nearestNeighbors)` results from function `pushIntoDictArray`
		dupes = pushIntoDictArray(idxs, dists, twoNames, j, i)
        # push!(catA_dup_matching_label_set, dupes) might need this later
    end
end

# Save the DataFrame to a JLD2 file
df = DataFrame(ind_DistsUniqueIDs)
JLD2.@save joinpath(projectdir(), "test_df.jld2") notExtended_df = df

println()
display(df)

catsAtoB_dups = duplicateDict(catB_dup_matching_label_sets)