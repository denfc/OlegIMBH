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
include(srcdir("readSourceCats3.jl"))
include(srcdir("crossmatches.jl"))
include(srcdir("crossmatchTwo3.jl"))
include(srcdir("pushIntoDictArray.jl"))

const threeFrequencies = ["f1130w", "f770w", "f560w"]
const NN_level = 3  # 2 is the minimum

RA_Dec, threeSourceCats = readSourceCats3() # not run with this originally!

# Initialize `RA_Dec_noExt`
RA_Dec_noExt = deepcopy(RA_Dec)

# By finding the true "is_extended" indices in each `threeSourceCat`, remove the extended sources from RA_Dec and put them into the new matrix called RA_Dec_noExt
for i in 1:3
    # Find indices where is_extended is false
    available_indices = findall(!, threeSourceCats[i][:, :is_extended])
    
    # Update RA_Dec_noExt by removing the extended sources
    RA_Dec_noExt[i] = RA_Dec[i][:, available_indices]
end

# Initialize an array to store combined indices and their labels, distances, and unique IDs in dictionaries
ind_DistsUniqueIDs = []

# Crossmatch the three catalogs twice
for i in 1:2
    for j in (i+1):3
        idxs, dists, twoNames = crossmatchTwo3(RA_Dec_noExt, RA_Dec_noExt, i, j)
		idxs = Int.(RA_Dec_noExt[j][1, idxs])
    
		# Push results into ind_DistsUniqueIDs
        pushIntoDictArray(idxs, dists, twoNames, i, j)
        idxs, dists, twoNames = crossmatchTwo3(RA_Dec_noExt, RA_Dec_noExt, j, i)

        # Push fresults into ind_DistsUniqueIDs
		idxs = Int.(RA_Dec_noExt[i][1, idxs])
		pushIntoDictArray(idxs, dists, twoNames, j, i)
    end
end

# Save the DataFrame to a JLD2 file
df = DataFrame(ind_DistsUniqueIDs)
#bJLD2.@save joinpath(projectdir(), "test_df.jld2") notExtended_df = df

println()
display(df)

# print Cat 1 labels and matching labels for rows 3 and 4
row1 = 3
row2 = 4
println("\nComparing rows 3 and 4 of the DataFrame")
for i in eachindex(df[row1, 2])  println("$i) ", df[row1, "Catalog 1"][i, 1], " ", df[row1, "matching labels"][i, 1:NN_level]) end
println("\n Reversing \n")
for i in eachindex(df[row2, 2])  println("$i) ", df[row2, "Catalog 1"][i, 1], " ", df[row2, "matching labels"][i, 1:NN_level]) end