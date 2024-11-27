# Function to generate random or sorted values
function generate_XYvalues(filtered_data, df::DataFrame, randBright::Bool, nBrightest::Int, nStart::Int, objectTypeIndex::Int;
    col_map::AbstractDict{Symbol,Symbol}=Dict{Symbol,Symbol}()
)
# right now df is global, which might be silly; othrewise add `df::DataFrame``,  into above

    # Define defaults inside function
    default_cols = Dict(
        :Column3 => :Column3,  # Object type
        :Column4 => :Column4,  # Magnitude
    )

    # Merge with any provided mappings
    cols = merge(default_cols, col_map)

    # Destructure the tuple
    bright_good_ind, bright16, bright29, bright_ind = filtered_data

    # Get good values using the filtered indices directly
    bright16_good = bright16[bright_good_ind]
    bright29_good = bright29[bright_good_ind]

    if randBright
        # Generate random indices
        random_indices_16 = rand(1:length(bright16_good), nBrightest)
        random_indices_29 = rand(1:length(bright29_good), nBrightest)

        brightestN_16 = bright16_good[random_indices_16]
        brightestN_29 = bright29_good[random_indices_29]
        brightestN_16_Xvalues = df[!, cols[:Column3]][bright_ind][bright_good_ind][random_indices_16]
        brightestN_16_Yvalues = df[!, cols[:Column4]][bright_good_ind][random_indices_16]
        brightestN_29_Xvalues = df[!, cols[:Column3]][bright_good_ind][random_indices_29]
        brightestN_29_Yvalues = df[!, cols[:Column4]][bright_good_ind][random_indices_29]
    else
        # Sort by value
		if objectTypeIndex == 2
            sorted16_indices = sortperm(bright16_good, rev=true)
            sorted29_indices = sortperm(bright29_good, rev=true)
        else
            sorted16_indices = sortperm(bright16_good)
            sorted29_indices = sortperm(bright29_good)
        end
		nFinish = nStart - 1 + nBrightest
        brightestN_16 = bright16_good[sorted16_indices][nStart: nFinish]
		brightestN_16 = unique(brightestN_16)
		brightestN_29 = bright29_good[sorted29_indices][nStart: nFinish]
		brightestN_29 = unique(brightestN_29)
		brightestN_16_Xvalues = df[!, cols[:Column3]][bright_ind][bright_good_ind][findall(x -> x in brightestN_16, bright16_good)]
	# println("brightestN_29_Xvalues: ", brightestN_16_Xvalues)
        brightestN_16_Yvalues = df[!, cols[:Column4]][bright_ind][bright_good_ind][findall(x -> x in brightestN_16, bright16_good)]
		eleven = findall(x->x in brightestN_29, df[!, cols[:Column3]])
        # brightestN_29_Xvalues = df[!, cols[:Column3]][bright_ind][bright_good_ind][findall(x -> x in brightestN_29, bright29_good)]
        # brightestN_29_Yvalues = df[!, cols[:Column4]][bright_ind][bright_good_ind][findall(x -> x in brightestN_29, bright29_good)]
        brightestN_29_Xvalues = df[!, cols[:Column3]][bright_ind][bright_good_ind][findall(x -> x in brightestN_29, bright29_good)]
        brightestN_29_Yvalues = df[!, cols[:Column4]][bright_ind][bright_good_ind][findall(x -> x in brightestN_29, bright29_good)]
    end

    return brightestN_16_Xvalues, brightestN_16_Yvalues, brightestN_29_Xvalues, brightestN_29_Yvalues
end