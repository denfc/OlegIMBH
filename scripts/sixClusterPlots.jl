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
println("Sizes of RA_Dec: ", size.(RA_Dec))
# Initialize arrays to store indices and distances
three_idxs = []
three_dists = []
# Crossmatch the three catalogs
for i in 1:2
    for j in (i+1):3
        print("Crossmatching catalog $i with catalog $j: ")
        idxs, dists = crossmatch_angular(RA_Dec[i], RA_Dec[j])
		println(length(idxs), " ", length(dists))
		push!(three_idxs, idxs)
        push!(three_dists, dists)
    end
end