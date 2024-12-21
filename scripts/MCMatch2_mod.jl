module MCMatch

using Random, Statistics, AstroLib
using Logging

"""
Calculate minimum separation between coordinate pairs using Monte Carlo method.
"""
struct MatchConfig
    num_samples::Int
    max_offset::Float64
    
    function MatchConfig(; num_samples=10000, max_offset=1.0)
        @assert num_samples > 0 "num_samples must be positive"
        @assert max_offset > 0 "max_offset must be positive"
        new(num_samples, max_offset)
    end
end

"""
Calculate error for given declination offset.
"""
function calculate_error(
    delta_offset::Float64, 
    alpha1::Vector{Float64}, 
    delta1::Vector{Float64},
    alpha2::Vector{Float64}, 
    delta2::Vector{Float64},
    sigma_delta1::Float64
)::Tuple{Float64,Vector{Tuple}}
    
    isempty(alpha1) && throw(ArgumentError("Empty input arrays"))
    
    total_error = 0.0
    matched_pairs = Tuple[]
    sizehint!(matched_pairs, length(delta1))
    
    for i in eachindex(delta1)
        min_pair_error = Inf
        best_match = nothing
        
        for j in eachindex(delta2)
            pair_error = (gcirc(2, alpha1[i], delta1[i] + delta_offset, 
                              alpha2[j], delta2[j]) / sigma_delta1)^2
            if pair_error < min_pair_error
                min_pair_error = pair_error
                best_match = (alpha1[i], delta1[i], alpha2[j], delta2[j])
            end
        end
        total_error += min_pair_error
        push!(matched_pairs, best_match)
    end
    
    return (total_error / length(delta1)), matched_pairs
end

"""
Find best match between two coordinate sets.
"""
function find_best_match(
    alpha1::Vector{Float64}, 
    delta1::Vector{Float64},
    alpha2::Vector{Float64}, 
    delta2::Vector{Float64};
    config::MatchConfig = MatchConfig()
)
    # Validate inputs
    @assert length(alpha1) == length(delta1) "Mismatched lengths in set 1"
    @assert length(alpha2) == length(delta2) "Mismatched lengths in set 2"
    
    sigma_delta1 = std(delta1)
    
    best_delta_offset = 0.0
    min_error = Inf
    best_matched_pairs = Tuple[]
    
    @info "Starting Monte Carlo simulation with $(config.num_samples) samples"
    
    for i in 1:config.num_samples
        delta_offset = rand(Uniform(-config.max_offset, config.max_offset))
        error, matched_pairs = calculate_error(
            delta_offset, alpha1, delta1, alpha2, delta2, sigma_delta1)
        
        if error < min_error
            min_error = error
            best_delta_offset = delta_offset
            best_matched_pairs = matched_pairs
        end
    end
    
    @info "Completed simulation" best_delta_offset min_error
    return best_delta_offset, min_error, best_matched_pairs
end

end # module