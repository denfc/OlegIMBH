"""
	dfc 11 December 2024
	- Although initial reference was https://stackoverflow.com/questions/71376803/efficient-method-for-checking-monotonicity-in-array-julia, Copilot developed with function
"""

include(joinpath(homedir(), "Gitted/OlegIMBH/src/introMonotonicity.jl"))

dfMiriNircam = jldopen(datadir("sims/dfMIRI_matched_data.jld2"))["dfMIRI_matched_data"]
