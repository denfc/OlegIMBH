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
	# using Base.Threads
	using Revise
	using PlutoUI
	# using Dates
	# using Plots
	using PlotlyJS
	using PlutoPlotly
	# using PlotThemes  # PlotThemes needs Plots to work.
	# theme(:default) # :dark)
	# using Printf
	
    # AstroIO
  	using AstroImages
	using ImageTransformations
  	# using BSON
  	# using CSV v
  	# using DataFrames
  	# using DrWatson 
  	# using FITSIO 
  	# using FileIO 
  	using Images 
  	# using ImageIO
	# using ImageCore
	# using Base64
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
	# using IndirectArrays
	using OffsetArrays
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
!!! note "P24_ViewOmCen"
	- ###### Origin Date: 18 October 2023
	- Eventually we need to put some xy points on the image.  Starting here.
"""

# ╔═╡ 4d9eb5bd-0759-4499-bd42-621834ae7f67
TableOfContents(title = "P24_ViewOmCen", depth = 6)

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
# ╠═╡ disabled = true
#=╠═╡
begin
	if darkTH theme(:dark) else theme(:default) end
	md"dark theme execution cell"
end
  ╠═╡ =#

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

# ╔═╡ 64b961a3-fa66-4405-b6f6-f486045e804a
md" Example below [here.](https://plotly.com/julia/images/)

Detailed reference [here](https://plotly.com/julia/reference/layout/images/)
"

# ╔═╡ 6c93055c-6a96-4d1e-a6b8-f4a60a5a5348
begin
	# Clamp the values to the [0, 1] range
	# clamped_imgAI = map(clamp01nan, imgAI)
	# Convert the image to a base64 string or save it as a file
	# save("clamped_imgAI.png", clamped_imgAI)
end

# ╔═╡ 03a778db-d813-4bea-805f-bb516174a7df
img_path = joinpath(projectdir(), "notebooks/clamped_imgAI.png")

# ╔═╡ 1ba5e1ac-f4b3-42cf-ae1a-c2c73c2694c0
pp_configStatic = PlutoPlotly.PlotConfig(staticPlot = true)

# ╔═╡ b1ded347-777a-499a-ba1e-e346660b8568
begin
	# using PlotlyJS
	
	# Add trace
	trace= scatter(x=[0, 0.5, 1, 2, 2.2], y=[1.23, 2.5, 0.42, 3, 1])
	
	# Add images
	layout = Layout(
	    # template=templates.plotly_white,
		# template=templates.plotly_dark,
	    images=[
	        attr(               source="https://upload.wikimedia.org/wikipedia/commons/1/1f/Julia_Programming_Language_Logo.svg"
				# source = img_path
				# source = LocalResource(img_path)
			# source="data:image/png;base64," * base64encode(imgLoad_array)
,	            xref="x",
	            yref="y",
	            x=0,
	            y=3,
	            sizex=2,
	            sizey=2,
	            sizing="stretch",
	            opacity= 0.5,
	            layer="above" # below"
	        )
	    ]
	)
	
	PlutoPlotly.plot(trace, layout, config = pp_configStatic)
end

# ╔═╡ 729f54ab-b4a4-40c3-8ccd-cc4e85829fb3
md" #### The Image "

# ╔═╡ cd2b0c75-c8e3-4101-936a-78ae97d72ddc
imgFile = "/home/dfc123/Gitted/OlegIMBH/data/exp_raw/OmegaCen/jw04343-o002_t001_nircam_clear-f200w_i2d.fits"

# ╔═╡ ed6a08d6-74ed-4448-b4ac-8560df7c5a6a
imgLoad = AstroImages.load(img_path)

# ╔═╡ d488c970-8a7d-4c55-a2e1-dc816bf3afcd
begin
	imgLoad_rotated = ImageTransformations.imrotate(imgLoad, -π/2)
	# imgLoad_rotated = convert(eltype(imgLoad), imgLoad_rotated)
end;

# ╔═╡ ad1d1616-3666-401e-a137-180ddf745efb
typeof(imgLoad_rotated)

# ╔═╡ 15b72413-9a93-4781-adf6-701984ed1a4b
eltype(imgLoad)

# ╔═╡ 257fa654-5c55-47c7-9ba9-c4543c08a9dc
	imgLoad_array64 = Float64.(imgLoad);

# ╔═╡ 4f1f0cdb-484c-435b-8f15-a0ca38be7374
	# imgAI_array = Float64.(imgAI)

# ╔═╡ 9ae25e5e-cad1-4d60-afaf-0ae03c7e4124
md"""!!! warning "`AstroImage(file)` appears to have rotated image compared to `load(file)`" """

# ╔═╡ ee07a851-6e3d-4a04-ac69-cd7431059f49
# f = FITS(imgFile)

# ╔═╡ b64c3398-3029-4679-ab94-e0749e255edc
md"""!!! note "Here, at least, can just read it directly (see "true," below)." """

# ╔═╡ ceb7f3d7-7465-4833-a666-95430795ec4e
# AstroImage(f[2]) == AstroImage(imgFile)

# ╔═╡ 8f1138bb-86c1-42b7-ada7-51b10b71a77f
# f[2]

# ╔═╡ 82bc8292-88d3-40f0-921b-16962697be8b
# hdu = f[1]

# ╔═╡ 111d9674-8bae-42fa-be6f-8f5a80fbcae6
md"""!!! note "Assume that the image loaded with `AstroImage` has the correct orientation, and rotate the image loaded with `load` to match it.  The rotation causes type-mathing problems that require a couple of functions to correct so that the "overlay" below can succeed." """

# ╔═╡ 0a983c06-d756-4f2c-b0ec-b7af12470b5b
imgAI = AstroImages.AstroImage(imgFile)

# ╔═╡ 000e04a7-c33c-44c8-bfc9-643aac23b52a
# typeof(imgAI)

# ╔═╡ 3e369fc8-2555-4c2a-b2e4-5b74a84aba25
# size(imgAI)

# ╔═╡ 6a53f77d-514a-42fa-a884-fbd673cecb66
# imview(imgAI); # same view

# ╔═╡ 1304c5b4-e006-4d78-ac90-f78b10e272f2
# ╠═╡ disabled = true
#=╠═╡
begin
# using AstroImages
# using ImageTransformations

# Load the background and foreground images
bg = load(img_path)
fg = load(img_path)

# Transform the foreground image (e.g., rotate and resize)
fg_transformed = imrotate(fg, π/4)  # Rotate by 45 degrees
fg_transformed = imresize(fg_transformed, ratio=0.5)  # Resize to 50%

# Define the position where the foreground image will be placed
pos = (100, 100)

# Overlay the images
function overlay_images(bg, fg, pos)
    mask = Gray.(fg)
    mask[:] .= Gray(1)
    img = warp(fg, ImageTransformations.Translation(pos...))
    mask = warp(mask, ImageTransformations.Translation(pos...))
    scene = copy(bg)
    scene[findall(mask .== Gray(1))] = img[mask .== Gray(1)]
    return scene
end

result = overlay_images(bg, fg_transformed, pos)
imview(result)

end
  ╠═╡ =#

# ╔═╡ ae05adc5-43ef-444c-aa73-7f36db784cd6
typeof(imgLoad)

# ╔═╡ 8c38f62d-bb8f-4896-a75b-51b10a401c4a
img_height, img_width = size(imgLoad)

# ╔═╡ 51535fb5-a470-460a-91a0-56761884c73a
plot_data = PlotlyJS.plot(
    scatter(x=0:0.1:2π, y=sin.(0:0.1:2π), mode="lines", name="Sine Wave"),
    Layout(
        width=img_width,
        height=img_height,
        margin=attr(l=0, r=0, t=0, b=0),
        xaxis=attr(
            showgrid=false, 
            zeroline=false, 
            showline=false, 
            ticks="", 
            domain=[0, 1], 
            automargin=false
        ),
        yaxis=attr(
            showgrid=false, 
            zeroline=false, 
            showline=false, 
            ticks="", 
            domain=[0, 1], 
            automargin=false
        )
    )
)

# ╔═╡ 71f2a83c-b130-4a6c-a2b4-8abe62f1745c
begin
	PlotlyJS.savefig(plot_data, "plot_image.png")
end

# ╔═╡ d7f12f2e-24a6-4fdf-969a-bffde0cd221a
plot_image = load("plot_image.png")

# ╔═╡ 0f7487ef-674f-46cb-8988-ffdfe03e2061
# plot_image_resized = imresize(plot_image, size(imgLoad))
plot_image_resized = imresize(plot_image, size(imgLoad_rotated))
# plot_image_resized = imresize(plot_image, size(imgAI_array)) NO GO AFTER ROTATION

# ╔═╡ 513ce5fb-cc1a-403b-b39c-2e0437e7ec5b
imgLoad_rotated_noOffset = OffsetArrays.no_offset_view(imgLoad_rotated);

# ╔═╡ 94efbdc4-26dd-4047-a1af-506fd9442911
imgLoad_final = Array(imgLoad_rotated_noOffset);

# ╔═╡ 3c94a86e-fb55-4875-a75d-0a31d8e604a5
size(plot_image_resized), size(imgLoad_rotated), size(imgLoad_final)

# ╔═╡ 66287ca0-bb84-4d0a-a5ac-b2b84b6067e5
overlay_img = imgLoad_final .* 0.7 .+ plot_image_resized .* 0.3
# overlay_img = imgAI_array .* 0.7 .+ plot_image_resized .* 0.3

# ╔═╡ 2e4f26c4-29d7-4048-82b2-77e3cbd1fda4
md"""!!! warning "rotation (via `imrotate`, commented out above), changes the type and then they cannot be added to produce `overlay_img` in the cell above." """

# ╔═╡ 5a876aac-7f1a-430e-a8fa-20f21cd75030
typeof(imgLoad)

# ╔═╡ ef496bb9-b004-462c-95b5-bec8cc7664bf
typeof(imgLoad_rotated)

# ╔═╡ e3b63ea6-7eed-4cde-928d-4ed2d7e14d60
typeof(imgLoad_final)

# ╔═╡ 36773c21-1e8c-4936-8f41-f9eef21bccdd
typeof(plot_image_resized)

# ╔═╡ 4ffe5f76-3986-4e76-a37e-9ef4ebb429fa
size(overlay_img)

# ╔═╡ Cell order:
# ╟─581708d0-3df5-4160-8b3c-b3cc870efb16
# ╠═754dbb34-631a-4aea-8660-443f70f11ea9
# ╠═4d9eb5bd-0759-4499-bd42-621834ae7f67
# ╟─2016b7c9-df0f-4f48-95a7-96d31ed199e4
# ╟─572dbcee-cb58-4b21-8993-5d159f02228b
# ╠═ace018d2-003c-496f-b8aa-69eb71fb9057
# ╠═dce8dbce-c8b4-11ed-3263-65232dc16f8d
# ╟─e0a42a3c-00de-4ff6-8862-46fcd0596315
# ╟─0e55ef3f-a3d3-4f3b-832a-a5d3766e7b09
# ╟─43981055-f016-46e6-a019-9ac4501db0ad
# ╟─6008384b-131c-4930-81a6-fb680420df33
# ╟─94062cd4-b278-444d-b93e-694d26d30b50
# ╟─1afaf901-30f0-4b58-98a5-a8ae88f3fccb
# ╟─f22ea8e5-e458-47bc-950a-3c8e0de06df3
# ╟─d68c548a-71a3-45e6-9ec5-a6d9358a716a
# ╠═9a46221b-68f7-4101-b30a-13cc6d87f213
# ╠═64b961a3-fa66-4405-b6f6-f486045e804a
# ╠═6c93055c-6a96-4d1e-a6b8-f4a60a5a5348
# ╠═03a778db-d813-4bea-805f-bb516174a7df
# ╠═b1ded347-777a-499a-ba1e-e346660b8568
# ╠═1ba5e1ac-f4b3-42cf-ae1a-c2c73c2694c0
# ╟─729f54ab-b4a4-40c3-8ccd-cc4e85829fb3
# ╠═cd2b0c75-c8e3-4101-936a-78ae97d72ddc
# ╠═ed6a08d6-74ed-4448-b4ac-8560df7c5a6a
# ╠═d488c970-8a7d-4c55-a2e1-dc816bf3afcd
# ╠═ad1d1616-3666-401e-a137-180ddf745efb
# ╠═15b72413-9a93-4781-adf6-701984ed1a4b
# ╠═257fa654-5c55-47c7-9ba9-c4543c08a9dc
# ╠═4f1f0cdb-484c-435b-8f15-a0ca38be7374
# ╠═9ae25e5e-cad1-4d60-afaf-0ae03c7e4124
# ╠═ee07a851-6e3d-4a04-ac69-cd7431059f49
# ╠═b64c3398-3029-4679-ab94-e0749e255edc
# ╠═ceb7f3d7-7465-4833-a666-95430795ec4e
# ╠═8f1138bb-86c1-42b7-ada7-51b10b71a77f
# ╠═82bc8292-88d3-40f0-921b-16962697be8b
# ╠═111d9674-8bae-42fa-be6f-8f5a80fbcae6
# ╠═0a983c06-d756-4f2c-b0ec-b7af12470b5b
# ╠═000e04a7-c33c-44c8-bfc9-643aac23b52a
# ╠═3e369fc8-2555-4c2a-b2e4-5b74a84aba25
# ╠═6a53f77d-514a-42fa-a884-fbd673cecb66
# ╠═1304c5b4-e006-4d78-ac90-f78b10e272f2
# ╠═ae05adc5-43ef-444c-aa73-7f36db784cd6
# ╠═8c38f62d-bb8f-4896-a75b-51b10a401c4a
# ╠═51535fb5-a470-460a-91a0-56761884c73a
# ╠═71f2a83c-b130-4a6c-a2b4-8abe62f1745c
# ╠═d7f12f2e-24a6-4fdf-969a-bffde0cd221a
# ╠═0f7487ef-674f-46cb-8988-ffdfe03e2061
# ╠═513ce5fb-cc1a-403b-b39c-2e0437e7ec5b
# ╠═94efbdc4-26dd-4047-a1af-506fd9442911
# ╠═3c94a86e-fb55-4875-a75d-0a31d8e604a5
# ╠═66287ca0-bb84-4d0a-a5ac-b2b84b6067e5
# ╠═2e4f26c4-29d7-4048-82b2-77e3cbd1fda4
# ╠═5a876aac-7f1a-430e-a8fa-20f21cd75030
# ╠═ef496bb9-b004-462c-95b5-bec8cc7664bf
# ╠═e3b63ea6-7eed-4cde-928d-4ed2d7e14d60
# ╠═36773c21-1e8c-4936-8f41-f9eef21bccdd
# ╠═4ffe5f76-3986-4e76-a37e-9ef4ebb429fa
