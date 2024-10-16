### A Pluto.jl notebook ###
# v0.20.0

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
begin
	using DrWatson
	md" ###### `using` DrWatson"
end

# ╔═╡ ace018d2-003c-496f-b8aa-69eb71fb9057
begin
	# projectDir = "Gitted/Illustris/Fractals_DrW"  # first DrW project directory
	projectDir = "Gitted/OlegIMBH"
	project_path = joinpath(homedir(), projectDir)
	quickactivate(project_path)
end

# ╔═╡ dce8dbce-c8b4-11ed-3263-65232dc16f8d
begin
	using Revise
	using PlutoUI
	using Dates
	using Plots
	using PlotThemes  # PlotThemes needs Plots to work.
	theme(:default) # :dark)
	# using Printf
	
    # AstroIO
  	# using AstroImages
  	# using BSON
  	# using CSV v
  	# using DataFrames
  	# using DrWatson 
  	# using FITSIO 
  	# using FileIO 
  	# using Images 
  	# using ImageIO
    # using JLD2
  	# using NearestNeighbors 
	# using StatsBase # needed for F12, and for some reason get error message in the call to F12 despite it being there
		# not using FI2 these days, so leaving it out
	# using StatsPlots # why do we need this one?
	# using Statistics
	# using HDF5
	# using LinearAlgebra # needed for `norm` of vector
	# using ImageBinarization
	# using ColorVectorSpace # must be included already somewhere --- loaded in few hundred microseconds
	# using IndirectArrays, OffsetArrays
	# using SparseArrays # ? also quick load here, but wasn't being accessed?  check
	# using StaticArrays # didn't improve speed on fractal calculation
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
	md" ###### `using` packages"
end	

# ╔═╡ 581708d0-3df5-4160-8b3c-b3cc870efb16
md" [Julia Markdown Doc](https://docs.julialang.org/en/v1/stdlib/Markdown/#Bold)"

# ╔═╡ 754dbb34-631a-4aea-8660-443f70f11ea9
md"""
!!! note "P22_IMBH_Notes"
	- ###### Origin Date: 3 October 2024
	- Describe progress on project with Oleg to find infrared signature of intermediate black hole in the largest Milky Way globular cluster, Omega Centaurus
"""

# ╔═╡ e85f9903-c869-416a-bf86-cb85a80b065b
begin
	@bind TDate DatePicker(default=today())
	TDate
end

# ╔═╡ 4d9eb5bd-0759-4499-bd42-621834ae7f67
TableOfContents(title = "P22_IMBH_Notes", depth = 6)

