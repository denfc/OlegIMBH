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

# Remove the extended sources from RA_Dec and put them into a new matrix called RA_Dec_available
# Initialize RA_Dec_available and labels arrays
RA_Dec_available = deepcopy(RA_Dec)
labels = [Int[] for _ in 1:3]  # Create an array of empty integer arrays

for i in 1:3
    # Find indices where is_extended is false
    regularArray = collect(threeSourceCats[i].is_extended)
    available_indices = findall(!, regularArray)
    
    # Update RA_Dec_available
    RA_Dec_available[i] = RA_Dec[i][:, available_indices]
    
    # Append the corresponding labels to the respective label array
    append!(labels[i], threeSourceCats[i].label[available_indices])
    
    # Debugging print statements
    println("Catalog $i: available_indices = $available_indices")
    println("Catalog $i: labels = $(labels[i])")
end

# Initialize an array to store combined indices, distances, and unique IDs in dictionaries
ind_DistsUniqueNNs = []

function filter_duplicates!(idxs, dists, valid_idxs)
    unique_idxs = Dict{Int, Float64}()
    for (idx, dist, valid) in zip(idxs, dists, valid_idxs)
        if valid
            if haskey(unique_idxs, idx)
                if dist < unique_idxs[idx]
                    unique_idxs[idx] = dist
                end
            else
                unique_idxs[idx] = dist
            end
        end
    end
    for i in eachindex(idxs)
        if haskey(unique_idxs, idxs[i]) && dists[i] == unique_idxs[idxs[i]]
            continue
        else
            valid_idxs[i] = false
            dists[i] = Inf
        end
    end
end

function transform_indices(idxs, labels, valid_idxs)
    transformed_idxs = []
    for (i, valid) in zip(eachindex(idxs), valid_idxs)
        if valid && idxs[i] <= length(labels)
            push!(transformed_idxs, labels[idxs[i]])
        else
            push!(transformed_idxs, -1)
        end
    end
    return transformed_idxs
end

function update_available!(idxs, RA_Dec_available, labels, valid_idxs)
    non_invalid_idxs = findall(x -> x, valid_idxs)
    for i in eachindex(RA_Dec_available)
        RA_Dec_available[i] = RA_Dec_available[i][:, non_invalid_idxs]
        labels[i] = labels[i][non_invalid_idxs]
    end
end

function crossmatchTwo(radec1::Array{Array{Float64, 2}, 1}, radec2::Array{Array{Float64, 2}, 1}, i, j)
    firstName = threeFrequencies[i]
    secondName = threeFrequencies[j]
    combinedNames = firstName * "_" * secondName
    print("Crossmatching catalog $i $firstName with catalog $j $secondName: ")
    ids, ds = crossmatch_angular(radec1[i], radec2[j])
    ids = collect(ids) # to turn the indices into a regular array (from an adjoint array)
    ds = collect(ds)
    valid_idxs = trues(length(ids))  # Initialize valid indices array

    # Transform indices using the appropriate label array
    transformed_ids = transform_indices(ids, labels[j], valid_idxs)
    return transformed_ids, ds, combinedNames, valid_idxs
end

# Crossmatch the three catalogs twice
for i in 1:2
    for j in (i+1):3
        # Temporary storage for intermediate results
        accumulated_idxs, accumulated_dists, accumulated_twoNames = [], [], ""
        removed_radec, removed_dists = Matrix{Float64}[], []

        while true
            idxs, dists, twoNames, valid_idxs = crossmatchTwo(RA_Dec_available, RA_Dec_available, i, j)
            filter_duplicates!(idxs, dists, valid_idxs)
            
            # Accumulate intermediate results
            append!(accumulated_idxs, idxs)
            append!(accumulated_dists, dists)
            accumulated_twoNames = twoNames  # This will be the same for all iterations
            
            # Track removed coordinates
            removed_indices = findall(!, valid_idxs)
            append!(removed_radec, [RA_Dec_available[i][:, removed_indices]])
            append!(removed_dists, dists[removed_indices])
            
            # Update available RA_Dec and labels for re-matching
            update_available!(idxs, RA_Dec_available, labels, valid_idxs)
            
            # Check if there are any duplicates left
            if all(x -> x, valid_idxs)
                break
            end
        end

        # Re-run crossmatch on removed coordinates until no duplicates remain
        while !isempty(removed_radec)
            idxs, dists, twoNames, valid_idxs = crossmatchTwo(removed_radec, RA_Dec_available, i, j)
            filter_duplicates!(idxs, dists, valid_idxs)
            
            # Accumulate intermediate results
            append!(accumulated_idxs, idxs)
            append!(accumulated_dists, dists)
            
            # Track removed coordinates again
            removed_radec, removed_dists = Matrix{Float64}[], []
            removed_indices = findall(!, valid_idxs)
            append!(removed_radec, [RA_Dec_available[i][:, removed_indices]])
            append!(removed_dists, dists[removed_indices])
            
            # Update available RA_Dec and labels for re-matching
            update_available!(idxs, RA_Dec_available, labels, valid_idxs)
            
            # Check if there are any duplicates left
            if all(x -> x, valid_idxs)
                break
            end
        end

        # Push final accumulated results into ind_DistsUniqueNNs
        pushIntoDictArray(accumulated_idxs, accumulated_dists, accumulated_twoNames, j)

        # Temporary storage for intermediate results
        accumulated_idxs, accumulated_dists, accumulated_twoNames = [], [], ""
        removed_radec, removed_dists = Matrix{Float64}[], []

        while true
            idxs, dists, twoNames, valid_idxs = crossmatchTwo(RA_Dec_available, RA_Dec_available, j, i)
            filter_duplicates!(idxs, dists, valid_idxs)
            
            # Accumulate intermediate results
            append!(accumulated_idxs, idxs)
            append!(accumulated_dists, dists)
            accumulated_twoNames = twoNames  # This will be the same for all iterations
            
            # Track removed coordinates
            removed_indices = findall(!, valid_idxs)
            append!(removed_radec, [RA_Dec_available[j][:, removed_indices]])
            append!(removed_dists, dists[removed_indices])
            
            # Update available RA_Dec and labels for re-matching
            update_available!(idxs, RA_Dec_available, labels, valid_idxs)
            
            # Check if there are any duplicates left
            if all(x -> x, valid_idxs)
                break
            end
        end

        # Re-run crossmatch on removed coordinates until no duplicates remain
        while !isempty(removed_radec)
            idxs, dists, twoNames, valid_idxs = crossmatchTwo(removed_radec, RA_Dec_available, j, i)
            filter_duplicates!(idxs, dists, valid_idxs)
            
            # Accumulate intermediate results
            append!(accumulated_idxs, idxs)
            append!(accumulated_dists, dists)
            
            # Track removed coordinates again
            removed_radec, removed_dists = Matrix{Float64}[], []
            removed_indices = findall(!, valid_idxs)
            append!(removed_radec, [RA_Dec_available[j][:, removed_indices]])
            append!(removed_dists, dists[removed_indices])
            
            # Update available RA_Dec and labels for re-matching
            update_available!(idxs, RA_Dec_available, labels, valid_idxs)
            
            # Check if there are any duplicates left
            if all(x -> x, valid_idxs)
                break
            end
        end

        # Push final accumulated results into ind_DistsUniqueNNs
        pushIntoDictArray(accumulated_idxs, accumulated_dists, accumulated_twoNames, i)
    end
end

# Save the DataFrame to a JLD2 file
df = DataFrame(ind_DistsUniqueNNs)
JLD2.@save joinpath(projectdir(), "test_df.jld2") notExtended_df = df