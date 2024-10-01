# compact enough to not need an intro?
using DrWatson
@quickactivate "OlegIMBH"

include(srcdir("logXFitHisto.jl"))
using JLD2, DataFrames, StatsBase, Plots
using LinearAlgebra # for `normalize`

df = jldopen(projectdir("crossMatches_df.jld2"))
df = df["crossMatches_df"]

allDistances = [df[i, :dists] for i in 1:6]

allDistances = vec(vcat([df[i, :dists] for i in 1:6]...))
label = "all six distances"
legend_position = :topleft

# allDistances = collect(allDistances)
xT, xL, yends, yT, yL, y_fit = logXFitHisto(allDistances, 0.1, false)
plt = plot(y_fit, yaxis=:log10, ylims = yL, yminorticks = 9, xminorticks = 10, yticks = yT, xlims = xL, xticks = xT, label = label, seriestype=:steppost, widen = true, fg_legend = :transparent, legend = legend_position)