# ╔═╡ 2016b7c9-df0f-4f48-95a7-96d31ed199e4
pwd()

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
	# F12 = ingredients("/home/dfc123/Gitted/Illustris/Functions_1a2.jl")
	md"""
	F12 not called, but its 10 functions are described briefly in this cell
	  - could add Periodicity Correction (see e.g., P13d_AverageDen.jl)
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
begin
	# to widen cell width; https://discourse.julialang.org/t/cell-width-in-pluto-notebook/49761/4
	html"""
	<style>
		main {
			margin: 0 auto;
			max-width: 2000px;
	    	padding-left: max(160px, 10%);
	    	padding-right: max(160px, 10%);
		}
	        # 383px to accomodate TableOfContents(aside=true)
	        # 313px on vertical display
			# 160px on vertical display overlaps but gives sufficient space
	</style>
	"""
	md" ###### Widens cell width proportionately to window width."
end

# ╔═╡ 6008384b-131c-4930-81a6-fb680420df33
	md"""
	###### Dark Theme Plot Choice
	If want dark theme for plots, check box:$(@bind darkTH CheckBox(default = false))
	(Saved graphs change, too.)
	"""

# ╔═╡ 94062cd4-b278-444d-b93e-694d26d30b50
begin
	if darkTH theme(:dark) else theme(:default) end
	md"dark theme execution cell"
end

# ╔═╡ 1afaf901-30f0-4b58-98a5-a8ae88f3fccb
md"""
###### Two "choose server" cells disabled.
"""

# ╔═╡ f22ea8e5-e458-47bc-950a-3c8e0de06df3
# ╠═╡ disabled = true
#=╠═╡
md"""
If using Framework (not external drive) & not the server in Virginia, clear checkbox (sets `DCServer` to `false`): $(@bind DCServer CheckBox(default=true))
"""
  ╠═╡ =#

# ╔═╡ d68c548a-71a3-45e6-9ec5-a6d9358a716a
# ╠═╡ disabled = true
#=╠═╡

begin
	if DCServer
		basePath = "/home/dcioffi/Gitted/Illustris/"
	else
		basePath = "/home/dfc123/Gitted/Illustris/FractalImages/"
	end
	# ImageNames = cd(readdir, ImageDirectory)
	md" Resulting `basePath`: $basePath
	
- if ever using server again, will use `homedir()` and `projectdir()`
	  "
end
  ╠═╡ =#

# ╔═╡ 9a46221b-68f7-4101-b30a-13cc6d87f213
md" ##### Begin New Coding Here."

# ╔═╡ 15899cbb-53e1-4160-b24c-40fa959aa926
md"""
### What's Happened So far (3 October)
!!! note "0) ... /OlegIMBH/notebooks/P22_JWST.jl (20 Sept.)"
	    -- MAST stands for Mikulski Archive Space Telescopes
    - MIRI: Mid-InfraRed Instrument: 4.9 to 28.8 μm
      - "i2d" means "that this is a rectified and calibrated image mosaic"
      - from Stage 3: "2-D resampled PSF-subtracted image"
      - "segm" is a "Segmentation Map"
    - An ECSV file contains a "Source Catalog Table," e.g., `jw02491-o005_t002_miri_f1130w_cat.ecsv`
	  - Can read ESCV file either by denoting commenting symbol directly (`CSV.read(joinpath(dataDir_T45_f1130, six_f1130[3]), DataFrame; comment = "#", normalizenames=true)`) or or by going to header line directly (`CSV.read(joinpath(dataDir_T45_f1130, six_f1130[3]), DataFrame; header = 263,  drop=[:label], normalizenames=true)`)
	    - Latter example excludes the "label" column (which is identical to the original Julia index), which we end up needing later for better cross matching.
      - [Definitions of column headings can be found here.](https://jwst-pipeline.readthedocs.io/en/stable/jwst/source_catalog/main.html)
!!! note "1) .../OlegIMBH/scripts/sixCrossMatches.jl"
!!! note "2) .../OlegIMBH/scripts/testingCrossMatches.jl"
!!! note "3) .../histo_six.jl => .../OlegIMBH/notebooks/P23_IMBH_Histo.jl"
!!! note "4) .../OlegIMBH/scripts/sixCrossMatches2.jl"
"""

# ╔═╡ c3b4a98c-4025-43bf-96dc-2b3c9b376c59
md"""
### Two Weeks Later ...  (16 October)
!!! note "4) .../OlegIMBH/scripts/sixCrossMatches3.jl"
!!! warning "Here's the problem I did not solve: Matching Catalog A's coordinates to Catalog B's coordinates, and vice versa (Matching Catalog B to A)"

| index| label | match 1| match 2 | index| label | match 1| match 2 |
|:----------:|:---------:|:---------:|:----------:|:----------:|:---------:|:----------:|:----------:|
| 17| 19 | 255| 265 | 170 | $\leftarrow 255$ | 19 |
| 18| 20 | 255| 265 |     | 257| 20 |
|   | 20 |    | 265| |   $\leftarrow 265$ | 20 | |

!!! note " "
    - So, because of the reverse matchup, 19 gets matched with 255, and then 20 gets matched with 265.  The coding is not trivial, but if we end up trying again ...

      -- Set `df_rowAtoB = 3` and `df_rowAtoB = 4`. Two lines that can show the information for the problem to be solved are 
         - for i in eachindex(df[df\_rowAtoB, "Catalog A labels"])  println("$i) ", df[df\_rowAtoB, "Catalog A labels"][i, 1], " ", df[df\_rowAtoB, "Catalog B matching labels"][i, 1:NN\_level]) end

        - for i in eachindex(df[df\_rowBtoA, "Catalog A labels"])  println("$i) ", df[df\_rowBtoA, "Catalog A labels"][i, 1], " ", df[df\_rowBtoA, "Catalog B matching labels"][i, 1:NN\_level]) end

      -- And, BTW, `/home/dfc123/Gitted/OlegIMBH/src/GalCen/buildDuplicateDict.jl` has an uncommented comment line that prevents it from running.

### DOLPHOT
!!! note ""
    - Yesterday, Oleg and I looked at Jeremy's [DOLPHOT](http://americano.dolphinsim.com/dolphot/) (manual [here](http://americano.dolphinsim.com/dolphot/dolphot.pdf)) production of Omega Cen data.  I had not realized that the previous data were of the galactic center, so previous data and code moved into:
    `GalacticCenter` directory created in `OlegIMBH/data/exp_raw` and `GalCenter`s in `scripts` and `src` directories.
!!! warning "Where (and how) to back up the original data, i.e., those stored in \data\exp_raw?"

"""

# ╔═╡ Cell order:
# ╟─581708d0-3df5-4160-8b3c-b3cc870efb16
# ╠═754dbb34-631a-4aea-8660-443f70f11ea9
# ╟─e85f9903-c869-416a-bf86-cb85a80b065b
# ╠═4d9eb5bd-0759-4499-bd42-621834ae7f67
# ╟─2016b7c9-df0f-4f48-95a7-96d31ed199e4
# ╟─572dbcee-cb58-4b21-8993-5d159f02228b
# ╟─ace018d2-003c-496f-b8aa-69eb71fb9057
# ╟─dce8dbce-c8b4-11ed-3263-65232dc16f8d
# ╟─e0a42a3c-00de-4ff6-8862-46fcd0596315
# ╟─0e55ef3f-a3d3-4f3b-832a-a5d3766e7b09
# ╟─43981055-f016-46e6-a019-9ac4501db0ad
# ╟─6008384b-131c-4930-81a6-fb680420df33
# ╟─94062cd4-b278-444d-b93e-694d26d30b50
# ╟─1afaf901-30f0-4b58-98a5-a8ae88f3fccb
# ╟─f22ea8e5-e458-47bc-950a-3c8e0de06df3
# ╟─d68c548a-71a3-45e6-9ec5-a6d9358a716a
# ╠═9a46221b-68f7-4101-b30a-13cc6d87f213
# ╟─15899cbb-53e1-4160-b24c-40fa959aa926
# ╠═c3b4a98c-4025-43bf-96dc-2b3c9b376c59
