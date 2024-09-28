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
	# using StatsBase # needed for F12, and for some reason get error message in the call to F12 despite it being there
		# not using FI2 these days, so leaving it out
	# using HDF5
	# using LinearAlgebra # needed for `norm` of vector
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
	md" Basic `using` functions and commented-out extras in this cell"
end	

# ╔═╡ 754dbb34-631a-4aea-8660-443f70f11ea9
md"""
!!! note "Notebook title."
    ###### Origin Date: day month 2023
	- NOW ASSUMING DR WATSON!
	- Description of intent

Note that the date below does not update automatically unless notebook (or that cell) is re-run.
"""

# ╔═╡ e85f9903-c869-416a-bf86-cb85a80b065b
begin
	@bind TDate DatePicker(default=today())
	TDate
end

# ╔═╡ 4d9eb5bd-0759-4499-bd42-621834ae7f67
TableOfContents(title = "Pxx; the `using` cell", depth = 6)

# ╔═╡ 2016b7c9-df0f-4f48-95a7-96d31ed199e4
pwd()

# ╔═╡ 9ec5399d-0384-4942-a703-2fff12941b97
md"""
!!! warning "Careful! `projectDir` name different from `DrWatson.projectdir()` function."
"""

# ╔═╡ e0a42a3c-00de-4ff6-8862-46fcd0596315
function ingredients(path::String) # https://github.com/fonsp/Pluto.jl/issues/115#issuecomment-661722426
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ 0e55ef3f-a3d3-4f3b-832a-a5d3766e7b09
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

# ╔═╡ 43981055-f016-46e6-a019-9ac4501db0ad
# to widen cell width; https://discourse.julialang.org/t/cell-width-in-pluto-notebook/49761/4
html"""
<style>
	main {
		margin: 0 auto;
		max-width: 2000px;
    	padding-left: max(160px, 10%);
    	padding-right: max(160px, 10%);
	}
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

# ╔═╡ f22ea8e5-e458-47bc-950a-3c8e0de06df3
md"""
###### Choose server.
If using Framework (not external drive) & not the server in Virginia, clear checkbox (sets `DCServer` to `false`): $(@bind DCServer CheckBox(default=true))
"""

# ╔═╡ d68c548a-71a3-45e6-9ec5-a6d9358a716a
begin
	if DCServer
		basePath = "/home/dcioffi/Gitted/Illustris/"
	else
		basePath = "/home/dfc123/Gitted/Illustris/FractalImages/"
	end
	# ImageNames = cd(readdir, ImageDirectory)
	md" ###### Resulting `basePath`: $basePath "
		# and its `ImageNames` directory listing. 
end

# ╔═╡ 9a46221b-68f7-4101-b30a-13cc6d87f213
md" ###### Begin New Coding Here."

# ╔═╡ Cell order:
# ╠═754dbb34-631a-4aea-8660-443f70f11ea9
# ╟─e85f9903-c869-416a-bf86-cb85a80b065b
# ╠═4d9eb5bd-0759-4499-bd42-621834ae7f67
# ╟─2016b7c9-df0f-4f48-95a7-96d31ed199e4
# ╠═572dbcee-cb58-4b21-8993-5d159f02228b
# ╠═9ec5399d-0384-4942-a703-2fff12941b97
# ╠═ace018d2-003c-496f-b8aa-69eb71fb9057
# ╠═dce8dbce-c8b4-11ed-3263-65232dc16f8d
# ╟─e0a42a3c-00de-4ff6-8862-46fcd0596315
# ╟─0e55ef3f-a3d3-4f3b-832a-a5d3766e7b09
# ╟─43981055-f016-46e6-a019-9ac4501db0ad
# ╟─a7f8f920-5ee8-420a-bcb2-fcd30dde7d28
# ╟─94062cd4-b278-444d-b93e-694d26d30b50
# ╠═f22ea8e5-e458-47bc-950a-3c8e0de06df3
# ╠═d68c548a-71a3-45e6-9ec5-a6d9358a716a
# ╠═9a46221b-68f7-4101-b30a-13cc6d87f213
