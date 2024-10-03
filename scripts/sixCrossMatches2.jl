"""
dfc 3 October 2024, copied from `sixCrossMatches.jl` to start, modified by narrowing down list of available IDs
    - "This script performs cross-matching of astronomical source catalogs."
    - `sixCrossMatches.jl` uses `crossmatches.jl`
	- Can read ESCV file either by denoting commenting symbol directly or or by going to header line directly.
    - As written originally, most functions are included in the main script, which means we probably have an excess of global variables.
	- Counts the number of extended sources in each catalog.
	- Crossmatches the catalogs and saves the results.
"""

include("/home/dfc123/Gitted/OlegIMBH/src/intro.jl")
include(srcdir("readSourceCats.jl"))
include(srcdir("crossmatches.jl"))
include(srcdir("crossmatchTwo.jl"))
include(srcdir("pushIntoDictArray.jl"))

threeFrequencies = ["f1130w", "f770w", "f560w"]

RA_Dec, threeSourceCats = readSourceCats() # not run with this originally!

# Count the number of extended sources in each catalog
extended_N = [sum(cat.is_extended) for cat in threeSourceCats]
println("\nNumber of extended sources in each catalog: ", join(extended_N, ", "))
println()

# Initialize an array to store combined indices, distances, and unique IDs in dictionaries
ind_DistsUniqueIDs = []

# Crossmatch the three catalogs twice
for i in 1:2
    for j in (i+1):3
        idxs, dists, twoNames = crossmatchTwo(RA_Dec, RA_Dec, i, j) # crossmatch_angular(RA_Dec[i], RA_Dec[j])
		pushIntoDictArray(idxs, dists, twoNames, j)

		# Reversing the order of the two catalogs
		idxs, dists, twoNames = crossmatchTwo(RA_Dec, RA_Dec, j, i)
		pushIntoDictArray(idxs, dists, twoNames, j)
    end
end

# Can't save dictionary with `wsave` because it isn't a dictionary but a vector of dictionaries
# wsave(joinpath(datadir(), "./sims/ind_DistsUniqueIDs.jld2"), ind_DistsUniqueIDs)

# turn saved dictionary into a DataFrame
df = DataFrame(ind_DistsUniqueIDs)

# JLD2.save("crossMatches_df.jld2", "crossMatches_df" => df) DOES NOT WORK!
JLD2.@save joinpath(projectdir(), "crossMatches_df.jld2") crossMatches_df.jld2 = df