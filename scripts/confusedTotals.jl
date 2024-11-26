"""
dfc 22 November 2024
	Trying to understand why 32 in `brightestN_16` ultimately yielded 33 coordinate sets in `/home/dfc123/Gitted/OlegIMBH/src/generateValues.jl`
	-> not because of the duplicates in `brigthestN_16`, but those found when looking in `bright16_good`.  Removed the duplicate magnitudes in `brightestN_16`, but those in `bright16_good` yield additional coordinate sets.
"""

include(srcdir("find_duplicates.jl"))
# bright_good_ind, bright16, bright29, bright_ind = filtered_data_NIRCam
bright16_good = bright16[bright_good_ind]
bright29_good = bright29[bright_good_ind]
sorted16_indices = sortperm(bright16_good)
sorted29_indices = sortperm(bright29_good)

selected_16_Xvalues, selected_16_Yvalues, selected_29_Xvalues, selected_29_Yvalues = selected_XYvalues # remember that these are what go into the `sortMergeMatch` function


nFinish = nStart - 1 + nBrightest
brightestN_16 = bright16_good[sorted16_indices][nStart: nFinish]
brightestN_29 = bright29_good[sorted29_indices][nStart: nFinish]
brightestN_29 = unique(brightestN_29)

d = []
for (i, val) in enumerate(brightestN_29)
	c = findall(x-> x==val, bright29_good)
	println("$i: $c")
	# for j in c
	# 	push!(d, j)43
	# 	println("$i) $val  $j ")
	# end
	# println(dfNIRCam[!, :ra][bright_ind][bright_good_ind][c])
	for j in eachindex(c)
		push!(d, dfNIRCam[!, :ra][bright_ind][bright_good_ind][c[j]])
	end
end
printstyled("length(d): $(length(d)) ",  color=:green)
printstyled("unique d: ", length(unique(d)), "\n", color = :red)
find_duplicates(d)
