### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 572dbcee-cb58-4b21-8993-5d159f02228b
using DrWatson

# ╔═╡ ace018d2-003c-496f-b8aa-69eb71fb9057
begin
	projectDir = "Gitted/OlegIMBH"
	project_path = joinpath(homedir(), projectDir)
	quickactivate(project_path)
end

# ╔═╡ dce8dbce-c8b4-11ed-3263-65232dc16f8d
begin
	using Revise
	using PlutoUI
	using Dates
	# using Printf
	using StatsBase 
	using JLD2 # HDF5
	using DataFrames
	using LinearAlgebra # needed for `norm` of vector
	using Plots
	using PlotThemes  # PlotThemes needs Plots to work.
	theme(:default) # :dark)
	# using Images
	# using ImageBinarization
	# using ColorVectorSpace # must be included already somewhere --- loaded in few hundred microseconds
	# using IndirectArrays, OffsetArrays
	# using SparseArrays # ? also quick load here, but wasn't being accessed?  check
	# using StaticArrays # didn't improve speed on fractal calculation
	# using StatsPlots # why do we need this one?
	# using Statistics
	# using ReferenceFrameRotations
	# using Interpolations
	# using Distributions
	# using Random
#=	import Pkg
	Pkg.add(url="https://github.com/illustristng/illustris_julia.git")
	import illustris_julia as il
=#
	# using Roots
	# using LsqFit
	# using DelimitedFiles
	# using Measurements # via Paul Barrett
	# using Unitful # ditto
	md" `using` functions and commented-out extras in this cell"
end	

# ╔═╡ 11ed019b-d12b-4a31-8251-a14feaec35a5
include(srcdir("logXFitHisto.jl"))

# ╔═╡ 754dbb34-631a-4aea-8660-443f70f11ea9
md"""
!!! note "Notebook title."
    ###### Origin Date: 1 Oct 2024
	- after basic reading and plotting code worked out in /home/dfc123/Gitted/OlegIMBH/scripts/histo_six.jl, will use Pluto's ability to show plots with varying bin sizes

Note that the date below does not update automatically unless notebook (or that cell) is re-run.
"""

# ╔═╡ e85f9903-c869-416a-bf86-cb85a80b065b
begin
	@bind TDate DatePicker(default=today())
	TDate
end

# ╔═╡ 4d9eb5bd-0759-4499-bd42-621834ae7f67
TableOfContents(title = "P23 IMBH Histogram Plotting", depth = 6)

# ╔═╡ 2016b7c9-df0f-4f48-95a7-96d31ed199e4
pwd()

# ╔═╡ 0e55ef3f-a3d3-4f3b-832a-a5d3766e7b09
# ╠═╡ disabled = true
#=╠═╡
begin
	F12 = ingredients("/home/dfc123/Gitted/Illustris/Functions_1a2.jl")
	md"""
	10 functions in F12 described briefly, via comments, in this cell
	  - need to add Periodicity Correction (see e.g., P13d_AverageDen.jl)
	"""
#=
	1. **function utherm\_ne\_to\_temp(utherm, nelec::Vector{Float32}, constantMu::Any)**  return temp (temp = utherm * (gamma-1.0) ./ boltzmann * UnitEnergy_in_cgs / UnitMass_in_g .* meanmolwt) # "nelec" is "ElectronAbundance" = x\_e = n\_e/n\_H (see [FAQ, Illustris Data Specifications] (https://www.illustris-project.org/data/docs/faq/) )
	1. **function GetFilename()**     return readline()
	1. **function GetDirPath()** return y, resF, startCnt # resF is the resulting file name that function resulting_file created from user input
	1. **function ReadSnapshotHeader(basePath, SnapNo, subhaloID, attribute)** return h2[attribute]
	1. **function OneLineIndices(V::Any, fname::String)** # typically V is keys of a dictionary, but can work on e.g., any vector
	1. **function LogXFitHisto(X::Array, binSize::Float64, x_nolog::Bool)** return Xticks, Xlims, Yends, Yticks, Ylims, y\_fit, h
	1. **function xyTLabels(x, y, T, xlims, ylims, ann::Tuple, f\_name::String)** savefig(plot!(xlabel = x, ylabel = y, title= T, annotation=ann), f\_name) 
	1. **function MaxMinRatMed(X::Vector)** return max, min, ratio, med
	1. **function commas(num::Integer)** return replace(str, r"(?<=[0-9])(?=(?:[0-9]{3})+(?![0-9]))" => ",")
	1. **function SolarMppc3(M::Vector, R::Vector), function SolarMppc3(M, R)** return capRho, assumptions
