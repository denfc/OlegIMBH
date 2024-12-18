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
	using PlutoPlotly # loaded _instead_ of PlotlyJS
	using PlotlyJS # which it turned out we needed for `savefig`
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
	TableOfContents(title = "P22a_OmegaCen", depth = 6)
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
	columnsToRead = 1:37 # nothing # 16:29
	df = CSV.read("./data/exp_raw/OmegaCen/omega_cen_phot", DataFrame; header=false, delim=" ", ignorerepeated = true, select = columnsToRead)
end

# ╔═╡ 6c0fdeb3-d5f2-4819-a9bb-5cce9068d623
md"### Check Quality"

# ╔═╡ f77f5982-9c79-40c9-a7df-d1ca0cf54733
md"#### Col. 11 (object type)"

# ╔═╡ 5955377d-242a-4964-b209-e05f082f7dce
objectType = ["bright star", "faint star ", "elongated  ", "hot pixel  ", "extended   "]

# ╔═╡ e5ca7174-2d4b-4081-a509-57a6e2193193
for i in eachindex(objectType)
	println("$i (", objectType[i], "): ", length(findall(x -> x == i, df.Column11)))
end

# ╔═╡ a9d9c3e0-ce88-4219-9f5e-e6cfa05b9700
faint_ind = findall(x -> x == 2, df.Column11)

# ╔═╡ cde8a2bc-3f0f-4915-8bd9-4efead766dba
begin
	faint16 = df[:, :Column16][faint_ind]
	faint29 = df[:, :Column29][faint_ind]
end

# ╔═╡ b9244582-6992-4416-aea8-f2b4f1e0db5f
begin
	faint_SNR = df.Column6[faint_ind]
	faint_Crowding = df.Column10[faint_ind]
	faint_SharpSq = df.Column7[faint_ind].^2
	faint_Q200_flag = df.Column24[faint_ind]
	faint_Q444_flag = df.Column37[faint_ind]
end

# ╔═╡ 9ebc2ade-4050-4a02-8e58-0a2e9cf0865c
md" #####  `faint_good`"

# ╔═╡ 0e76b9b2-1393-40d0-9fa3-e94368333ae8
faint_good_ind = findall(i -> faint_SNR[i] >= 4 && faint_Crowding[i] <= 2.25 && faint_SharpSq[i] <= 2.25 && faint_Q200_flag[i] <= 3 && faint_Q444_flag[i] <= 3, 1:length(faint_ind) ) 

# ╔═╡ 787c3072-88d8-4085-a915-19ef94326e9d
length(faint_good_ind)

# ╔═╡ 4c4b9bdc-66c2-4dbe-a13a-32508a408ea5
extrema(faint16)

# ╔═╡ 2688062b-3c47-4229-ad1b-2cd64233f845
p = scatter(y = faint16[faint_good_ind], x = faint16[faint_good_ind] .- faint29[faint_good_ind], mode = "markers")

# ╔═╡ 9421829a-0ae5-411f-80f0-63c5ad7c06b0
l_faint = Layout(
	# width = 700, height = 607,
	yaxis = attr(range = [28, 23], title = "16. Instr VEGAMAG, NIRCAM_F200W"),
	xaxis = attr(range = [-8, 4], title = "16 minus 29: IRCAM_F200W - NIRCAM_F444W"),
	title = "OmCen 11740 faint, good (1555 stars)"
)

# ╔═╡ 0dee2cff-bdc9-4ffc-baa1-54bb64f0deba
PlutoPlotly.plot(p, l_faint) #,  config = pp_configStatic) 

# ╔═╡ 0755db98-38cd-4cc9-abed-68e3d4ab57c2
PlutoPlotly.restyle!(p, title = "test")

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

# ╔═╡ 390c2b92-0884-41fb-a279-aef87c890132
l_all = Layout(
	width = 700, height = 607,
	xaxis = attr(range = [-15, 15], title = "16 minus 29: IRCAM_F200W - NIRCAM_F444W"),
	yaxis = attr(range = [40, 14], title = "16. Instr VEGAMAG, NIRCAM_F200W"),
	title = "Omega Centauri"
)

# ╔═╡ 88253dc5-b8e8-4b38-82c8-ed0b6fb3268e
md"Select number of indices $(@bind indNumber confirm(Slider(9_113:10_000:749_113, default = 50_000, show_value = true)))"

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
trace = scattergl(
	df,
	x =  x_reduced,
	y = y_reduced,
	mode = "markers",
    marker = attr(
        size = 3,       # Adjust the size of the points
        opacity = 1    # Adjust the transparency of the points
	)
) 
# to remember kwargs from when using Plots:, yflip = true, xlabel = "16 minus 29: IRCAM_F200W - NIRCAM_F444W",  title = "Omega Centauri", ylabel = "16. Instr VEGAMAG, NIRCAM_F200W", label = "", xlims = [-15, 15], ylims = [14, 40], markersize = 2.5, markercolor = :white))

