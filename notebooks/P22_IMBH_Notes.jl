### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
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
	using HypertextLiteral
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

# ╔═╡ 87fd42a3-0a6c-41ae-a040-503403eabe07
@bind cellWidth Slider(500:25:1100, show_value=true, default=775)

# ╔═╡ db3e8f5a-88a7-494a-9d50-640d91aac997
begin
	@bind screenWidth @htl("""
<div>
    <script>
        var div = currentScript.parentElement
        div.value = screen.width
    </script>
</div>
""")
    # cellWidth = min(1000, screenWidth * 0.50)
    @htl("""
    <style>
    pluto-notebook {
		margin-left: 10px;
        # margin: auto;
        width: $(cellWidth)px;
    }
    </style>
	Widening cell.
    """)
end

# ╔═╡ 9a46221b-68f7-4101-b30a-13cc6d87f213
md" ###### Begin New Coding Here."

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

      -- Set `df_rowAtoB = 3` and `df_rowAtoB = 4`. Two lines that can show the information for the problem to be solved are:
         - for i in eachindex(df[df\_rowAtoB, "Catalog A labels"])  println("$i) ", df[df\_rowAtoB, "Catalog A labels"][i, 1], " ", df[df\_rowAtoB, "Catalog B matching labels"][i, 1:NN\_level]) end

        - for i in eachindex(df[df\_rowBtoA, "Catalog A labels"])  println("$i) ", df[df\_rowBtoA, "Catalog A labels"][i, 1], " ", df[df\_rowBtoA, "Catalog B matching labels"][i, 1:NN\_level]) end

      -- And, BTW, `/home/dfc123/Gitted/OlegIMBH/src/GalCen/buildDuplicateDict.jl` has an uncommented comment line that prevents it from running.

#### DOLPHOT
!!! note ""
    - Yesterday, Oleg and I looked at Jeremy's [DOLPHOT](http://americano.dolphinsim.com/dolphot/) (manual [here](http://americano.dolphinsim.com/dolphot/dolphot.pdf); [JWST specifics when running](https://dolphot-jwst.readthedocs.io/en/latest/search.html?q=FITS&check_keywords=yes&area=default)) production of Omega Cen data.  Previous data and code moved into:
    `MAST` directory created in `OlegIMBH/data/exp_raw` and `MASTr`s in `scripts` and `src` directories.
!!! warning "Where (and how) to back up the original data, i.e., those stored in \data\exp_raw?"
!!! tip ""
    - Google Drive: G:\My Drive\Articles\Astrophysics\_New\IMBH\_Data_Backup

