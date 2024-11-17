cd(joinpath(homedir(), "Gitted/OlegIMBH"))
using DrWatson
@quickactivate "OlegIMBH"
import SAOImageDS9
const sao = SAOImageDS9
using CSV
using DataFrames
using Random

include(srcdir("choices.jl"))
include(srcdir("load_zoom_grid_color.jl"))
include(srcdir("connectDS9.jl"))
include(srcdir("writeDS9RegFile.jl"))
include(srcdir("verifyRegFileSent.jl"))

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