=#
end
  ╠═╡ =#

# ╔═╡ 43981055-f016-46e6-a019-9ac4501db0ad
# to widen cell width; https://discourse.julialang.org/t/cell-width-in-pluto-notebook/49761/4
html"""
<style>
	main {
		margin: 0 auto;
		max-width: 2000px;
    	padding-left: max(160px, 10%);
    	padding-right: max(383px, 10%);
	}
        # 383px to accomodate TableOfContents(aside=true)
        # 313px on vertical display
		# 160px on vertical display overlaps but gives sufficient space
</style>
Widens cell width proportionally to window width.
"""

# ╔═╡ a7f8f920-5ee8-420a-bcb2-fcd30dde7d28
	md"""
	###### Dark Theme Plot Choice
	If want dark theme for plots, check box:$(@bind darkTH CheckBox(default = false))
	(Saved graphs change, too.)
	"""

# ╔═╡ 94062cd4-b278-444d-b93e-694d26d30b50
begin
	if darkTH theme(:dark) else theme(:default) end
	md" dark theme execution cell "
end

# ╔═╡ 9a46221b-68f7-4101-b30a-13cc6d87f213
md" ###### Begin New Coding Here."

# ╔═╡ 88f7b44a-c8b7-43e0-bac2-4e45647af4aa
begin
	# Define the file path
	file_path = projectdir("crossMatches.txt")
	
	# Open and read the file line by line
	lines = open(file_path) do file
		readlines(file)
	end
end

# ╔═╡ 8ee2a9d7-add8-44cd-82da-8905f12105cc
begin
	df = jldopen(projectdir("crossMatches_df.jld2"))["crossMatches_df"]
	
	allDistancesMatrix = [df[i, :dists] for i in 1:6]
	allDistances = vec(vcat([allDistancesMatrix[i] for i in 1:6]...))
end

# ╔═╡ 8bfc5476-3fed-42b1-9894-38d65d0af1ca
names(df)

# ╔═╡ 074d8f67-a981-45db-8720-7648b1257ea8
df[1:6, ["twoCats", "N_unique", "N Ext"]], df[1:6, "N_unique"] .- df[1:6, "N Ext"]

# ╔═╡ 642a46b9-70fd-4605-a160-d5a058404dae
begin
	println([length(df[i, "extended?"]) for i in 1:6])
	println([length(df[i, "uniqueIDs"]) for i in 1:6])
	println("Checking that length of the `extended?` array is same as `uniqueIDs` to make sure that the number of extended is just from the unique IDs.")
	[length(df[i, "extended?"]) for i in 1:6] == [length(df[i, "uniqueIDs"]) for i in 1:6]
end

# ╔═╡ e1a2234d-5f45-4b01-a3e8-bbbe4a58aaf7
legend_position = :topleft

# ╔═╡ f84eb1ce-a852-4b7d-9977-2f636f0770e2
md"Select bin size $(@bind binSize Slider(0.01:0.01:0.5, default = 0.1, show_value=true))"

# ╔═╡ 7e1156a2-f6fe-4df5-add7-e353f6671680
begin
	label = "all six distances"
	xT, xL, yends, yT, yL, y_fit = logXFitHisto(allDistances, binSize, false)
	plt = plot(y_fit, yaxis=:log10, ylims = yL, yminorticks = 9, xminorticks = 10, yticks = yT, xlims = xL, xticks = xT, label = label, seriestype=:steppost, widen = true, fg_legend = :transparent, legend = legend_position)
	# println("to avoid showing plot")
