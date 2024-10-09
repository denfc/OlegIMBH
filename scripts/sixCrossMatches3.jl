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

# Initialize an array to store the `countmap` results returned from `pushIntoDictArray`
duplicate_labels = []

# Crossmatch the three catalogs twice
for i in 1:2
    for j in (i+1):3
        idxs, dists, twoNames = crossmatchTwo3(RA_Dec_noExt, RA_Dec_noExt, i, j)
		idxs = Int.(RA_Dec_noExt[j][1, idxs])
		# Push nn results into `ind_DistsUniqueIDs`` and obtain `countmap(nearestNeighbors)` results from function `pushIntoDictArray`
        dupes = pushIntoDictArray(idxs, dists, twoNames, i, j)
        push!(duplicate_labels, dupes)

		idxs, dists, twoNames = crossmatchTwo3(RA_Dec_noExt, RA_Dec_noExt, j, i)
		idxs = Int.(RA_Dec_noExt[i][1, idxs])
		# Push nn results into `ind_DistsUniqueIDs`` and obtain `countmap(nearestNeighbors)` results from function `pushIntoDictArray`
		dupes = pushIntoDictArray(idxs, dists, twoNames, j, i)
        push!(duplicate_labels, dupes)
    end
end

# Save the DataFrame to a JLD2 file
df = DataFrame(ind_DistsUniqueIDs)
JLD2.@save joinpath(projectdir(), "test_df.jld2") notExtended_df = df

println()
display(df)

# print Cat 1 labels and matching labels for rows 3 and 4
row1 = 3
row2 = 4
println("\nComparing rows 3 and 4 of the DataFrame")
for i in eachindex(df[row1, 3])  println("$i) ", df[row1, "Catalog 1"][i, 1], " ", df[row1, "matching labels"][i, 1:NN_level]) end
println("\n Reversing \n")
for i in eachindex(df[row2, 3])  println("$i) ", df[row2, "Catalog 1"][i, 1], " ", df[row2, "matching labels"][i, 1:NN_level]) end

# include(srcdir("associations".jl"))
# julia> df
# 6×7 DataFrame
#  Row │ no dupes  N Ext  Catalog 1                          twoCats          matching labels                    dists                              uniquN 
#      │ Int64     Int64  Array…                             String           Matrix{Int64}                      Array…                             Int64  
# ─────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#    1 │       35      0  [1, 2, 4, 5, 6, 7, 8, 9, 10, 11 …  f770w to f1130w  [4 6 5; 1 -8 -5; … ; 240 -239 -2…  [0.00607253 0.00632585 0.0104187…      49
#    2 │       17      0  [1, 3, 4, 5, 6, 8, 9, 10, 11, 12…  f1130w to f770w  [6 5 7; 6 7 12; … ; 94 85 97; 94…  [0.00307845 0.00475049 0.0049192…      48
#    3 │       62      0  [1, 2, 4, 5, 6, 7, 8, 9, 10, 11 …  f560w to f1130w  [13 -26 -1; 15 -34 -2; … ; 1013 …  [0.000792226 0.0012132 0.0014707…      67
#    4 │        1      0  [1, 2, 5, 6, 11, 13, 14, 15, 16,…  f1130w to f560w  [1 8 9; 2 5 4; … ; 97 94 85; 93 …  [0.00147071 0.00457636 0.0058665…      72
#    5 │      111      0  [1, 3, 4, 5, 6, 8, 9, 10, 11, 12…  f560w to f770w   [18 -11 -5; 110 -126 -121; … ; 1…  [0.000607559 0.00108102 0.001081…     134
#    6 │       23      0  [1, 2, 5, 6, 11, 13, 14, 15, 16,…  f770w to f560w   [4 6 5; 1 3 8; … ; 242 240 234; …  [0.00532822 0.00679375 0.0093026…     140

 
# for i in eachindex(df[row1, 3])
enum1 = enumerate(df[row1, 5])
enum2 = enumerate(df[row2, 5])
for dupe in duplicate_labels[row1]
	labels = Set{Int}()
	for j in eachindex(df[row1, 3])
		if df[row1, "matching labels"][j, 1] == dupe
			push!(labels, df[row1, "Catalog 1"][j, 1])
		end
	end
	print(labels)
end
