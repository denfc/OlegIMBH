"""
	dfc 11 December 2024
	- Although initial reference was key function was Stackoverflow, Copilot developed the version used

    count_monotonicity_types(df::DataFrame, cols::Vector{Symbol})

Categorize rows based on monotonicity of values across specified columns.

# Arguments
- `df::DataFrame`: Input data frame
- `cols::Vector{Symbol}`: Column names to check for monotonicity

# Returns
Named tuple containing:
- `decreasing`: Indices where values strictly decrease
- `increasing`: Indices where values strictly increase
- `not_monotonic`: Indices with non-monotonic patterns

# Example
```julia
df = DataFrame(a=[1,2,1], b=[2,1,3], c=[3,0,2])
results = count_monotonicity_types(df, [:a, :b, :c])
# results.decreasing contains rows with decreasing values
"""

include(joinpath(homedir(), "Gitted/OlegIMBH/src/introMonotonicity.jl"))

dfMiriNircam = jldopen(datadir("sims/dfMIRI_matched_data.jld2"))["dfMIRI_matched_data"]

col_ind = [:mag200, :mag444, :mag770, :mag1500]

#= when we were doing one row at a time
row_idx = 6100

result = check_monotonicity(dfMiriNircam, 1, col_ind)
if result == DECREASING::Monotonicity
	# Can extract values from specified columns in the row
	vals = [dfMiriNircam[row_idx, i] for i in col_ind]
	print(join(vals, ", "), ": ", result)
end
=#

function count_monotonicity_types(df::DataFrame, cols::Vector{Symbol})
    decreasing_rows = Int[]
    increasing_rows = Int[]
    not_monotonic_rows = Int[]
    
    for row in 1:nrow(df)
        result = find_mag_mono(df, row, cols)
        if result == DECREASING
            push!(decreasing_rows, row)
        elseif result == INCREASING
            push!(increasing_rows, row)
        else
            push!(not_monotonic_rows, row)
        end
    end
    
    return (
        decreasing=decreasing_rows,
        increasing=increasing_rows,
        not_monotonic=not_monotonic_rows
    )
end

results = count_monotonicity_types(dfMiriNircam, col_ind)

println("Decreasing ($(length(results.decreasing)) rows): ") # , join(results.decreasing, ", "))
println("Increasing ($(length(results.increasing)) rows): ", join(results.increasing, ", "))
println("Not monotonic ($(length(results.not_monotonic)) rows): ") # , join(results.not_monotonic, ", "))