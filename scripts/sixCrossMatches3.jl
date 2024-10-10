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

threeFrequencies = ["f1130w", "f770w", "f560w"]
const NN_level = 3  # 2 is the minimum

RA_Dec, threeSourceCats = readSourceCats3()
RA_Dec_noExt, freq_Nsources = orderNoExtended(RA_Dec, threeSourceCats)
println("freq_Nsources = ", freq_Nsources)
# use `freq_Nsources`` to reorder `threeFrequencies`
threeFrequencies = collect(keys(freq_Nsources))	# This orders the catalog frequencies, via the `collect` function, into an array of String, just like the original (`keys` is of another type).

# Initialize an array to store combined indices and their labels, distances, and unique IDs in dictionaries
ind_DistsUniqueIDs = []

# Initialize an array to store the `countmap` results returned from `pushIntoDictArray`
CatB_dup_labels = []

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
        push!(CatB_dup_labels, dupes)

		idxs, dists, twoNames = crossmatchTwo3(RA_Dec_noExt, RA_Dec_noExt, j, i)
		idxs = Int.(RA_Dec_noExt[i][1, idxs])
		# Push nn results into `ind_DistsUniqueIDs`` and obtain `countmap(nearestNeighbors)` results from function `pushIntoDictArray`
		dupes = pushIntoDictArray(idxs, dists, twoNames, j, i)
        push!(CatB_dup_labels, dupes)
    end
end

# Save the DataFrame to a JLD2 file
df = DataFrame(ind_DistsUniqueIDs)
JLD2.@save joinpath(projectdir(), "test_df.jld2") notExtended_df = df

println()
display(df)

# print Cat 1 labels and matching labels for rows 3 and 4
df_row1 = 3
df_row2 = 4

printstyled("\nComparing rows $df_row1 and $df_row2 of the DataFrame.\n\nFirst, $(df[df_row1, "twoCats"]):\n", color=:blue)
for i in eachindex(df[df_row1, 3])  println("$i) ", df[df_row1, "Catalog 1"][i, 1], " ", df[df_row1, "matching labels"][i, 1:NN_level]) end
printstyled("\nReversing, $(df[df_row2, "twoCats"]):\n", color=:blue)
for i in eachindex(df[df_row2, 3])  println("$i) ", df[df_row2, "Catalog 1"][i, 1], " ", df[df_row2, "matching labels"][i, 1:NN_level]) end

# include(srcdir("associations".jl"))
# for i in eachindex(df[row1, 3])
enum1 = enumerate(df[df_row1, 5])
enum2 = enumerate(df[df_row2, 5])
dupA_ind = Int[]
for dupe in CatB_dup_labels[df_row1]
	CatA_labels = Set{Int}()
	for j in eachindex(df[df_row1, "Catalog 1"])
		if df[df_row1, "matching labels"][j, 1] == dupe
			push!(CatA_labels, df[df_row1, "Catalog 1"][j, 1])
			println("== dupe=$dupe, j $j ")
			push!(dupA_ind, j)  # Push the index j into the array dupA_ind
		end
	end
	# print(CatA_labels)
	dupB_ind = findfirst(x -> x == dupe, df[df_row2, "Catalog 1"]) # `findfirst` 'cause there should only be one
	# println(" dupe = ", dupe, " dup_ind = ", dup_ind, " CatA_labels = ", CatA_labels)

	firstReverseMatch = df[df_row2, "matching labels"][dupB_ind, 1:1][1]
	if firstReverseMatch in CatA_labels # the second "[1]" gets it out of the array and makes it just a number that can be found "in" the set
		println("dupA_ind = $dupA_ind, dupB_ind=$dupB_ind ", CatA_labels, " ", df[df_row2, "matching labels"][dupB_ind, 1:1][1], " ", df[df_row2, "Catalog 1"][dupB_ind, 1])
	end

    # Zero out the dupA_ind array
    empty!(dupA_ind)
end

# Set([15, 17]) dupe = 181 [117]
# Set([52, 53]) dupe = 518 [351]
# Set([11, 9]) dupe = 139 [90]
# Set([20, 19]) dupe = 255 [170]
# Set([72, 73]) dupe = 724 [508]