end

# ╔═╡ bb0b8fd1-715c-4748-b887-a210e293fd22
begin
	pltt = []
	for i in 1:6
		xT, xL, yends, yT, yL, y_fit = logXFitHisto(vec(allDistancesMatrix[i]), binSize, false)
		plt = plot(y_fit, yaxis=:log10, ylims = (1.0, 1000.0), yminorticks = 9, xminorticks = 10, yticks = [1.0, 10.0, 100.0, 1000.0], xlims = xL, xticks = xT, label = df[i, :twoCats], seriestype=:steppost, widen = true, fg_legend = :transparent, legend = legend_position)
		push!(pltt, plt)
		# `yticks` and `ylims` hard-coded so they're the same in all six
	end	
end

# ╔═╡ bd41e50c-5907-4d41-8d6b-72ffca5f524f
pltt[1]

# ╔═╡ c24ebdeb-7427-4106-adbb-338118e9fbef
pltt[2]

# ╔═╡ 6451be3c-e9b8-490a-add9-1d294ce14c13
pltt[3]

# ╔═╡ 0c481b8f-4c8e-4cf4-8f7f-be78c2a2cbf2
pltt[4]

# ╔═╡ 220bd0a1-ac94-4fc4-ac9a-b817a3adcbcc
pltt[5]

# ╔═╡ 6e2ca1c2-248e-45a1-8915-1fc2ee31cf75
pltt[6]

# ╔═╡ Cell order:
# ╟─754dbb34-631a-4aea-8660-443f70f11ea9
# ╟─e85f9903-c869-416a-bf86-cb85a80b065b
# ╠═4d9eb5bd-0759-4499-bd42-621834ae7f67
# ╟─2016b7c9-df0f-4f48-95a7-96d31ed199e4
# ╠═572dbcee-cb58-4b21-8993-5d159f02228b
# ╟─ace018d2-003c-496f-b8aa-69eb71fb9057
# ╟─dce8dbce-c8b4-11ed-3263-65232dc16f8d
# ╟─0e55ef3f-a3d3-4f3b-832a-a5d3766e7b09
# ╟─43981055-f016-46e6-a019-9ac4501db0ad
# ╟─a7f8f920-5ee8-420a-bcb2-fcd30dde7d28
# ╟─94062cd4-b278-444d-b93e-694d26d30b50
# ╠═9a46221b-68f7-4101-b30a-13cc6d87f213
# ╠═11ed019b-d12b-4a31-8251-a14feaec35a5
# ╟─88f7b44a-c8b7-43e0-bac2-4e45647af4aa
# ╟─8bfc5476-3fed-42b1-9894-38d65d0af1ca
# ╠═074d8f67-a981-45db-8720-7648b1257ea8
# ╟─642a46b9-70fd-4605-a160-d5a058404dae
# ╟─8ee2a9d7-add8-44cd-82da-8905f12105cc
# ╠═e1a2234d-5f45-4b01-a3e8-bbbe4a58aaf7
# ╠═7e1156a2-f6fe-4df5-add7-e353f6671680
# ╠═f84eb1ce-a852-4b7d-9977-2f636f0770e2
# ╟─bb0b8fd1-715c-4748-b887-a210e293fd22
# ╠═bd41e50c-5907-4d41-8d6b-72ffca5f524f
# ╠═c24ebdeb-7427-4106-adbb-338118e9fbef
# ╠═6451be3c-e9b8-490a-add9-1d294ce14c13
# ╠═0c481b8f-4c8e-4cf4-8f7f-be78c2a2cbf2
# ╠═220bd0a1-ac94-4fc4-ac9a-b817a3adcbcc
# ╠═6e2ca1c2-248e-45a1-8915-1fc2ee31cf75
