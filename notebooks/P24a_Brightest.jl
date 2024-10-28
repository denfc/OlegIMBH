### A Pluto.jl notebook ###
# v0.20.1

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
	using Plots
	using PlotlyJS
	using PlutoPlotly
	# using PlotThemes  # PlotThemes needs Plots to work.
	# theme(:default) # :dark)
	# using Printf
	
    # AstroIO
  	using AstroImages
	using ImageTransformations
  	# using BSON
  	using CSV
  	using DataFrames
  	# using DrWatson 
  	using FITSIO 
  	# using FileIO 
  	using Images 
  	# using ImageIO
	# using ImageCore
	# using Base64
    # using JLD2
  	# using NearestNeighbors 
	using StatsBase # needed for F12, and for some reason get error message in the call to F12 despite it being there
		# not using FI2 these days, so leaving it out
	# using StatsPlots # why do we need this one?
	using Statistics
	# using HDF5
	using LinearAlgebra # needed for `norm` of vector
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

# ╔═╡ 21c7fe2b-631b-46aa-8e77-a2a350c825c4
begin
	include(srcdir("MAST/logXFitHisto.jl"))
	# using Statistics
	# using StatsBase
	# using LinearAlgebra
	# using Plots
end

# ╔═╡ 326975a2-b8b6-4b72-a467-d33a7f959370
begin	
	include(srcdir("writeDS9RegFile.jl"))
	include(srcdir("verifyRegFileSent.jl"))
end

# ╔═╡ 581708d0-3df5-4160-8b3c-b3cc870efb16
md" [Julia Markdown Doc](https://docs.julialang.org/en/v1/stdlib/Markdown/#Bold)"

# ╔═╡ 754dbb34-631a-4aea-8660-443f70f11ea9
md"""
!!! note "P24a_Brightest"
	- ###### Origin Date: 21 October 2023
	- Confirming P24 by plotting the brightest sources and see if they align.
"""

# ╔═╡ 07dfe223-486b-4d25-9b54-243c4074f6ea
md" ###### Title "

