"""
!!! tip "dfc 25 September 2024"
    - `sixClusterPlots` uses `crossmatches.jl`
	- Can read ESCV file either by denoting commenting symbol directly or or by going to header line directly.
"""

include("/home/dfc123/Gitted/OlegIMBH/src/intro.jl")

# Read Source Catalog File
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

# Initialize array to store combined indices and distances
idxs_dists = Vector{Matrix{Float64}}()

function crossmatchTwo(i, j)
	print("Crossmatching catalog $i ($(threeFrequencies[i])) with catalog $j ($(threeFrequencies[j])): ")
	return crossmatch_angular(RA_Dec[i], RA_Dec[j])
end

# Initialize `uniqueIDs` to store the unique indices of the crossmatched sources
uniqueIDs = []

function genUniqueIDs(idx)
	u = unique(idx)
	push!(uniqueIDs, u)
	println(" unique indices: ", length(u))
end

# Crossmatch the three catalogs twice
for i in 1:2
    for j in (i+1):3
        idxs, dists = crossmatchTwo(i, j) # crossmatch_angular(RA_Dec[i], RA_Dec[j])
        print(length(idxs), " matches found;")
		genUniqueIDs(idxs[:, 1])
        combined_matrix = hcat(idxs, dists) # when you `hcat` them, their adjoint is removedd and they become regular column vectors ('cause you're stacking their individual elements horizontally)
        push!(idxs_dists, combined_matrix)
		idxs, dists = crossmatchTwo(j, i) 
        print(length(idxs), " matches found;")
		# println(" unique indices: ", length(unique(idxs[:, 1])), "\n")
		genUniqueIDs(idxs[:, 1])
		println()
        combined_matrix = hcat(idxs, dists)
        push!(idxs_dists, combined_matrix)
    end
end
# uniqueIDs = [unique(idxs_dists[i][:, 1]) for i in 1:6]