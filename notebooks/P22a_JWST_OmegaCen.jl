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

# ╔═╡ 82aa8219-8d97-4103-970d-6a89ada5e9f4
begin
	cd(joinpath(homedir(), "Gitted/OlegIMBH"))
	using DrWatson
end

# ╔═╡ 6cc5f5c4-0153-4903-ac7a-31f6fe7c19a6
begin
	@quickactivate # 'cause we're in the same-named directory (as the project)
	
	using Base.Threads
	using Revise
	using PlutoPlotly
	using CSV, DataFrames
	# using NearestNeighbors
	# using AstroImages, FITSIO
	# using Cosmology, Unitful, UnitfulAstro, Measurements 
	# using Suppressor
	# include(srcdir("commas.jl"))
	
	println(
	"""
	Currently active project is: $(projectname())
	Path of active project: $(projectdir())
	"""
	)
end

# ╔═╡ baec53cc-f36a-4dce-84d4-f41dc6d919df
begin
	using PlutoUI
	TableOfContents(title = "P23_JWST_OmegaCen", depth = 6)
end

# ╔═╡ 7b98ed8c-7a38-463d-91e9-9915901a0047
md"""
dfc 16 October: P22a_JWST_OmegaCen.jl
!!! note "one file: "OlegIMBH/data/exp_raw/OmegaCen/omega\_cen\_phot"
	- with "OlegIMBH/data/exp\_raw/OmegaCen/omega\_cen\_phot.columns"
"""

# ╔═╡ 4bbf22dd-2776-4e17-9abb-960b19add303
html"""
<style>
	@media screen {
	main {
		margin: 0 auto;
		max-width: 2000px;
    	padding-left: min(50px, 10%);
    	# padding-right: max(160px, 10%);
    	padding-right: max(160px, 10%); 
        # 383px to accomodate TableOfContents(aside=true)
        # 313px on vertical display
		# 160px on vertical display overlaps but gives sufficient space
	}
}
</style>
Widens screen cell width proportionally to window width.
"""

# ╔═╡ 37681186-6c21-4e86-8ad2-f199c2cdefe4
md" # Top Cell"

# ╔═╡ 5ad9dee6-6281-4b84-9f80-92da1a4e16a7
begin
	md"### Reading `omega_cen_phot` "
	columnsToRead = 1:29 # nothing # 16:29
	df = CSV.read("./data/exp_raw/OmegaCen/omega_cen_phot", DataFrame; header=false, delim=" ", ignorerepeated = true, select = columnsToRead)
end

# ╔═╡ a269c4b8-aa06-4ac1-8cfe-b1d4fd3d89cd
size(df)

# ╔═╡ 22738cd1-e9ef-4972-961f-fd7b9d54c05b
typeof((df[1:100, 3], df[1:100, 3]))

# ╔═╡ d7732a1b-786f-48d0-a230-d55d617ac0cc
someRows = 170_000:170_010

# ╔═╡ f4b50de1-ec00-4285-acac-70dfe31e3de6
df[someRows, 1:14] == df[someRows, Between(:Column16, "Column29")]

# ╔═╡ d7e61019-4b19-4de2-b925-da149b992372
names(df)

# ╔═╡ 739b8dfa-6721-42a7-ae2b-bcbb9b04d296
df[someRows, [:Column16, :Column29]]

# ╔═╡ 33f5c361-cd0d-4ac3-b1fa-8b4320f2bbc1
extrema(df[:, :Column16]), extrema(df[:, :Column29]), extrema(df[:, :Column16] .- df[:, :Column29])
# extrema(skipmissing(df[:, :Column16])), extrema(skipmissing(df[:, :Column29])), extrema(skipmissing(df[:, :Column16] .- df[:, :Column29]))

# ╔═╡ db6d3a85-df3e-4469-b781-3f73a194b49d
names(df)

# ╔═╡ 69ba9361-28c4-4c18-b0c8-2a8da43e4376
begin
	len_df = size(df)[1]
	xyPairs = [ (df[i, :Column3], df[i, :Column4]) for i in 1:len_df]
	println(length(unique(xyPairs)) == len_df, " @ $len_df pairs")
	md" ### All xyPairs Unique"
end

# ╔═╡ 88253dc5-b8e8-4b38-82c8-ed0b6fb3268e
md"Select number of indices $(@bind indNumber confirm(Slider(9_113:10_000:749_113, default = 9_113, show_value = true)))"