# ╔═╡ 77567b04-0deb-4411-8d66-4c91851d1b41
if indNumber > 200_000 warning = true else warning = false end

# ╔═╡ 6027924c-ec8c-4381-ad33-aad5f92ab7e9
md"""
#### Static Plot Choice
"""

# ╔═╡ 4db8b9af-bc18-4ab5-a98e-66dce23dc3ff
if warning
md"""!!! danger "No. Too many points for interactive plot." """
end

# ╔═╡ 67a5442f-e127-465f-9096-523fd4b8db27
md"""
If want interactie plots, uncheck the box, but remember that above about 200,000 points, you'll freeze the program:$(@bind staticP CheckBox(default = true))
"""

# ╔═╡ 4e40ff1c-6663-4d5f-a5ba-c571b1fb3381
md" #### `pp_config`"

# ╔═╡ 58d31569-0e0f-4058-a571-d466764181a7
pp_configStatic = PlutoPlotly.PlotConfig(staticPlot = true)

# ╔═╡ 4e00a1a0-2958-4274-8b85-ae1e7f068170
if staticP PlutoPlotly.plot([trace], l_all, config = pp_configStatic) else PlutoPlotly.plot([trace], layout) end

# ╔═╡ ca60cb11-84ac-48f6-8356-0bcc2ba3c8e7
md"""
#### Save Plot?
If want to save a plot, `omega_centauri_plot.html` (interactive), check the box: $(@bind saveP CheckBox(default = false))
"""

# ╔═╡ 477de3d0-3150-489a-b272-f77de4da0013
if saveP
	plot_obj = PlotlyJS.plot([trace], layout) #, config = pp_config)
    PlotlyJS.savefig(plot_obj, "omega_centauri_plot.html")
end

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
# ╠═6c0fdeb3-d5f2-4819-a9bb-5cce9068d623
# ╠═f77f5982-9c79-40c9-a7df-d1ca0cf54733
# ╠═5955377d-242a-4964-b209-e05f082f7dce
# ╠═e5ca7174-2d4b-4081-a509-57a6e2193193
# ╠═a9d9c3e0-ce88-4219-9f5e-e6cfa05b9700
# ╠═cde8a2bc-3f0f-4915-8bd9-4efead766dba
# ╠═b9244582-6992-4416-aea8-f2b4f1e0db5f
# ╠═9ebc2ade-4050-4a02-8e58-0a2e9cf0865c
# ╠═0e76b9b2-1393-40d0-9fa3-e94368333ae8
# ╠═787c3072-88d8-4085-a915-19ef94326e9d
# ╠═4c4b9bdc-66c2-4dbe-a13a-32508a408ea5
# ╠═2688062b-3c47-4229-ad1b-2cd64233f845
# ╠═9421829a-0ae5-411f-80f0-63c5ad7c06b0
# ╠═0dee2cff-bdc9-4ffc-baa1-54bb64f0deba
# ╠═0755db98-38cd-4cc9-abed-68e3d4ab57c2
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
# ╠═506c52d5-30a0-4d7c-8550-4cd9259730d0
# ╠═390c2b92-0884-41fb-a279-aef87c890132
# ╠═88253dc5-b8e8-4b38-82c8-ed0b6fb3268e
# ╠═77567b04-0deb-4411-8d66-4c91851d1b41
# ╟─6027924c-ec8c-4381-ad33-aad5f92ab7e9
# ╟─4db8b9af-bc18-4ab5-a98e-66dce23dc3ff
# ╟─67a5442f-e127-465f-9096-523fd4b8db27
# ╠═4e00a1a0-2958-4274-8b85-ae1e7f068170
# ╟─4e40ff1c-6663-4d5f-a5ba-c571b1fb3381
# ╠═58d31569-0e0f-4058-a571-d466764181a7
# ╟─ca60cb11-84ac-48f6-8356-0bcc2ba3c8e7
# ╠═477de3d0-3150-489a-b272-f77de4da0013
# ╠═4d56a2a4-d011-4199-9d68-47b6df09a928
# ╟─45693af8-294a-429a-a884-f609e648f49b
# ╠═c4968ea9-9dc1-4cad-b402-4339e21cf9b4
# ╠═b27ddee0-95fd-4ad9-9b18-11454501b2df
# ╠═c0caff24-d5dc-46c3-8370-220e979c9f91
