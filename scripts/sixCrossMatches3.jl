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
CatB_dup_labels = []

# Crossmatch the three catalogs twice
for i in 1:2
    for j in (i+1):3
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
	dup2_ind = findfirst(x -> x == dupe, df[df_row2, "Catalog 1"]) # `findfirst` 'cause there should only be one
	# println(" dupe = ", dupe, " dup_ind = ", dup_ind, " CatA_labels = ", CatA_labels)

	firstReverseMatch = df[df_row2, "matching labels"][dup2_ind, 1:1][1]
	if firstReverseMatch in CatA_labels # the second "[1]" gets it out of the array and makes it just a number that can be found "in" the set
		println("dupA_ind = $dupA_ind, dup2_ind=$dup2_ind ", CatA_labels, " ", df[df_row2, "matching labels"][dup2_ind, 1:1][1], " ", df[df_row2, "Catalog 1"][dup2_ind, 1])
	end

    # Zero out the dupA_ind array
    empty!(dupA_ind)
end

# Set([15, 17]) dupe = 181 [117]
# Set([52, 53]) dupe = 518 [351]
# Set([11, 9]) dupe = 139 [90]
# Set([20, 19]) dupe = 255 [170]
# Set([72, 73]) dupe = 724 [508]