"""

# ╔═╡ 1ad03ec0-6451-49ca-a8ec-f5fcf7cdd725
md"""
### Plotly & Quality Progress (18 October)
#### Plotly
!!! tip "P22a_OmegaCen"
	- Keys to reading the file with CSV: `... header=false, delim=" ", ignorerepeated = true, select = columnsToRead`
	- Works with both static and interactive Plotly plots that can be saved.
	  - at about 220,000 points, attempt at interactive freezes Pluto completely.
	  - in Plotly, just reverse limits to reverse axis (or set `autorange = "reversed"`
	  - [image layout options] (https://plotly.com/julia/reference/layout/images/#layout-images-items-image-name)
      - [zoom on static images](https://plotly.com/julia/images/#zoom-on-static-images)
	  - [setting graph size](https://plotly.com/julia/setting-graph-size/)
      - [scatter traces](https://plotly.com/julia/reference/scatter/#scatter)
	  - [adding a background image completely inside Plotly](https://plotly.com/julia/reference/scatter/#scatter)
	- Can vary number of randomized points to view.
	- Can also vary opacity.
	- To save plot, have to use `PlotlyJS`, but using `PlutoPlotyly`, too, so have to call functions explicitly.
	- `config` options; only change from default is `staticPlot` is true via `pp_configStatic = PlutoPlotly.PlotConfig(staticPlot = true)`:
      - [detailed config descriptons](https://plotly.com/julia/configuration-options/)
			PlotConfig
			  scrollZoom: Bool true
			  editable: Bool false
			  staticPlot: Bool true
			  toImageButtonOptions: Nothing nothing
			  displayModeBar: Nothing nothing
			  modeBarButtonsToRemove: Nothing nothing
			  modeBarButtonsToAdd: Nothing nothing
			  modeBarButtons: Nothing nothing
			  showLink: Bool false
			  plotlyServerURL: Nothing nothing
			  linkText: Nothing nothing
			  showEditInChartStudio: Nothing nothing
			  locale: Nothing nothing
			  displaylogo: Nothing nothing
			  responsive: Bool true
			  doubleClickDelay: Nothing nothing
#### Quality
!!! tip ""
	- Confirmed that all 750K xy coordinates are unique.
    - Looks at Column11, "object type," to produce the table of total counts, below.

| Count | Col 11 value | Description|
|----------:|:---------:|:---------|
| 733,991 | 1 | bright star |
| 11,740  | 2 | faint star  |
| 0       | 3 | elongated   |
| 3,382   | 4 | hot pixel   |
| 0       | 5 | extended    |
!!! note "Catalog Characteristics"
	- [AB vs Vega Magnitudes](https://jwst-docs.stsci.edu/jwst-near-infrared-camera/nircam-performance/nircam-absolute-flux-calibration-and-zeropoints#gsc.tab=0)
	- Reduced the number of "good" "faint star" ojects at wavelengths 200 and 444 to 1555 by using flags and the following ["Culling"](https://dolphot-jwst.readthedocs.io/en/latest/post-processing/catalogs.html#culling-the-catalog) critera on signal-to-noise, sharpness (squared) and crowding: 
	  - SNR >=4
	  - Sharp^2 <= 0.1
	  - Crowding <= 2.25
	  - Flag <= 3
	  - Type <= 2
"""

# ╔═╡ 4d9abf6c-4385-41c5-9361-463d5549ac44
md"""
### A step sideways, then forward (21 October)
#### `P23_IMBH_Histo`
!!! note "Plotted distances of nearest neighbors, confirming the function was working correctly."
#### `P24_ViewOmCen`
!!! danger "corrections needed ("load" was "capped")"
!!! note "To get a handle on plotting points on an image."
    - Because of rotation (why? see below), `using ImageTransformations` and `OffsetArrays` as well as the usual image packages: `Astroimages`.  Only need `FITSIO` if want to see all the information inside the fits file (which you may).
	- After executing full Plotly "Logo" example (link above), spent time messing with my fits image, but didn't get it work and decided to try another tack of simply overlaying files."
!!! tip "Using `AstroImages.load(file)` rather than `AstroImages.AstroImage(file)` allows simple addition of one file to another."
	- Assume that the image loaded with `AstroImage` has the correct orientation, and rotate the image loaded with `load` to match it.  The rotation causes type-matching problems that require a couple of functions to correct so that the "overlay" addition can succeed.
	- `load` here gave a black and white image because it had been clamped!: `typeof(imgLoad)`: Matrix{Gray{N0f8}} (alias for Array{Gray{Normed{UInt8, 8}}, 2}), whereas `typeof(imgAI)` yields over 20 lines in the type definition, mostly DimensionalData.Dimensions.Lookups folowed by .ForwardOrdered or .Regular{Int64}, or .NoMetadata.
!!! tip ""
    - but after being rotated via `ImageTransformations.imrotate`, the new type is OffsetMatrix{Gray{N0f8}, Matrix{Gray{N0f8}}} (alias for OffsetArray{Gray{Normed{UInt8, 8}}, 2, Array{Gray{Normed{UInt8, 8}}, 2}}).
	  - the offset has to be removed: `imgLoad_rotated_noOffset = OffsetArrays.no_offset_view(imgLoad_rotated)`, and to add it to a (resized) plot image, the image has to be made into a regular array:  `imgLoad_final = Array(imgLoad_rotated_noOffset)`.
	  - can finally add the two together: `overlay_img = imgLoad_final .* 0.7 .+ plot_image_resized .* 0.3`
!!! note ""
	- Next step is to plot the four (?) brightest to see if the -90 degree rotation is indeed correct.
"""

# ╔═╡ ad919d5a-e732-4a87-80a8-4e7023558a45
md"""
!!! warning ""
	The change in type of clamped_imgLoad to Matrix{Gray{N0f8}} after saving and re-loading is due to the way image data is handled by the save and load functions in the AstroImages package. Here's a step-by-step explanation:
	
	Initial Type: When clamped_imgLoad is created using map(clamp01nan, imgLoad), it retains the type of the original imgLoad array, but with values clamped to the [0, 1] range.
	
	Saving the Image: The save function converts the in-memory image data to a format suitable for storage in a PNG file. This process typically involves converting the image data to a standard format, such as an array of Gray{N0f8} values, where N0f8 represents an 8-bit normalized floating-point number (i.e., values between 0 and 1 stored as 8-bit integers).
	
	Loading the Image: When the image is loaded back using AstroImages.load, the data is read from the PNG file and converted back into a Julia array. The AstroImages package interprets the PNG data as a Matrix{Gray{N0f8}}, which is a common representation for grayscale images.
	
	Summary
	The type change occurs because the save function converts the image data to a standard format for storage, and the load function reads this format back into a Julia array. The Matrix{Gray{N0f8}} type is a standard representation for grayscale images in the AstroImages package.
"""

# ╔═╡ 8e6c876b-5a59-43e8-9661-c16c467b834e
md"""
### DS9 (23 October)
!!! note ""
    [(Julia) Linux installation instructions here.](https://juliaastro.org/SAOImageDS9.jl/stable/install/)
	- [SAO Documentation here.](https://sites.google.com/cfa.harvard.edu/saoimageds9/documentation?authuser=0)
	- [JWST Near Infrared Camera](https://jwst-docs.stsci.edu/jwst-near-infrared-camera#gsc.tab=0)
	  - [NIRCAM Filters] (https://jwst-docs.stsci.edu/jwst-near-infrared-camera/nircam-instrumentation/nircam-filters#gsc.tab=0) 
	  - central wavelength in tens of nanometers!
	  - "Hold down the right mouse button and drag the mouse up or down to adjust the contrast."
	- [SAO "Regions" here.](https://ds9.si.edu/doc/ref/region.html)
!!! tip ""
	- ds9 & # in bash
      - might have also needed `sudo apt-get install saods9 libxpa-dev`
	  - `xpaget xpans` # shows all ds9s that are running
	  - `pgrep -f ds9`, `pkill -f ds9` # "p" is for process & "-f" is for "full" (which is needed)
	- first program: /home/dfc123/Gitted/OlegIMBH/scripts/DS9_RegionTest.jl
	  - can override `global` colors with local ones, e.g.,

\# global color=red  # green is default\
circle 1004 175.8280288184799 10 # x y radius\
circle 1005 976.4864929248429 10 # x y radius\
circle 1006 232.47290954159294 10 # color = red\
circle 1007 734.6312878220773 10 # x y radius\
circle 1008 370.2739336160197 10 # x y radius\
"""

# ╔═╡ a8c24b20-da05-404f-8ac6-47086782d604
md"""
### Getting original indices (24 October)
!!! tip "code toward the end of (messy) P24a_Brightest" 
    - don't have to sort separately
- begin\
  "#" Sort `bright16_good` and get the indices\
  `bright16_good_sorted_ind = sortperm(bright16_good)`\
  `sorted_bright16_ind` = `bright_ind[bright_good_ind][bright16_good_sorted_ind]`\
  "#" Now `sorted_bright16_ind` contains the indices of` bright_ind` corresponding to the sorted `bright16_good` indices.
- end
"""

# ╔═╡ f654239b-14d5-4eec-bf65-0d237ff32746
md"""
### NIRCam Image pixel size (25 October)
!!! note "From the header of the fits file jw04343-o002_t001_nircam_clear-f200w_i2d.fits "
	"PIXAR_A2= 0.000945196963760956 / Nominal pixel area in arcsec^2"
	  - which corresponds to 0.030744055746777393 = 0.031 arcseconds per pixel (32.5 pixels per arcsecond)
	  - which is consistent with [Table 1](https://jwst-docs.stsci.edu/jwst-near-infrared-camera#gsc.tab=0)
	  - which corresponds to an image size of about 2.34 minutess of arc on a side
        - (doesn't look exactly square, but close enough)
"""

# ╔═╡ 5a22ed1e-a50f-40c6-857a-d85675385890
md"""
###### here at one # to have print on new page; dfc 31 October 2024
### Current Confusion (29--30 October; report to Oleg)
#### 3 November: some original images replaced by more "stringent" criteria
!!! note "Part 1: Data and Culling"
    The relevant columns of the output file `omega_cen_phot`:
	1) Column 3: Object X position
	1) Column 4: Object Y position
	1) Column 6: Signal-to-noise
	1) Column 7: Object sharpness
	1) Column 10: Crowding
	1) Column 11: Object type (1=bright star, 2=faint, 3=elongated, 4=hot pixel, 5=extended)
	1) Column 16: Instrumental VEGAMAG magnitude, NIRCAM_F200W
	1) Column 29:  Instrumental VEGAMAG magnitude, NIRCAM_F444W
	1) Column 24: Photometry quality flag, NIRCAM_F200W
	1) Column 37: Photometry quality flag, NIRCAM_F444W

	[Culling](https://dolphot-jwst.readthedocs.io/en/latest/post-processing/catalogs.html) to yield "A loose, completeness-oriented, selection to reject obvious outliers but preserve as many stars as possible can be done using the following parameters:"
!!! warning "  delineate use below"
| Criterion | "gross" limit | "stringent" limit|
|:----------:|:---------:|:---------:|
|SNR   |     >=4|        >= 5|
|Sharp^2 |<= 0.1  |       <= 0.01|
|Crowding| <= 2.25 |     <= 0.5|
|Flag| <= 3  |            <= 3|
|Type| <= 2 |            <= 2|

Julia code: `bright\_good\_ind = findall(i -> bright\_SNR[i] >= 4 && bright\_Crowding[i] <= 2.25 && bright\_SharpSq[i] <= 2.25 && bright_Q200_flag[i] <= 3 && bright\_Q444\_flag[i] <= 3, 1:length(bright\_ind) )`

!!! note "Part 2: "bright" stars"
    When the brightest (object type 1) 31 stars at F200 (green circles) and at F440 (red circles) are place on the image (below), a strange picture results.  All the red circles are on the left side and all but four of the green circles are on the right side.  When the number of stars is increased to 32, a red circle appears on the right-hand side (not shown).
"""

# ╔═╡ 9e98f8f0-69dd-4eb5-a11e-c0f6564ec31e
begin
	imageFolder = "/home/dfc123/Gitted/OlegIMBH/data/sims/"
	imageName = "bright_31_sorted_inc99_stringent_NIRCAM.png"
	imagePath = joinpath(imageFolder, imageName)
	LocalResource(imagePath)
end

# ╔═╡ 6cdb1f4a-b5c4-4fd5-be8c-88dcbd755d57
md"""
!!! note ""
	Some of these culled, "good" stars, however, show a 99.999 value in the magnitude column in one of the wavelengths, i.e., in the one that does not appear on the image.  What does that number mean?  The only description I found lies in the DOLPHOT JWST section on "Artificial Star Tests," which states ([here](https://dolphot-jwst.readthedocs.io/en/latest/asts/output.html)) "Stars which are not detected in the output photometry will have magnitude measurements of 99.999."  Presumably it carries the same meaning here, that the star has not been detected at one wavelength.  (Or did test stars somehow migrate into our image?)

	What happens if we remove these stars from the already-culled selection? (For one thing, the number classified as "good" drops from about 580,000 to about 430,000.) First, in the image below (contrast increased to let the circles show more easily), about half the stars are now common to both wavelengths, having both red and green circles (which at a quick glance by non-color-blind eyes will look yellow). Second, although the green ones still tend more toward the right-hand side, the reds are distributed across the image.

Julia code: `bright\_good\_ind = filter(i -> bright16[i] != 99.999 && bright29[i] != 99.999, 1:length(bright\_good\_ind))`
"""

# ╔═╡ 7aca6436-c98c-4212-b6ee-77c6235ff110
let
	imageFolder = "/home/dfc123/Gitted/OlegIMBH/data/sims/"
	imageName = "bright_31_sorted_no99_gross_NIRCAM.png"
	imagePath = joinpath(imageFolder, imageName)
	LocalResource(imagePath)
end

# ╔═╡ 35bdb6da-6ca6-43cd-b1be-dd9fdacf1ee6
md"""
!!! note ""
	What if instead of sorting by magnitude, we take 31 randomly? The following image shows what we (mostly) expected at the start, a random distribution of stars with maybe a slight concentration again to the right that vanishes with a larger number of stars (not shown).
"""

# ╔═╡ e831f3ec-2a23-44b3-a5cc-c036aac608a7
let
	imageFolder = "/home/dfc123/Gitted/OlegIMBH/data/sims/"
	imageName = "bright_31_random_no99_gross_NIRCAM.png"
	imagePath = joinpath(imageFolder, imageName)
	LocalResource(imagePath)
end

# ╔═╡ 0dc469c0-466d-49f7-81dd-56df3af96943
md"""
!!! note ""
	If we return to the stars sorted by magnitude and triple the number to 123, below we see a distribution more random than the previously sorted one (though still perhaps with a slight concentraion toward the right-hand side).
"""

# ╔═╡ b0062abc-a10a-4f55-b0b6-a12554a38bdf
let
	imageFolder = "/home/dfc123/Gitted/OlegIMBH/data/sims/"
	imageName = "bright_123_random_no99_gross_NIRCAM.png"
	imagePath = joinpath(imageFolder, imageName)
	LocalResource(imagePath)
end

# ╔═╡ ec7e248f-2173-43cb-abb4-50427fdf675e
md"""
!!! note "Part 3: "faint"."
	Before the removal of the 99.999s, only about 1500 objects clasified as "faint" remain --- the classification written above, "faint" is the correct one, not the "faint star" that the (two) images shown --- and after the removal of the 99.999s, only 147 of those are left, so to encounter another mystery, let us plot all of them, below.  If selected randomly, we would see a mix of red, green, and yellow because some are selected more than once, but reassuringly, all 147 of the sorted ones overlap.

	The distribtion of the objects in the image, however, does not reassure us.  One can imagine, I suppose, that "faint" objects avoid the middle of the image and possibly would extend out in some roughly circular manner, but how can they concentrate toward the edges of a square image?
"""

# ╔═╡ 47da4df4-f263-498c-bcf3-3a07fba8d723
let
	imageFolder = "/home/dfc123/Gitted/OlegIMBH/data/sims/"
	imageName = "faint_57_sorted_no99_gross.png"
	imagePath = joinpath(imageFolder, imageName)
	LocalResource(imagePath)
end

# ╔═╡ e9f4e8b9-6388-454f-9808-7abba0f1dcc1
md"""
!!! note "Part 4: Questions"
	1) Does the "99.999" mean anything more than "not detected"? If that's all it means, how can one explain why the brightest stars observed at one wavelength and not observed at the other fall on one side of the image?
	    - Is there any possibility that test stars leaked into the image? (It would be nice to find another reference to a magnitude of 99.999 outside of the documentation's test-star section.)
	1) What exactly are the criteria applied for the "bright star" and "faint" object types?
	1) A possible next step: try more stringent culling parameters (that are mentioned in the documentation) and see if the original segmentation vanishes. Even if it does, however, we would still be left with explaining that original segmentation.
	1) Faint stars at the edges?!
	1) How much confidence do we have that the objects plotted are members of the cluster and not foreground or background objects? Could some be galaxies?
	    - Even so, we would not expect the kind of spatial segregation that we see.
	1) And a bonus: how many programming errors have I made?  If you have any ideas on how to check the consistency of these results, please let me know.
"""

# ╔═╡ b016d6af-ae80-4b69-8378-b3155e3051c0
md"""
### "Stringent" Criteria (3 Nov 2024)
!!! warning "From paper [], more stringent criteria implemented, some used above in images.  Need to read paper and modify these notes slightly."
"""

# ╔═╡ ac029dc2-9601-4f7d-964f-3139ebf56214
md"""
### M92 (4 November)
!!! note ""
[WST Resolved Stellar Populations Early Release Science](https://archive.stsci.edu/hlsp/jwststars)
"""

# ╔═╡ a54f0123-9a04-495e-bd00-0b50dd721ea6
md"""
### 5 November 2024
!!! note "Artifical Star Tests; see LiquidText, Intermediate_Black_Holes, Weisz_2024_ApJS_271_47; verbatim excerpts below:"
	- Characterizing uncertainties for crowded-field stellar photometry requires artificial star tests (ASTs). ASTs are synthetic  stars with known positions and magnitudes that are inserted  into real JWST science images and then recovered by  DOLPHOT.
	- 3.7. Artificial Star Tests.  While DOLPHOT provides an estimate of photometric  uncertainties based on the goodness of fit and the noise  characteristics of the data, a much better characterization of the  photometric measurement uncertainties and selection function  is accomplished through ASTs. This long-established approach  (e.g., Stetson 1987; Stetson & Harris 1988) represents the “gold standard” in the field of resolved stellar population photometry.  It relies on the injection of mock stellar sources into the raw  images, which are then recovered using the identical photometric procedure used to construct the raw and stellar  DOLPHOT catalogs.
	- The first step in running ASTs is to create a suitable input  star catalog. For each target and camera, we created a list of  $\lesssim 4 \times 10^5$ mock stars (see Table 4), with positions drawn from  uniform spatial distributions on the NIRCam/NIRISS footprints, aside from gaps between the chips and modules.
	- The artificial stars are then injected into all science (i.e., cal) images ...
!!! note "6418 Have 99.999 in both Col 16 & 19"
	- indices = findall(row -> row.Column16 == 99.999 && row.Column29 == 99.999, eachrow(df))
	  - 6418-element Vector{Int64}
	- looking at the last one (row 748335), for both F200W and F200W separately, individual Total counts, Normalized count rate, Signal-to-noise, and Sharpness are negative, and the Photometry quality flag equals 0 --- but the overall Signal-to-Noise (Column 6) is 14.5 and while the overal Object Sharpness (Column 7) is negative, the Sharpness of F44W (Column 34) is 0.245.

!!! note "Chip coordinates"
	[McMaster ref](https://physics.mcmaster.ca/~harris/dolphot_primer.txt): NOTE: as said above, for the reference image there is no 'chip 2'.
    It's already been combined into a single image.  Each chip has an internal (x,y) coordinate system where x runs from 1--> 4096 and y runs from 1--> 2048. But the reference image is (4096x4096), more or less.  Thus when DOLPHOT converts the coordinates of each star into the reference-image scale, the y-values for chip 2 are increased by approximately 2048  to put them onto the reference image scale.  That is, in the final output photometry files, 
    
    ** the (x,y) values for all the chip2 data are properly shifted to the reference image system! **
"""

# ╔═╡ 4ac99015-fa97-4905-9abf-f680a5231c5e
md"""
### 20 November 2024
!!! note "Translating and Matching Coordinates"
	- From the `AstroImages` package, used `pix_to_world` in `/home/dfc123/Gitted/OlegIMBH/scripts/translateCoords.jl` to build two NIRCAM and MIRI `DataFrame` jld2 files that contain RA and Dec coordinates corresponding to the x and y positions.
	- the result of `SortMerge` is of type `SortMerged.Matched`, which contains
      - orig_sizes :: Vector{Int64}
      - matched    :: Vector{Vector{Int64}}
      - cmatch     :: Vector{SparseArrays.SparseVector{Int64, Int64}}
      - minmult    :: Vector{Int64}
      - maxmult    :: Vector{Int64}
      - nunique    :: Vector{Int64}
"""

# ╔═╡ ee6cf51b-c90e-486e-8234-b794838c75c0
md"""
### 21-22 November 2024
!!! note "Looks Like Its Working"
	- First, NIRCAM image 30 brightest 444 versus 30 brightest 200 shows (DS9) no overlap.
	  - Coordinate comparison consistent, i.e., shows zero in common at 76, one in common at 31.
	  - Need to use 77 (which, by the way, shows 78 for each) to find the first common coordinate. 
!!! note ""
	Side note: in `matchCoords`, NIRCAM with an input of the 31 brightest stars shows 31 sets of coordinates where a match was attempted, but when 32 are input, it shows 33 to match.
	- `brightestN_16` lists the 32 brightest magnitudes with 5 significant figures; `bright16_good` has the same number of elements at `bright_good_ind`, which in this case is 108,588.  When I ask which of the `brightestN_16` are found in the `bright16_good`, I get 33 because the 32 brightest would yield 43 matches, 17 of which are duplicates, but 33 survive.  I `unique`ed out the duplicates in `bright16_good`, but at 33 I still, of course, pick up a duplicate.  I get the first match with 77 brightest using 0.018 arcseconds as the threshold.
	  - `brightestN_16_Xvalues = df[!, :ra]][bright_good_ind][findall(x -> x in brightestN_16, bright16_good)`]

"""

# ╔═╡ d25077c7-78b2-4b72-bd18-6392857091f7
md"""
### 2 December 2024
!!! note "`matchCoords2` matches NIRCAM to MIRI (but is more flexible than that)"
	- Understanding `sortmerge` results: see [`sortmerge`](https://github.com/gcalderone/SortMerge.jl?tab=readme-ov-file)
	- Depending on the "threshold" number (`const THRESHOLD_ARCSEC`), when all NIRCam coordinates are examined, a given MIRI coordinate can match to one or more NIRCam coordinates, and the resulting `j`s work as follows:
	  - `j[1]` gives the indices of the "A" (i.e., the first, here MIRI) set of coordinates that have been matched. The number of indices, i.e., `length(j[1])` will match the "Output" number of matches, so if more than one NIRCam coordinate has been matched to a given MIRI coordinate, the length will be greater than the input number of MIRI objects. 
	  - `j[2]` gives the indices of the matching NIRCam coordinates, which so far appear to be unique, i.e., although multiple NIRCams match to a given MIRI, no two NIRCams match to different MIRIs (so far).
"""

# ╔═╡ Cell order:
# ╟─581708d0-3df5-4160-8b3c-b3cc870efb16
# ╟─754dbb34-631a-4aea-8660-443f70f11ea9
# ╟─e85f9903-c869-416a-bf86-cb85a80b065b
# ╠═4d9eb5bd-0759-4499-bd42-621834ae7f67
# ╟─2016b7c9-df0f-4f48-95a7-96d31ed199e4
# ╟─572dbcee-cb58-4b21-8993-5d159f02228b
# ╟─ace018d2-003c-496f-b8aa-69eb71fb9057
# ╟─dce8dbce-c8b4-11ed-3263-65232dc16f8d
# ╟─e0a42a3c-00de-4ff6-8862-46fcd0596315
# ╟─0e55ef3f-a3d3-4f3b-832a-a5d3766e7b09
# ╟─db3e8f5a-88a7-494a-9d50-640d91aac997
# ╟─6008384b-131c-4930-81a6-fb680420df33
# ╟─94062cd4-b278-444d-b93e-694d26d30b50
# ╟─1afaf901-30f0-4b58-98a5-a8ae88f3fccb
# ╟─f22ea8e5-e458-47bc-950a-3c8e0de06df3
# ╟─d68c548a-71a3-45e6-9ec5-a6d9358a716a
# ╠═87fd42a3-0a6c-41ae-a040-503403eabe07
# ╠═9a46221b-68f7-4101-b30a-13cc6d87f213
# ╟─15899cbb-53e1-4160-b24c-40fa959aa926
# ╟─c3b4a98c-4025-43bf-96dc-2b3c9b376c59
# ╟─1ad03ec0-6451-49ca-a8ec-f5fcf7cdd725
# ╟─4d9abf6c-4385-41c5-9361-463d5549ac44
# ╟─ad919d5a-e732-4a87-80a8-4e7023558a45
# ╠═8e6c876b-5a59-43e8-9661-c16c467b834e
# ╟─a8c24b20-da05-404f-8ac6-47086782d604
# ╟─f654239b-14d5-4eec-bf65-0d237ff32746
# ╠═5a22ed1e-a50f-40c6-857a-d85675385890
# ╟─9e98f8f0-69dd-4eb5-a11e-c0f6564ec31e
# ╟─6cdb1f4a-b5c4-4fd5-be8c-88dcbd755d57
# ╟─7aca6436-c98c-4212-b6ee-77c6235ff110
# ╟─35bdb6da-6ca6-43cd-b1be-dd9fdacf1ee6
# ╟─e831f3ec-2a23-44b3-a5cc-c036aac608a7
# ╟─0dc469c0-466d-49f7-81dd-56df3af96943
# ╟─b0062abc-a10a-4f55-b0b6-a12554a38bdf
# ╟─ec7e248f-2173-43cb-abb4-50427fdf675e
# ╟─47da4df4-f263-498c-bcf3-3a07fba8d723
# ╟─e9f4e8b9-6388-454f-9808-7abba0f1dcc1
# ╠═b016d6af-ae80-4b69-8378-b3155e3051c0
# ╟─ac029dc2-9601-4f7d-964f-3139ebf56214
# ╠═a54f0123-9a04-495e-bd00-0b50dd721ea6
# ╠═4ac99015-fa97-4905-9abf-f680a5231c5e
# ╟─ee6cf51b-c90e-486e-8234-b794838c75c0
# ╠═d25077c7-78b2-4b72-bd18-6392857091f7
