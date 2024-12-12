"""
    dfc 11 Dec 2024, via Copilot
	- originally looked at https://stackoverflow.com/questions/71376803/efficient-method-for-checking-monotonicity-in-array-julia
"""

@enum Monotonicity begin # default @enum is 0, 1, 2
    INCREASING = 1
    DECREASING = -1
    NOT_MONOTONIC = 0
end

function find_mag_mono(series::AbstractVector{T}) where T <: Number
    length(series) <= 1 && return NOT_MONOTONIC
    clean_series = filter(!isnan, series)
    isempty(clean_series) && return NOT_MONOTONIC

    # Check first pair to determine potential direction
    first_diff = clean_series[2] - clean_series[1]
    
    if first_diff > 0
        # Check for strictly increasing
        for i in 2:(lastindex(clean_series)-1)
            if clean_series[i+1] <= clean_series[i]
                return NOT_MONOTONIC
            end
        end
        return INCREASING
    elseif first_diff < 0
        # Check for strictly decreasing
        for i in 2:(lastindex(clean_series)-1)
            if clean_series[i+1] >= clean_series[i]
                return NOT_MONOTONIC
            end
        end
        return DECREASING
    else
        return NOT_MONOTONIC
    end
end

# Convenience method for DataFrame columns
find_mag_mono(df::DataFrame, col::Symbol) = find_mag_mono(df[!, col])

# Method for checking specific columns in a row
function find_mag_mono(df::DataFrame, row_idx::Integer, col_indices::Vector{Int})
    1 <= row_idx <= nrow(df) || throw(BoundsError(df, row_idx))
    all(1 .<= col_indices .<= ncol(df)) || throw(BoundsError(df, col_indices))
    
    vals = [df[row_idx, i] for i in col_indices]
    return find_mag_mono(vals)
end

# Convenience method for column names
function find_mag_mono(df::DataFrame, row_idx::Integer, cols::Vector{Symbol})
    col_indices = [columnindex(df, col) for col in cols]
    find_mag_mono(df, row_idx, col_indices)
end