# ╔═╡ 4d9eb5bd-0759-4499-bd42-621834ae7f67
TableOfContents(title = "P24a_Brightest", depth = 6)

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
		@media screen {
		main {
			margin: 0 auto;
			max-width: 2000px;
	    	padding-left: max(160px, 10%);
	    	padding-right: max(160px, 10%);
		}
	}
	</style>
	"""
	md" ###### Widens cell width proportionately to window width."
end
# 383px to accomodate TableOfContents(aside=true)
# 313px on vertical display
# 160px on vertical display overlaps but gives sufficient space

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

# ╔═╡ 1ba5e1ac-f4b3-42cf-ae1a-c2c73c2694c0
pp_configStatic = PlutoPlotly.PlotConfig(staticPlot = true)

# ╔═╡ f97cbdb8-8721-46e5-90d4-2023d07726ac
	md"### Reading `omega_cen_phot` "

# ╔═╡ 7ef24bfe-1fce-4ff9-8855-ea31969ecc27
begin
	columnsToRead = 1:37 # nothing # 16:29
	df = CSV.read(joinpath(datadir(), "exp_raw/OmegaCen/omega_cen_phot"), DataFrame; header=false, delim=" ", ignorerepeated = true, select = columnsToRead)
end

# ╔═╡ 729f54ab-b4a4-40c3-8ccd-cc4e85829fb3
md" ### The Image "

# ╔═╡ cd2b0c75-c8e3-4101-936a-78ae97d72ddc
imgFilePath = "/home/dfc123/Gitted/OlegIMBH/data/exp_raw/OmegaCen/jw04343-o002_t001_nircam_clear-f200w_i2d.fits"

# ╔═╡ d8cd93c0-1523-4e76-bad6-4979655b14c3
FITS(imgFilePath)

# ╔═╡ ae5c6ccc-1902-46ce-a0fb-6a126f8b66c1
md"""
!!! danger "`imgLoad` is what you knew as  `imgAI`"
"""

# ╔═╡ ed6a08d6-74ed-4448-b4ac-8560df7c5a6a
# imgLoad = AstroImages.load(imgFilePath)
imgLoad = AstroImages.AstroImage(imgFilePath)

# ╔═╡ 0a1d1c00-b01d-45cc-9d82-bc7dde9827b3
AstroImages.header(imgLoad)

# ╔═╡ 113f37ab-9f05-4f80-b856-4a6beb2fe52a
begin
	# imgLoad_rotated = ImageTransformations.imrotate(imgLoad, -π/2)
	# imgLoad_rotated_noOffset = OffsetArrays.no_offset_view(imgLoad_rotated)
	# Clamp the values to the [0, 1] range
 	# clamped_imgLoad = map(clamp01nan, imgLoad_rotated_noOffset)
	# clamped_imgLoad = Array(clamped_imgLoad)
    clamped_imgLoad = map(clamp01nan, imgLoad)
	clamped_imgLoad = Array(clamped_imgLoad)
	save("clamped_imgLoad.png", clamped_imgLoad)
	# save("clamped_img.png", clamped_imgLoad)
end

# ╔═╡ 9e6de21f-3eb6-47d0-9ca7-671ecc54376e
imview(clamped_imgLoad)
# imview(Array(clamped_imgLoad)) has same orientation

# ╔═╡ 0febb7c0-d295-4625-99ca-83f833558540
begin
		imgLoad_retrieved = AstroImages.load(joinpath(projectdir(), "notebooks/clamped_imgLoad.png"))
	# imgLoad_final = AstroImages.AstroImage(joinpath(projectdir(), "notebooks/clamped_img.png")) doesn't work
		imgLoad_rotated = ImageTransformations.imrotate(imgLoad_retrieved, -π/2) # π)
		imgLoad_final = OffsetArrays.no_offset_view(imgLoad_rotated)
end

# ╔═╡ 2a385a14-028d-4f24-a20f-47070cb5ebb4
typeof(imgLoad_final)

# ╔═╡ 15653ce5-f8b6-4836-92ce-7bf74663d360
typeof(clamped_imgLoad)

# ╔═╡ 3db9dafe-fa4a-481f-81d4-be9e142fe6e0
typeof(imgLoad_final)

# ╔═╡ 1aa44815-bb46-42f4-b442-9df96cc2bc98
typeof(imgLoad)

# ╔═╡ 6fcd8c85-75f9-4f00-ab6f-8bf2f57afa7c
display(imgLoad)

# ╔═╡ 5029ac6f-3ec8-4b01-994c-3626ce018abe
extrema(imgLoad)

# ╔═╡ b0d3aac7-4936-4433-b11e-60586e1666bf
typeof(clamped_imgLoad)

# ╔═╡ 08957b28-eda3-44a1-91e4-0f527a24e329
clamped_retrieved = AstroImages.load("clamped_imgLoad.png");

# ╔═╡ 31225053-43f7-4798-9f89-8d7cb25d16bc
display(clamped_imgLoad)

# ╔═╡ 15b72413-9a93-4781-adf6-701984ed1a4b
display(clamped_retrieved)

# ╔═╡ 8c38f62d-bb8f-4896-a75b-51b10a401c4a
img_height, img_width = size(clamped_retrieved)

# ╔═╡ 3498d52a-2afc-4fba-8de1-5a944e33efff
md"### Check Quality"

# ╔═╡ c47856aa-0255-408c-9ead-eff29e633574
md"#### Col. 11 (object type)"

# ╔═╡ 514c8233-455e-4cbb-be92-ca4cef018d54
objectType = ["bright star", "faint star ", "elongated  ", "hot pixel  ", "extended   "]

# ╔═╡ 09c94891-f9c1-4437-811c-db553c7dd3a2
for i in eachindex(objectType)
	println("$i (", objectType[i], "): ", length(findall(x -> x == i, df.Column11)))
end

# ╔═╡ 19bc80c4-1eb5-4e59-a706-cf9343fa3ad1
md" #####  `bright_good`"

# ╔═╡ 3ecc7ee6-20c2-45fb-89c5-8ff0470dbd5c
bright_ind = findall(x -> x == 1, df.Column11)

# ╔═╡ 0f161eaf-d624-4361-b305-62ad1a9b6df6
begin
	bright16 = df[!, :Column16][bright_ind]
	bright29 = df[!, :Column29][bright_ind]
end

# ╔═╡ 371147b6-a208-433c-b178-252c56a45a4f
begin
	bright_SNR = df.Column6[bright_ind]
	bright_Crowding = df.Column10[bright_ind]
	bright_SharpSq = df.Column7[bright_ind].^2
	bright_Q200_flag = df.Column24[bright_ind]
	bright_Q444_flag = df.Column37[bright_ind]
end

# ╔═╡ 6f1080c4-1e65-4c0d-a124-09b1e3ebd1ab
nBrightest = 4

# ╔═╡ 3223682d-a23e-4f5c-b4e2-d7687b6000f2
begin
	bright_good_ind = findall(i -> bright_SNR[i] >= 4 && bright_Crowding[i] <= 2.25 && bright_SharpSq[i] <= 2.25 && bright_Q200_flag[i] <= 3 && bright_Q444_flag[i] <= 3, 1:length(bright_ind) )
	bright16_good = bright16[bright_good_ind]
	bright29_good = bright29[bright_good_ind]
	sorted16_indices = sortperm(bright16_good)
	sorted29_indices = sortperm(bright29_good)
	brightest10_16 = bright16_good[sorted16_indices][1:nBrightest]
	brightest10_29 = bright29_good[sorted29_indices][1:nBrightest]
	brightest10_16_Xvalues = df.Column3[bright_ind][bright_good_ind][findall(x -> x in brightest10_16, bright16_good)]
	brightest10_16_Yvalues = df.Column4[bright_ind][bright_good_ind][findall(x -> x in brightest10_16, bright16_good)]
	brightest10_29_Xvalues = df.Column3[bright_ind][bright_good_ind][findall(x -> x in brightest10_29, bright29_good)]
	brightest10_29_Yvalues = df.Column4[bright_ind][bright_good_ind][findall(x -> x in brightest10_29, bright29_good)]
end

# ╔═╡ 494a1901-abc2-4d4f-a342-e1f0c546cc71
bright16_good[sorted16_indices][1:nBrightest] == sort(bright16_good)[1:nBrightest]

# ╔═╡ 3ae5f772-d538-42fd-99ac-686caf6cbbc3
begin
	# Sort bright16_good and get the indices

	sorted16_bright_ind = bright_ind[bright_good_ind][sorted16_indices]

	sorted29_bright_ind = bright_ind[bright_good_ind][sorted29_indices]
	# Now sorted_bright_ind contains the indices of bright_ind corresponding to the sorted bright16_good
end

# ╔═╡ cc6a8f37-9c70-43c8-bf13-6cabe10f80e4
length(bright_good_ind)

# ╔═╡ 07c4870f-499c-49a3-9532-025ef4b2de00
typeof(bright16_good)

# ╔═╡ 101b6526-edac-4b55-b98c-df586bf643dc
Array(bright16_good)

# ╔═╡ d2b940de-2302-4560-a29d-5ddea2ac47e4
brightest10_16

# ╔═╡ 5b242578-8a2e-463b-b418-c7747d75594c
begin
	binSize = 0.5
	xT, xL, yends, yT, yL, y_fit = logXFitHisto(Array(bright16_good), binSize, true)
	plt = Plots.plot(y_fit, seriestype=:steppost)
end;

# ╔═╡ a4f55b1c-52ed-43da-a7c3-35d15259455c
extrema(Array(bright16_good))

# ╔═╡ 3ca641d7-765b-431a-a795-a3b85dd984fc
length(brightest10_16_Yvalues), typeof(brightest10_16_Yvalues)

# ╔═╡ 47f8fee2-accb-4b59-9119-627c6d5be2fa
length(findall(x-> x==99.999, bright16_good))

# ╔═╡ 3b8d6f68-8169-4a2e-b17f-e88dc28030e0
length(bright_good_ind)

# ╔═╡ b051c08f-1699-4a30-acbe-b020b80d5844
extrema(bright16)

# ╔═╡ bf232544-54bb-448b-9521-c465250fed79
l_faint = Layout(
	# width = 700, height = 607,
	# yaxis = attr(range = [28, 23], title = "16. Instr VEGAMAG, NIRCAM_F200W"),
	# xaxis = attr(range = [-8, 4], title = "16 minus 29: IRCAM_F200W - NIRCAM_F444W"),
	title = "OmCen 11740 faint, good (1555 stars)"
)

# ╔═╡ 51535fb5-a470-460a-91a0-56761884c73a
plot_data = PlotlyJS.plot(
    PlotlyJS.scatter(x=brightest10_29_Xvalues, y=brightest10_29_Yvalues, mode="markers", name="First XY"),
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
PlotlyJS.savefig(plot_data, "plot_image.png")

# ╔═╡ d7f12f2e-24a6-4fdf-969a-bffde0cd221a
plot_image = load(joinpath(projectdir("notebooks"), "plot_image.png"));

# ╔═╡ 0f7487ef-674f-46cb-8988-ffdfe03e2061
plot_image_resized = imresize(plot_image, size(imgLoad_final))
# plot_image_resized = imresize(plot_image, size(imgLoad_rotated));
# plot_image_resized = imresize(plot_image, size(imgAI_array)) NO GO AFTER ROTATION

# ╔═╡ a01c01f0-2ac8-491c-9e1a-494d06f8bf86
typeof(clamped_imgLoad)

# ╔═╡ ebc0cbf0-21d5-4c12-954b-6345adda07fd
typeof(imgLoad_final)

# ╔═╡ 63229acc-2b72-45ed-b950-388df215136c
typeof(plot_image_resized)

# ╔═╡ 3c94a86e-fb55-4875-a75d-0a31d8e604a5
size(plot_image_resized), size(imgLoad_final)

# ╔═╡ 66287ca0-bb84-4d0a-a5ac-b2b84b6067e5
overlay_img = imgLoad_final .* 0.4 .+ plot_image_resized .* 0.6
# overlay_img = clamped_retrieved .* 0.6 .+ plot_image_resized .* 0.4

# ╔═╡ e3b63ea6-7eed-4cde-928d-4ed2d7e14d60
typeof(imgLoad_final)

# ╔═╡ 36773c21-1e8c-4936-8f41-f9eef21bccdd
typeof(plot_image_resized)

# ╔═╡ 4ffe5f76-3986-4e76-a37e-9ef4ebb429fa
size(overlay_img)

# ╔═╡ 24746ec1-99fd-45b4-b588-c00e50485527
md"# DS9"

# ╔═╡ f3e96016-21d8-49fa-a10b-8af5c3e6299a
begin
	import SAOImageDS9
	const sao = SAOImageDS9
	
	# Connect to DS9
	# servers = readchomp(`xpaaccess -n ds9`)
	# if servers == "0" error("No DS9 servers found.") end
	println("Running DS9 servers: ", readchomp(`xpaget xpans`))

    try
        sao.connect()
        println("Connected to DS9 successfully.")
    catch e
        println("Failed to connect to DS9: ", e)
    end
	sao.set("file $imgFilePath") # loads the file into DS9
	sao.set("zoom to fit") # sets the zoom level to fit
	sao.set("grid yes") # turns on the grid
	sao.set("cmap color") # sets the color map to "color"
end

# ╔═╡ 43d073eb-8c37-48c3-a69c-da632ec2838d
begin
	regFile_1 = DS9_writeRegionFile(brightest10_16_Xvalues, brightest10_16_Yvalues, 25, "F200"; color = green)
	regFile_2 = DS9_writeRegionFile(brightest10_29_Xvalues, brightest10_29_Yvalues, 25, "F444"; color = red)
end

# ╔═╡ 8bb7f9c8-c356-4941-a3a8-dbf9f629498b
begin
    # Delete all regions before sending new ones
    sao.set("regions", "delete all")
    # println("All regions deleted successfully.")
	DS9_SendRegAndVerify(regFile_1)
	DS9_SendRegAndVerify(regFile_2)
end

# ╔═╡ d7b817a2-247b-4ee0-8718-4b287397e8f7
sao.set("regions", "delete all")

# ╔═╡ 2c8480c7-9c28-416e-848d-b8456c58539b
sort(bright16_good)[1:nBrightest]

# ╔═╡ 0e3ae6a4-011b-4d6f-839c-c3dd5c9c0a88
md" ### `sortperm`"

# ╔═╡ b9cd3cb5-4650-44b0-ba70-c924c2d7df7b
# begin
# 	# Sort bright16_good and get the indices
# 	sorted16_indices = sortperm(bright16_good)
# 	sorted16_bright_ind = bright_ind[bright_good_ind][sorted16_indices]
# 	sorted29_indices = sortperm(bright29_good)
# 	sorted29_bright_ind = bright_ind[bright_good_ind][sorted29_indices]
# 	# Now sorted_bright_ind contains the indices of bright_ind corresponding to the sorted bright16_good
# end

# ╔═╡ d1b9c31d-1198-4c73-8c05-d5b70540b6bb


# ╔═╡ 601e4b8d-ea9b-46cb-8438-11dec78edd89
md"""
!!! tip "Can replace sort on values."
    - `bright16_good_sorted_ind`
