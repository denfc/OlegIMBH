### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 82aa8219-8d97-4103-970d-6a89ada5e9f4
using DrWatson

# ╔═╡ 6cc5f5c4-0153-4903-ac7a-31f6fe7c19a6
begin
	@quickactivate # 'cause we're in the same-named directory (as the project)
	
	using Base.Threads
	using Revise
	using Plots
	using CSV, DataFrames
	using AstroImages, FITSIO
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
	TableOfContents(title = "P22_JWST", depth = 6)
end

# ╔═╡ 0141542b-a0f5-44dd-9f59-8000501df935
md"""
dfc 20 September 2024: P22_JWST.jl
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
    	padding-right: max(333px, 10%); 
        # 383px to accomodate TableOfContents(aside=true)
	}
}
</style>
Widens screen cell width proportionally to window width.
"""

# ╔═╡ 37681186-6c21-4e86-8ad2-f199c2cdefe4
md" # Top Cell"

# ╔═╡ 514abf01-c730-4753-a153-d3c83f1a6086
cd(joinpath(homedir(), "Gitted/OlegIMBH"))

# ╔═╡ 38a15a7b-5a81-4db1-968e-0312f703ab10
dataDir45 = joinpath(datadir(), "exp_raw/MAST_2024-09-20T1145")

# ╔═╡ 2aae1677-8961-4d22-815e-cea8abd6e21b
CSV.read(joinpath(dataDir45, "jw02491_20240709t022838_pool.csv"), DataFrame)

# ╔═╡ 7fefe23a-62bf-4b6e-8fc9-adeadb6c41dc
# eData = AstroIO.read(joinpath(dataDir45, "jw02491-o005_t002_miri_f1130w_cat.ecsv"))
# typeof(eData) # Vector{UInt8} (alias for Array{UInt8, 1})
# length(eData) # 122749
# `DataFrame(eData)` (as CoPilot suggests) doesn't work

# ╔═╡ fb652b42-e455-46b8-abfd-5bc9740bf9ec
begin
	imageFile1 = joinpath(dataDir45, "jw02491-o005_t002_miri_f1130w_i2d.fits")
	miri45 = AstroImage(imageFile1)
end

# ╔═╡ f02870ae-775d-46bb-90da-a78fe321c95b
size(miri45)

# ╔═╡ 1968e607-a020-4eeb-b19e-608390d80d8a
f = FITS(imageFile1) # "Header Data Unit" is the HDU

# ╔═╡ 48a0fdbb-95cc-4803-a0bb-74385fc4a6a2
f[1], f[2], f[3], f[4], f[5], f[6], f[7], f[8], f[10] # 1 through 8 are the same type; 9 & 10 are different tables

# ╔═╡ 5d79efb1-0055-49f2-a821-b19ab53c9108
f[9]

# ╔═╡ 3cec201d-3e38-4a2b-b572-4a51c5e23101
AstroImage(imageFile1, 2:8) # note that 3, "Err," is a 1059×1030×1 AstroImage{Int32,3}  "image" that prints as a table

# ╔═╡ c0caff24-d5dc-46c3-8370-220e979c9f91
md" # Bottom Cell"

# ╔═╡ Cell order:
# ╠═0141542b-a0f5-44dd-9f59-8000501df935
# ╠═4bbf22dd-2776-4e17-9abb-960b19add303
# ╠═37681186-6c21-4e86-8ad2-f199c2cdefe4
# ╠═514abf01-c730-4753-a153-d3c83f1a6086
# ╠═82aa8219-8d97-4103-970d-6a89ada5e9f4
# ╠═6cc5f5c4-0153-4903-ac7a-31f6fe7c19a6
# ╠═baec53cc-f36a-4dce-84d4-f41dc6d919df
# ╠═38a15a7b-5a81-4db1-968e-0312f703ab10
# ╠═2aae1677-8961-4d22-815e-cea8abd6e21b
# ╠═7fefe23a-62bf-4b6e-8fc9-adeadb6c41dc
# ╠═fb652b42-e455-46b8-abfd-5bc9740bf9ec
# ╠═f02870ae-775d-46bb-90da-a78fe321c95b
# ╠═1968e607-a020-4eeb-b19e-608390d80d8a
# ╠═48a0fdbb-95cc-4803-a0bb-74385fc4a6a2
# ╠═5d79efb1-0055-49f2-a821-b19ab53c9108
# ╠═3cec201d-3e38-4a2b-b572-4a51c5e23101
# ╠═c0caff24-d5dc-46c3-8370-220e979c9f91
