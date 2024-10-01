"""
!!! tip "dfc 25 September 2024"
    - `sixClusterPlots` uses `crossmatches.jl`
	- Can read ESCV file either by denoting commenting symbol directly or or by going to header line directly.
!!! warning "As written, most functions are included in the main script, which means we probably have an excess of global variables."
"""

include("/home/dfc123/Gitted/OlegIMBH/src/intro.jl")

# Read Source Catalog Files
oneDataDir = joinpath(datadir(), "exp_raw")
threeDataDirs = readdir(oneDataDir)
threeDataDirs = [joinpath(oneDataDir, threeDataDirs[i]) for i in 1:3]
threeFrequencies = ["f1130w", "f770w", "f560w"]
threeSourceCats = []
for dir in 1:3
	fName = threeDataDirs[dir]*"/jw02491-o005_t002_miri_"*threeFrequencies[dir]*"_cat.ecsv"
	push!(threeSourceCats, CSV.read(fName, DataFrame; comment = "#",  drop=[:label], normalizenames=true))
end

RA_Dec = [vcat((collect(threeSourceCats[i].sky_centroid_ra))', (collect(threeSourceCats[i].sky_centroid_dec))') for i in 1:3]
print("Sizes of RA_Dec: ")
for i in 1:3
	print(size(RA_Dec[i]), " $(threeFrequencies[i]); ", )
end

# Count the number of extended sources in each catalog
extended_N = [sum(cat.is_extended) for cat in threeSourceCats]
println("\nNumber of extended sources in each catalog: ", join(extended_N, ", "))
println()

# Initialize an array to store combined indices, distances, and unique Ids in dictionaries
ind_DistsUniqueIDs = []

function crossmatchTwo(i, j)
	firstName = threeFrequencies[i]
	secondName = threeFrequencies[j]
	combinedNames = firstName*"_"*secondName
	print("Crossmatching catalog $i $firstName with catalog $j $secondName: ")
	ids, ds = crossmatch_angular(RA_Dec[i], RA_Dec[j])
	ids = collect(ids) # to turn the indices into a regular array (from an adjoint array)
	ds = collect(ds)
	return ids, ds, combinedNames
end

function pushIntoDictArray(ids, ds, names, k)
	print(length(ids), " matches found;")
	# combined_matrix = hcat(idxs, dists) # when you `hcat` them, their adjoint nature is removed and they become regular column vectors ('cause you're stacking their individual elements horizontally), but we went to a bigger dictionary so we no longer need this matrix
	u = unique(ids)
	lenU = length(u)
	println(" unique indices: ", lenU)

	isEx = [threeSourceCats[k].is_extended[id] for id in u]
	push!(ind_DistsUniqueIDs, Dict("twoCats" => names, "ids" => ids, "dists" => ds, "uniqueIDs" => u, "extended?" => isEx, "N_unique" => lenU, "N Ext" => sum(isEx)))
end

# Crossmatch the three catalogs twice
for i in 1:2
    for j in (i+1):3
        idxs, dists, twoNames = crossmatchTwo(i, j) # crossmatch_angular(RA_Dec[i], RA_Dec[j])
		pushIntoDictArray(idxs, dists, twoNames, j)

		# Reversing the order of the two catalogs
		idxs, dists, twoNames = crossmatchTwo(j, i)
		pushIntoDictArray(idxs, dists, twoNames, j)
    end
end

# Can't save dictionary with `wsave` because it isn't a dictionary but a vector of dictionaries
# wsave(joinpath(datadir(), "./sims/ind_DistsUniqueIDs.jld2"), ind_DistsUniqueIDs)

# turn saved dictionary into a DataFrame
df = DataFrame(ind_DistsUniqueIDs)

# JLD2.save("crossMatches_df.jld2", "crossMatches_df" => df) DOES NOT WORK!
JLD2.@save joinpath(projectdir(), "crossMatches_df.jld2") crossMatches_df = df