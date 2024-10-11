# Set([15, 17]) dupe = 181 [117]
# Set([52, 53]) dupe = 518 [351]
# Set([11, 9]) dupe = 139 [90]
# Set([20, 19]) dupe = 255 [170]
# Set([72, 73]) dupe = 724 [508]

# 17) 19 [255, 265, 244]
# 18) 20 [255, 265, 286]

# 170) 255 [19, 20, 24]
# 171) 256 [23, 25, 29]

# include(srcdir("associations".jl"))
# for i in eachindex(df[df_row_AtoB, 3])
enum1 = enumerate(df[df_row_AtoB, 5])
enum2 = enumerate(df[df_row_BtoA, 5])
# dupA_ind = Int[]
# for dupe in CatB_dup_labels[df_row_AtoB] # N.B. looking at only one row now; will have to loop through all rows
# 	CatA_labels = Set{Int}()
# 	for j in eachindex(df[df_row_AtoB, "Catalog A labels"])
# 		if df[df_row_AtoB, "Catalog B matching labels"][j, 1] == dupe
# 			push!(CatA_labels, df[df_row_AtoB, "Catalog A labels"][j, 1])
# 			# println("== dupe=$dupe, j $j ")
# 			push!(dupA_ind, j)  # Push the index j into the array dupA_ind
# 		end
# 	end
# 	# print(CatA_labels)
# 	dupB_ind = findfirst(x -> x == dupe, df[df_row_BtoA, "Catalog A labels"]) # `findfirst` 'cause there should only be one
# 	# println(" dupe = ", dupe, " dup_ind = ", dup_ind, " CatA_labels = ", CatA_labels)

# 	firstReverseMatch = df[df_row_BtoA, "Catalog B matching labels"][dupB_ind, 1:1][1]
# 	if firstReverseMatch in CatA_labels # the second "[1]" gets it out of the array and makes it just a number that can be found "in" the set
# 		println("dupA_ind = $dupA_ind, dupB_ind=$dupB_ind ", CatA_labels, " ", df[df_row_BtoA, "Catalog B matching labels"][dupB_ind, 1:1][1], " ", df[df_row_BtoA, "Catalog A labels"][dupB_ind, 1])
# 	end

#     # Zero out the dupA_ind array
#     empty!(dupA_ind)
# end

# print Cat 1 labels and matching labels for rows 3 and 4
df_row_AtoB = 3
df_row_BtoA = 4

printstyled("\nComparing rows $df_row_AtoB and $df_row_BtoA of the DataFrame.\n\nFirst, $(df[df_row_AtoB, "Cat A to B"]):\n", color=:blue)
# for i in eachindex(df[df_row_AtoB, "Catalog A labels"])  println("$i) ", df[df_row_AtoB, "Catalog A labels"][i, 1], " ", df[df_row_AtoB, "Catalog B matching labels"][i, 1:NN_level]) end
printstyled("\nReversing, $(df[df_row_BtoA, "Cat A to B"]):\n", color=:blue)
# for i in eachindex(df[df_row_BtoA, "Catalog A labels"])  println("$i) ", df[df_row_BtoA, "Catalog A labels"][i, 1], " ", df[df_row_BtoA, "Catalog B matching labels"][i, 1:NN_level]) end