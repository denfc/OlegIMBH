cd(joinpath(homedir(), "Gitted/OlegIMBH"))
using DrWaton
@quickactivate "OlegIMBH"
using .MCMatch  # Load the module

# Create test data
alpha1 = [10.5, 11.2, 12.1]
delta1 = [45.2, 46.1, 47.3]
alpha2 = [10.6, 11.3, 12.0]
delta2 = [45.1, 46.2, 47.2]

# Create config (optional)
config = MCMatch.MatchConfig(num_samples=5000, max_offset=0.5)

# Run matching
offset, error, pairs = MCMatch.find_best_match(
    alpha1, delta1, alpha2, delta2; 
    config=config
)