# ╔═╡ 56f13fa5-3806-461b-ab31-64d68eaf3928
begin
	# indNumber = missing # 100_000 # missing
	x_reduced = df[!, :Column16] .- df[!, :Column29]
	y_reduced = df[!, :Column16]
	# if !ismissing(indNumber)
	if indNumber != 749_113
	    indices = rand(1:length(df[:, :Column16]), indNumber)
		x_reduced = x_reduced[indices]
		y_reduced = y_reduced[indices]
	end
	md" #### Reducing indices"
end

# ╔═╡ 506c52d5-30a0-4d7c-8550-4cd9259730d0
plot(scatter(df, x =  df.Column29, y = df.Column16, mode = "markers")) # , yflip = true, xlabel = "16 minus 29: IRCAM_F200W - NIRCAM_F444W",  title = "Omega Centauri", ylabel = "16. Instr VEGAMAG, NIRCAM_F200W", label = "", xlims = [-15, 15], ylims = [14, 40], markersize = 2.5, markercolor = :white))

# ╔═╡ 4d56a2a4-d011-4199-9d68-47b6df09a928
# Function to display specific lines of a file
function print_textFile_lines(file_path, line_numbers)
    # Read the file content
    file_content = read(file_path, String)
    # Split the content into lines
    lines = split(file_content, '\n')
	# Print the total number of lines in the read file
	println("$file_path contains $(length(lines)) columns\n")
    # Extract the specific lines
    selected_lines = lines[line_numbers]
    # Join the selected lines into a single string
    selected_content = join(selected_lines, '\n')
    # Display the selected content
    println(selected_content)
end

# ╔═╡ 45693af8-294a-429a-a884-f609e648f49b
begin
	fileName = "omega_cen_phot.columns"
	columnsFile = joinpath(datadir(), "exp_raw/OmegaCen/"*fileName)
	md" ##### Column file processing"
end

# ╔═╡ c4968ea9-9dc1-4cad-b402-4339e21cf9b4
print_textFile_lines(columnsFile, 16:29)

# ╔═╡ bd8195c4-ae94-405e-9536-9f7b9883a4c9
md"""
!!! note ""
# notes start
#### should go to a new notebook exclusively dedicated to notes

  - [AB vs Vega Magnitudes](https://jwst-docs.stsci.edu/jwst-near-infrared-camera/nircam-performance/nircam-absolute-flux-calibration-and-zeropoints#gsc.tab=0)
"""

# ╔═╡ b27ddee0-95fd-4ad9-9b18-11454501b2df
Threads.nthreads()

# ╔═╡ c0caff24-d5dc-46c3-8370-220e979c9f91
md" # Bottom Cell"

# ╔═╡ Cell order:
# ╠═7b98ed8c-7a38-463d-91e9-9915901a0047
# ╟─4bbf22dd-2776-4e17-9abb-960b19add303
# ╠═37681186-6c21-4e86-8ad2-f199c2cdefe4
# ╠═82aa8219-8d97-4103-970d-6a89ada5e9f4
# ╠═6cc5f5c4-0153-4903-ac7a-31f6fe7c19a6
# ╠═baec53cc-f36a-4dce-84d4-f41dc6d919df
# ╠═5ad9dee6-6281-4b84-9f80-92da1a4e16a7
# ╠═a269c4b8-aa06-4ac1-8cfe-b1d4fd3d89cd
# ╠═22738cd1-e9ef-4972-961f-fd7b9d54c05b
# ╠═d7732a1b-786f-48d0-a230-d55d617ac0cc
# ╠═f4b50de1-ec00-4285-acac-70dfe31e3de6
# ╠═d7e61019-4b19-4de2-b925-da149b992372
# ╠═739b8dfa-6721-42a7-ae2b-bcbb9b04d296
# ╠═33f5c361-cd0d-4ac3-b1fa-8b4320f2bbc1
# ╠═db6d3a85-df3e-4469-b781-3f73a194b49d
# ╠═69ba9361-28c4-4c18-b0c8-2a8da43e4376
# ╠═56f13fa5-3806-461b-ab31-64d68eaf3928
# ╠═88253dc5-b8e8-4b38-82c8-ed0b6fb3268e
# ╠═506c52d5-30a0-4d7c-8550-4cd9259730d0
# ╠═4d56a2a4-d011-4199-9d68-47b6df09a928
# ╟─45693af8-294a-429a-a884-f609e648f49b
# ╠═c4968ea9-9dc1-4cad-b402-4339e21cf9b4
# ╠═bd8195c4-ae94-405e-9536-9f7b9883a4c9
# ╠═b27ddee0-95fd-4ad9-9b18-11454501b2df
# ╠═c0caff24-d5dc-46c3-8370-220e979c9f91
