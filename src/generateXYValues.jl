function generate_XYvalues(filtered_data, df::DataFrame;
    col_map::AbstractDict{Symbol,Symbol}=Dict{Symbol,Symbol}())
    
    # Define defaults inside function
    default_cols = Dict(
        :Column3 => :Column3,  # Object type
        :Column4 => :Column4,  # Magnitude
    )

    # Merge with any provided mappings
    cols = merge(default_cols, col_map)
    
    params = (df === dfMIRI) ? paramsMIRI : paramsAllNIRCLimited
    bright_good_ind, bright16, bright29, bright_ind = filtered_data # bright_ind is not used in this function
    bright16_good = bright16[bright_good_ind]
    bright29_good = bright29[bright_good_ind]
    current_indices = bright_good_ind

    # Calculate safe bounds
    available_length = min(length(bright16_good), length(bright29_good))
    safe_nStart = min(params.nStrt, available_length)
    safe_nFinish = min(params.nStrt - 1 + params.nB, available_length)
    range_size = safe_nFinish - safe_nStart + 1

    # Calculate indices once for each column with clear parentheses
    if params.randB
        indices_16 = current_indices[rand(safe_nStart:safe_nFinish, range_size)]
        indices_29 = current_indices[rand(safe_nStart:safe_nFinish, range_size)]
    else
        reverse_sort = params.obTyn == 2
        indices_16 = current_indices[sortperm(bright16_good, rev=reverse_sort)[safe_nStart:safe_nFinish]]
        indices_29 = current_indices[sortperm(bright29_good, rev=reverse_sort)[safe_nStart:safe_nFinish]]
    end

    brightestN_16_Xvalues = df[!, cols[:Column3]][indices_16]
    brightestN_16_Yvalues = df[!, cols[:Column4]][indices_16]
    brightestN_29_Xvalues = df[!, cols[:Column3]][indices_29]
    brightestN_29_Yvalues = df[!, cols[:Column4]][indices_29]

    return brightestN_16_Xvalues, brightestN_16_Yvalues, brightestN_29_Xvalues, brightestN_29_Yvalues
end