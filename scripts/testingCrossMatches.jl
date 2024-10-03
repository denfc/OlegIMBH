"""
!!! tip "dfc 1 October 2024"
	- copied from `sixCrossMatches.jl` and designed to test it by adding 10^(-5) degrees to coordinates and seeing if that number peaks in the crossmatching
    - `sixCrossMatches.jl` uses `crossmatches.jl`
	- Can read ESCV file either by denoting commenting symbol directly or or by going to header line directly.
!!! warning "As written, most functions are included in the main script, which means we probably have an excess of global variables."
"""

include("/home/dfc123/Gitted/OlegIMBH/src/intro.jl")
include(srcdir("readSourceCats.jl"))
include(srcdir("crossmatches.jl"))
include(srcdir("crossmatchTwo.jl"))
include(srcdir("pushIntoDictArray.jl"))

threeFrequencies = ["f1130w", "f770w", "f560w"]
ra_dec, threeSourceCats = readSourceCats() # the second return value, `threeSourceCats`, is not used directly in this script, but it is in `pushIntoDictArray`; could split `readSourceCats` and `pushIntoDictArray` to return only `ra_dec`


raΔ_dec  = deepcopy(ra_dec)
ra_decΔ  = deepcopy(ra_dec)
raΔ_decΔ = deepcopy(ra_dec)
const δ = 1.0e-5

for i in 1:3
    raΔ_dec[i][1, :] .= ra_dec[i][1, :] .+ δ
    ra_decΔ[i][2, :] .= ra_dec[i][2, :] .+ δ
	raΔ_decΔ[i][1, :] .= raΔ_dec[i][1, :]
	raΔ_decΔ[i][2, :] .= ra_decΔ[i][2, :]
end

# Initialize an array to store combined indices, distances, and unique Ids in dictionaries
ind_DistsUniqueIDs = []

# Crossmatch the modified catalogs the real one twice
println()
for i in 1:3
    # for j in (i+1):3
        idxs, dists, twoNames = crossmatchTwo(raΔ_decΔ, ra_dec, i, i) # crossmatch_angular(RA_Dec[i], RA_Dec[j])
		pushIntoDictArray(idxs, dists, twoNames, i)

		# Reversing the order of the two catalogs
		idxs, dists, twoNames = crossmatchTwo(ra_dec, raΔ_decΔ,  i, i)
		pushIntoDictArray(idxs, dists, twoNames, i)
    # end
end

# Can't save dictionary with `wsave` because it isn't a dictionary but a vector of dictionaries
# wsave(joinpath(datadir(), "./sims/ind_DistsUniqueIDs.jld2"), ind_DistsUniqueIDs)

# turn saved dictionary into a DataFrame
df = DataFrame(ind_DistsUniqueIDs)

# JLD2.save("crossMatches_df.jld2", "crossMatches_df" => df) DOES NOT WORK!
JLD2.@save joinpath(projectdir(), "crossMat5radec_df.jld2") crossMat5radec_df = df