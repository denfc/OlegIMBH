"""
	dfc 19 November 2024
	- taken from introRegions.dl
"""

cd(joinpath(homedir(), "Gitted/OlegIMBH"))
using DrWatson
@quickactivate "OlegIMBH"
# using CSV
using DataFrames
using Random

include(srcdir("choices.jl"))
include(srcdir("filter_objects.jl"))
include(srcdir("generateValues.jl"))

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