"""

# ╔═╡ ece6d6c7-8f8e-4c04-92b1-f0ae94d33795
bright16_good[sorted16_indices][1:4] == sort(bright16_good)[1:nBrightest]

# ╔═╡ b9f31c3b-900d-4dc3-b310-740977bea1c1
bright_ind, length(bright_ind)

# ╔═╡ 7557dcba-206d-4c80-80c6-10db579a32a2
bright_ind[bright_good_ind], length(bright_ind[bright_good_ind])

# ╔═╡ 49ebb357-ff18-4546-a423-0b3ae6536895
findmin(df.Column29), findmin(df.Column16)

# ╔═╡ ff27aab5-e924-476c-8d1a-902a88479756
bright16_good == df[!, :Column16][bright_ind][bright_good_ind]

# ╔═╡ feb0bb94-8431-4c91-9599-1e284f9bc737
findmin(bright16)

# ╔═╡ f6715f7b-8fe7-4913-93d3-afb23fa6f520
df[4136, :]

# ╔═╡ bd697c8d-a227-4eaa-8a12-8398a7c84eba
df[2142, :]

# ╔═╡ 06750c4f-703f-4b9b-8e87-60ad48e56af4
bright_ind[2401]

# ╔═╡ Cell order:
# ╟─581708d0-3df5-4160-8b3c-b3cc870efb16
# ╠═754dbb34-631a-4aea-8660-443f70f11ea9
# ╠═07dfe223-486b-4d25-9b54-243c4074f6ea
# ╠═4d9eb5bd-0759-4499-bd42-621834ae7f67
# ╟─2016b7c9-df0f-4f48-95a7-96d31ed199e4
# ╟─572dbcee-cb58-4b21-8993-5d159f02228b
# ╠═ace018d2-003c-496f-b8aa-69eb71fb9057
# ╠═dce8dbce-c8b4-11ed-3263-65232dc16f8d
# ╟─e0a42a3c-00de-4ff6-8862-46fcd0596315
# ╟─0e55ef3f-a3d3-4f3b-832a-a5d3766e7b09
# ╠═43981055-f016-46e6-a019-9ac4501db0ad
# ╟─6008384b-131c-4930-81a6-fb680420df33
# ╟─94062cd4-b278-444d-b93e-694d26d30b50
# ╟─1afaf901-30f0-4b58-98a5-a8ae88f3fccb
# ╟─f22ea8e5-e458-47bc-950a-3c8e0de06df3
# ╟─d68c548a-71a3-45e6-9ec5-a6d9358a716a
# ╠═9a46221b-68f7-4101-b30a-13cc6d87f213
# ╠═1ba5e1ac-f4b3-42cf-ae1a-c2c73c2694c0
# ╟─f97cbdb8-8721-46e5-90d4-2023d07726ac
# ╠═7ef24bfe-1fce-4ff9-8855-ea31969ecc27
# ╟─729f54ab-b4a4-40c3-8ccd-cc4e85829fb3
# ╠═cd2b0c75-c8e3-4101-936a-78ae97d72ddc
# ╠═d8cd93c0-1523-4e76-bad6-4979655b14c3
# ╠═ae5c6ccc-1902-46ce-a0fb-6a126f8b66c1
# ╠═ed6a08d6-74ed-4448-b4ac-8560df7c5a6a
# ╠═0a1d1c00-b01d-45cc-9d82-bc7dde9827b3
# ╠═113f37ab-9f05-4f80-b856-4a6beb2fe52a
# ╠═9e6de21f-3eb6-47d0-9ca7-671ecc54376e
# ╠═0febb7c0-d295-4625-99ca-83f833558540
# ╠═2a385a14-028d-4f24-a20f-47070cb5ebb4
# ╠═15653ce5-f8b6-4836-92ce-7bf74663d360
# ╠═3db9dafe-fa4a-481f-81d4-be9e142fe6e0
# ╠═1aa44815-bb46-42f4-b442-9df96cc2bc98
# ╠═6fcd8c85-75f9-4f00-ab6f-8bf2f57afa7c
# ╠═5029ac6f-3ec8-4b01-994c-3626ce018abe
# ╠═b0d3aac7-4936-4433-b11e-60586e1666bf
# ╠═08957b28-eda3-44a1-91e4-0f527a24e329
# ╠═31225053-43f7-4798-9f89-8d7cb25d16bc
# ╠═15b72413-9a93-4781-adf6-701984ed1a4b
# ╠═8c38f62d-bb8f-4896-a75b-51b10a401c4a
# ╠═3498d52a-2afc-4fba-8de1-5a944e33efff
# ╠═c47856aa-0255-408c-9ead-eff29e633574
# ╠═514c8233-455e-4cbb-be92-ca4cef018d54
# ╠═09c94891-f9c1-4437-811c-db553c7dd3a2
# ╠═19bc80c4-1eb5-4e59-a706-cf9343fa3ad1
# ╠═3ecc7ee6-20c2-45fb-89c5-8ff0470dbd5c
# ╠═0f161eaf-d624-4361-b305-62ad1a9b6df6
# ╠═371147b6-a208-433c-b178-252c56a45a4f
# ╠═6f1080c4-1e65-4c0d-a124-09b1e3ebd1ab
# ╠═3223682d-a23e-4f5c-b4e2-d7687b6000f2
# ╠═494a1901-abc2-4d4f-a342-e1f0c546cc71
# ╠═3ae5f772-d538-42fd-99ac-686caf6cbbc3
# ╠═cc6a8f37-9c70-43c8-bf13-6cabe10f80e4
# ╠═07c4870f-499c-49a3-9532-025ef4b2de00
# ╠═101b6526-edac-4b55-b98c-df586bf643dc
# ╠═d2b940de-2302-4560-a29d-5ddea2ac47e4
# ╠═21c7fe2b-631b-46aa-8e77-a2a350c825c4
# ╠═5b242578-8a2e-463b-b418-c7747d75594c
# ╠═a4f55b1c-52ed-43da-a7c3-35d15259455c
# ╠═3ca641d7-765b-431a-a795-a3b85dd984fc
# ╠═47f8fee2-accb-4b59-9119-627c6d5be2fa
# ╠═3b8d6f68-8169-4a2e-b17f-e88dc28030e0
# ╠═b051c08f-1699-4a30-acbe-b020b80d5844
# ╠═bf232544-54bb-448b-9521-c465250fed79
# ╠═51535fb5-a470-460a-91a0-56761884c73a
# ╠═71f2a83c-b130-4a6c-a2b4-8abe62f1745c
# ╠═d7f12f2e-24a6-4fdf-969a-bffde0cd221a
# ╠═0f7487ef-674f-46cb-8988-ffdfe03e2061
# ╠═a01c01f0-2ac8-491c-9e1a-494d06f8bf86
# ╠═ebc0cbf0-21d5-4c12-954b-6345adda07fd
# ╠═63229acc-2b72-45ed-b950-388df215136c
# ╠═3c94a86e-fb55-4875-a75d-0a31d8e604a5
# ╠═66287ca0-bb84-4d0a-a5ac-b2b84b6067e5
# ╠═e3b63ea6-7eed-4cde-928d-4ed2d7e14d60
# ╠═36773c21-1e8c-4936-8f41-f9eef21bccdd
# ╠═4ffe5f76-3986-4e76-a37e-9ef4ebb429fa
# ╠═24746ec1-99fd-45b4-b588-c00e50485527
# ╠═f3e96016-21d8-49fa-a10b-8af5c3e6299a
# ╠═326975a2-b8b6-4b72-a467-d33a7f959370
# ╠═43d073eb-8c37-48c3-a69c-da632ec2838d
# ╠═8bb7f9c8-c356-4941-a3a8-dbf9f629498b
# ╠═d7b817a2-247b-4ee0-8718-4b287397e8f7
# ╠═2c8480c7-9c28-416e-848d-b8456c58539b
# ╠═0e3ae6a4-011b-4d6f-839c-c3dd5c9c0a88
# ╠═b9cd3cb5-4650-44b0-ba70-c924c2d7df7b
# ╠═d1b9c31d-1198-4c73-8c05-d5b70540b6bb
# ╠═601e4b8d-ea9b-46cb-8438-11dec78edd89
# ╠═ece6d6c7-8f8e-4c04-92b1-f0ae94d33795
# ╠═b9f31c3b-900d-4dc3-b310-740977bea1c1
# ╠═7557dcba-206d-4c80-80c6-10db579a32a2
# ╠═49ebb357-ff18-4546-a423-0b3ae6536895
# ╠═ff27aab5-e924-476c-8d1a-902a88479756
# ╠═feb0bb94-8431-4c91-9599-1e284f9bc737
# ╠═f6715f7b-8fe7-4913-93d3-afb23fa6f520
# ╠═bd697c8d-a227-4eaa-8a12-8398a7c84eba
# ╠═06750c4f-703f-4b9b-8e87-60ad48e56af4
