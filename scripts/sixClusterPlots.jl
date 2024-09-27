"""
!!! tip "dfc 25 September 2024"
    - `sixClusterPlots` uses `crossmatches.jl` and `reshapeCoords.jl`
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
println()

# Initialize array to store combined indices and distances
idxs_dists = Vector{Matrix{Float64}}()

# Crossmatch the three catalogs
for i in 1:2
    for j in (i+1):3
        print("Crossmatching catalog $i ($(threeFrequencies[i])) with catalog $j ($(threeFrequencies[j])): ")
        idxs, dists = crossmatch_angular(RA_Dec[i], RA_Dec[j])
        println(length(idxs), " ", length(dists))
        combined_matrix = hcat(idxs, dists) # when you `hcat` them, their adjoint is removedd and they become regular column vectors ('cause you're stacking their individual elements horizontally)
        push!(idxs_dists, combined_matrix)
    end
end

# Determine the unique indices
unique_idxs = Vector{Vector{Int64}}()
for i in 1:3
	idxs = idxs_dists[i][:, 1]
	push!(unique_idxs, unique(idxs))
end

# Print length of unique indices
println("Number of unique indices: ", length.(unique_idxs))
