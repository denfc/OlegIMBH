using DrWatson
@quickactivate "OlegIMBH"
using CSV
using AstroImages
using DataFrames
using JLD2
using DataStructures # for OrderedDict
cd(joinpath(homedir(), "Gitted/OlegIMBH"))

# println()
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