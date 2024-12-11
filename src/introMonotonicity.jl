"""
	dfc 11 December 2024
	- taken from introMatch.jl, with unneeded packages commented out
"""

cd(joinpath(homedir(), "Gitted/OlegIMBH"))
using DrWatson
@quickactivate "OlegIMBH"
# using CSV
using JLD2
using DataFrames
# using Random
# using SortMerge
# using AstroLib
# using Plots
# using SparseArrays # for `j.cmatch[1]` in `sortMergeMatch`
# include(srcdir("monotonicity.jl"))

println()
println(
"""
Currently active project is: $(projectname())
Path of active project: $(projectdir())
"""
)
#=
Have fun with your new project!

You can help us improve DrWatson by opening
issues on GitHub, submitting feature requests,
or even opening your own Pull Requests!
=#