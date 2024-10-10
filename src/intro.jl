using DrWatson
@quickactivate "OlegIMBH"

# Here you may include files from the source directory
# include(srcdir("dummy_src_file.jl"))
include(srcdir("crossmatches.jl"))
# include(srcdir("reshapeCoords.jl"))
include(srcdir("orderNoExtended.jl"))
include(srcdir("logXFitHisto.jl"))

using Base.Threads
using Revise
using Plots
using CSV, DataFrames
using NearestNeighbors
using JLD2
using StatsBase
using Plots
using DataStructures # for `OrderedDict`
# using Unitful, UnitfulAstro
# using AstroImages, FITSIO
# using Meshes #  MeshViz DO NOT USE (totally messed things up)
# import CairoMakie as Mke
# using Cosmology, Unitful, UnitfulAstro, Measurements 
# using Suppressor
# include(srcdir("commas.jl"))

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