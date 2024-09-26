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
	using NearestNeighbors
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

# ╔═╡ 6cabc13b-9bb7-4f74-b7b6-f98435e94d5e
include(srcdir("crossmatches.jl"));

# ╔═╡ 7b98ed8c-7a38-463d-91e9-9915901a0047
md"""
dfc 20 September 2024: P22_JWST.jl
!!! note "MAST stands for Mikulski Archive Space Telescopes"
    - Mid-InfraRed Instrument: 4.9 to 28.8 μm
!!! note " "i2d" means "that this is a rectified and calibrated image mosaic" "
    - from Stage 3: "2-D resampled PSF-subtracted image"
    - "segm" is a "Segmentation Map"
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
    	padding-right: max(313px, 10%); 
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

# ╔═╡ 514abf01-c730-4753-a153-d3c83f1a6086
cd(joinpath(homedir(), "Gitted/OlegIMBH"))

# ╔═╡ e7cad711-da03-40a2-8732-89999a6a7605
md" ### dataDir\_T45\_f1130"

# ╔═╡ 38a15a7b-5a81-4db1-968e-0312f703ab10
dataDir_T45_f1130 = joinpath(datadir(), "exp_raw/MAST_2024-09-20T1145")

# ╔═╡ df744749-bf44-4c80-ae3b-982103f938c9
six_f1130 = readdir(dataDir_T45_f1130)

# ╔═╡ 2aae1677-8961-4d22-815e-cea8abd6e21b
csv_f1130 = CSV.read(joinpath(dataDir_T45_f1130, six_f1130[6]), DataFrame)

# ╔═╡ 83cb5d5a-ab00-409a-8046-17b86a5cb5fa
six_f1130[6]

# ╔═╡ 5ad9dee6-6281-4b84-9f80-92da1a4e16a7
md"### Reading ESCV file "

# ╔═╡ d937eb69-92fc-443b-8cac-d3fb33b787b8
md"""
!!! note "Can read ESCV file either by denoting commenting symbol directly or or by going to header line directly."
	- This note belongs in the notebook to be set up for this project.
	- Can exclude the "label" column, but might need it for the cross matching.
!!! note " This file is the "Source Catalog Table" "
    - [Definitions of column headings can be found here.](https://jwst-pipeline.readthedocs.io/en/stable/jwst/source_catalog/main.html)
"""

# ╔═╡ f370c1b5-47f2-4af4-b2ff-eb1aac682d4c
begin
	sourceCat_f1130 = CSV.read(joinpath(dataDir_T45_f1130, six_f1130[3]), DataFrame; comment = "#",  drop=[:label], normalizenames=true) # [1, :]
	test = CSV.read(joinpath(dataDir_T45_f1130, six_f1130[3]), DataFrame; comment = "#", normalizenames=true) # :label included
end

# ╔═╡ ac6f1aa1-9da3-419d-8ce9-2e2a07c2deb1
six_f1130[3]

# ╔═╡ 9b2a1904-04a1-42cf-8922-c8efe651c4fa
md"""!!! note "Sure looks like "label" is the same as the Julia index." """

# ╔═╡ 6c9456af-8ea3-4255-b345-2954204c0b9f
for i in 1:length(test.label)
	if test.label[i] != i println(i, " not the same?!") else print("+") end
end	

# ╔═╡ 7bf9cc16-5b19-41f6-81e2-17afcf44b519
t = CSV.read(joinpath(dataDir_T45_f1130, six_f1130[3]), DataFrame; header = 263,  drop=[:label], normalizenames=true)[1, :]

# ╔═╡ 1e0ef00a-72f1-4186-ac18-aaac7cb21a00
t == test

# ╔═╡ af220e1d-a938-4bf7-aeba-089e4b31d367
typeof(test.sky_centroid_ra)

# ╔═╡ ab588ecd-b4ad-49bb-8643-f331bbec5ede
names(test)

# ╔═╡ 18eb700a-7af4-40fe-97c7-1a16344dfebb
length(findall(x -> x ==1, test[!, 34]))

# ╔═╡ 082f725d-f19f-411e-a8e2-9afee3714883
extrema(test.nn_dist)

# ╔═╡ e69c8ef9-368e-443f-ad48-bc4a3a06fc30
md" #### Test `crossmatch`"

# ╔═╡ 69b9ca1c-86c0-403b-a017-cd7385930839
begin
	X1 = [1.0 2.0 3.0 8.0; 4.0 5.0 6.0 7.0]
	X2 = [1.0 2.0 3.0 8.0; 4.0 5.0 6.0 9.0]
end

# ╔═╡ 4bab6517-0675-449b-bc43-db2c5408674f
typeof(X1)

# ╔═╡ fb6e663b-c630-469f-9e35-ebd517aeecf4
idxs, dists = crossmatch(X1, X2)

# ╔═╡ 48a5e49f-6943-4275-9073-d8447714283d
md" #### Building 2 Cols
##### `reshapeCoords`
"

# ╔═╡ 83e37440-249f-4658-aaf3-9a98f3478e9b
function reshapeCoords(RA, Dec)
	return vcat( (collect(RA))', (collect(Dec))' )
end

# ╔═╡ 32ef56b3-e695-4c3b-b254-19c3e6aaf7c2
RA_Dec = reshapeCoords(sourceCat_f1130.sky_centroid_ra, sourceCat_f1130.sky_centroid_dec)

# ╔═╡ 2d90a063-361f-4c97-836d-f45f2d21e921
md"### INCLUDE "

# ╔═╡ bd6bd1f2-9d65-47bf-95f2-13d97fe110c3
six_f1130[3]

# ╔═╡ 7fefe23a-62bf-4b6e-8fc9-adeadb6c41dc
# eData = AstroIO.read(joinpath(dataDir_f1130_T45, "jw02491-o005_t002_miri_f1130w_cat.ecsv"))
# typeof(eData) # Vector{UInt8} (alias for Array{UInt8, 1})
# length(eData) # 122749
# `DataFrame(eData)` (as CoPilot suggests) doesn't work

# ╔═╡ fb652b42-e455-46b8-abfd-5bc9740bf9ec
begin
	imageFile_f1130_1 = joinpath(dataDir_T45_f1130, six_f1130[4])
	miri_f1130_1 = AstroImage(imageFile_f1130_1)
end

# ╔═╡ 937704db-0ff9-47cf-bd01-38328b85f373
six_f1130[4]

# ╔═╡ c49a45c8-2976-4926-b1e4-84955b0e0df1
imview(miri_f1130_1, stretch = logstretch)

# ╔═╡ 14a155de-7d8f-40a4-8b88-d8a9053e6bfa
implot(miri_f1130_1)

# ╔═╡ d27304e0-4652-47e4-81e5-eaf6704163f9
md" #### WCS transform"

# ╔═╡ 7521c656-1150-42a4-bccb-4ed9e9f16eb6
wcs(miri_f1130_1, 1)

# ╔═╡ f02870ae-775d-46bb-90da-a78fe321c95b
size(miri_f1130_1)

# ╔═╡ 1968e607-a020-4eeb-b19e-608390d80d8a
f = FITS(imageFile_f1130_1) # "Header Data Unit" is the HDU

# ╔═╡ 5fcdb9d3-e7ac-45d1-bea4-d52c0956c72c
img = AstroImage(f[2]);

# ╔═╡ 9b6d7066-2ffb-4623-995d-a2e863164db8
img[1,1]

# ╔═╡ 48a0fdbb-95cc-4803-a0bb-74385fc4a6a2
f[1], f[2], f[3], f[4], f[5], f[6], f[7], f[8], f[10] # 1 through 8 are the same type; 9 & 10 are different tables

# ╔═╡ 5d79efb1-0055-49f2-a821-b19ab53c9108
f[9]

# ╔═╡ 3cec201d-3e38-4a2b-b572-4a51c5e23101
AstroImage(imageFile_f1130_1, 2:8) # note that 3, "Err," is a 1059×1030×1 AstroImage{Int32,3}  "image" that prints as a table

# ╔═╡ 86ce6c24-40f3-4912-91d5-8f8795d7a512
begin
	imageFile_f1130_2 = joinpath(dataDir_T45_f1130, six_f1130[4])
	miri_f1130_2 = AstroImage(imageFile_f1130_2)
end

# ╔═╡ d0fcb65d-104e-485d-bd1c-c9bc38665467
six_f1130[4]

# ╔═╡ 78a7ae03-8e74-4c73-ae15-39be972f9711
FITS(imageFile_f1130_2)

# ╔═╡ 63a9f4c4-1f35-44fd-9148-750565e5b866
H45_2 = header(miri_f1130_2)

# ╔═╡ 32acdfb5-5674-493c-aced-71af36c2af20
length(H45_2)

# ╔═╡ 4909fcce-160a-491b-b6d6-5ab5e5683799
H45_2[33]

# ╔═╡ c4613841-64dd-4dae-be2d-14d898183ef3
md" ### dataDir\_T47\_f770"

# ╔═╡ 4aab0fd7-9a98-4699-8493-e36d27d7c9b6
dataDir_T47_f770 = joinpath(datadir(), "exp_raw/MAST_2024-09-20T1147")

# ╔═╡ fbbb5730-442f-4514-a66f-9abaeec6c3fc
six_f770 = readdir(dataDir_T47_f770)

# ╔═╡ b1b0df6f-efee-4d9a-94e3-0c1bab4f1200
csv_f770 = CSV.read(joinpath(dataDir_T47_f770, six_f770[6]), DataFrame)

# ╔═╡ 5cf6f138-6120-48f3-9204-2466fd52f70d
names(csv_f770)

# ╔═╡ 797db257-3cbb-4369-a5d3-2c74edd71996
begin
	imageFIle_f770_1 = joinpath(dataDir_T47_f770, six_f770[4])
	miri_f770_1 = AstroImage(imageFIle_f770_1)
end

# ╔═╡ 00928dfd-dceb-4f7f-a8be-e615197f3d96
six_f770[4]

# ╔═╡ 2036f9fa-47d2-413a-bc9c-f03d79d4acc1
implot(miri_f770_1)

# ╔═╡ d20750f1-89dc-4583-9642-d3a6c6742ea6
six_f770[4]

# ╔═╡ 0d57fb79-32b9-4288-aede-463c51730b43
FITS(imageFIle_f770_1)

# ╔═╡ 6a70f92f-4028-4c24-a2b6-3d728ece3931
test_f770 = CSV.read(joinpath(dataDir_T47_f770, six_f770[3]), DataFrame; comment = "#", normalizenames=true)

# ╔═╡ 5b7193ce-8cc3-4b9b-bdc4-88f418a55f4b
md" #### label = index?"

# ╔═╡ 73baf97a-7782-4840-ba88-44b850d8a3cf
for i in 1:length(test_f770.label)
	if test_f770.label[i] != i println(i, " not the same?!") else print("+") end
end	

# ╔═╡ 3930d0f2-dfba-40c2-8267-104345ba7a9a
md" ### dataDir\_T01\_f560"

# ╔═╡ d8c760d5-4bbe-43aa-842e-f3a1bed43f2b
dataDir_T01_f560 = joinpath(datadir(), "exp_raw/MAST_2024-09-20T1201")

# ╔═╡ 30c0377a-48cf-4457-853f-24f2c90d11ce
six_f560 = readdir(dataDir_T01_f560)

# ╔═╡ f99ae558-1dfb-4439-94df-1bc18ee4586d
csv_f560 = CSV.read(joinpath(dataDir_T01_f560, six_f560[6]), DataFrame)

# ╔═╡ 20735f67-631b-4122-a019-fce28936876c
names(csv_f560) == names(csv_f770)

# ╔═╡ 60d45d32-a41a-432f-9ef7-fddc287dae10
begin
	imageFile_f560_1 = joinpath(dataDir_T01_f560, six_f560[4])
	miri_f560_1 = AstroImage(imageFile_f560_1)
end

# ╔═╡ e6f172bb-bf34-46fd-ab87-0a492c970e77
six_f560[4]

# ╔═╡ aa7e0ef3-11a0-4f0e-88b4-af504c6cc418
implot(miri_f560_1)

# ╔═╡ e09612b6-ac08-4106-a71d-054959527da8
six_f560[5]

# ╔═╡ 621f24e7-e4e4-4114-824d-d57a7df5079a
# miri_f560_1.header ==  header(miri_f560_1) is true

# ╔═╡ 0988f267-8588-42da-9f75-86b6c31c2810
header(miri_f560_1)

# ╔═╡ b3d7d55a-cafc-42a5-9884-e3e115aff31a
keys(miri_f560_1)

# ╔═╡ feb17ae4-924a-408d-b308-9e987bd48db6
f_f560_1 = FITS(imageFile_f560_1)

# ╔═╡ b4b6dc27-3862-4eb4-9a63-a4f9306690d7
test_f560 = CSV.read(joinpath(dataDir_T01_f560, six_f560[3]), DataFrame; comment = "#", normalizenames=true)

# ╔═╡ 9683205c-642b-4921-99df-0d9d5317ad0e
RA_Dec2 = reshapeCoords(test_f560.sky_centroid_ra, test_f560.sky_centroid_dec)

# ╔═╡ b65aed3b-cb88-4635-b673-a10ca312339f
tmp = RA_Dec2

# ╔═╡ 5e438b34-6523-48a0-87ee-df8cc446382d
let
	println(typeof(RA_Dec))
	#bxs, dist = crossmatch(RA_Dec, RA_Dec2)
	xsA, distA = crossmatch_angular(RA_Dec2, RA_Dec2)
end

# ╔═╡ 91aa9c95-eb65-4edb-a7cf-fe19b22414b6
begin
	println(typeof(RA_Dec2))
	xs, dist = crossmatch(RA_Dec, RA_Dec)
	xsA, distA = crossmatch_angular(RA_Dec, RA_Dec)
end

# ╔═╡ e070368f-c478-4d26-a533-5fc680ccf842
xs == xsA, dist == distA

# ╔═╡ 4627b530-0d74-48d3-bfb3-fb905300073a
xs

# ╔═╡ 7caf05eb-cdcc-4274-ab16-d1fbb6592503
Matrix(xs)

# ╔═╡ 818d3661-d207-463e-95f8-806d17206cc2
md" #### label = index?"

# ╔═╡ a9259808-c4d4-42b1-ab5f-967070602dce
size(test_f560)

# ╔═╡ 22353da5-d63f-4e45-934e-181e64ee91eb
md"""!!! note "use `size(df)[1]` to get number of sources" """

# ╔═╡ 2f8a8c76-2770-4442-a2bb-23da1fc15bb0
length(findall(x -> x >= 0, test_f560.sky_centroid_ra)) == size(test_f560)[1]

# ╔═╡ 365811f1-0530-4b0e-9a94-e90a272c0260
for i in 1:length(test_f560.label)
	if test_f560.label[i] != i println(i, " not the same?!") else print("+") end
end	

# ╔═╡ bd8195c4-ae94-405e-9536-9f7b9883a4c9
md"""
!!! note ""
# notes start
#### should go to a new notebook exclusively dedicated to notes

  - [AB vs Vega Magnitudes](https://jwst-docs.stsci.edu/jwst-near-infrared-camera/nircam-performance/nircam-absolute-flux-calibration-and-zeropoints#gsc.tab=0)
"""

# ╔═╡ c0caff24-d5dc-46c3-8370-220e979c9f91
md" # Bottom Cell"

# ╔═╡ Cell order:
# ╟─7b98ed8c-7a38-463d-91e9-9915901a0047
# ╟─4bbf22dd-2776-4e17-9abb-960b19add303
# ╠═37681186-6c21-4e86-8ad2-f199c2cdefe4
# ╠═514abf01-c730-4753-a153-d3c83f1a6086
# ╠═82aa8219-8d97-4103-970d-6a89ada5e9f4
# ╠═6cc5f5c4-0153-4903-ac7a-31f6fe7c19a6
# ╠═baec53cc-f36a-4dce-84d4-f41dc6d919df
# ╠═e7cad711-da03-40a2-8732-89999a6a7605
# ╠═38a15a7b-5a81-4db1-968e-0312f703ab10
# ╠═df744749-bf44-4c80-ae3b-982103f938c9
# ╠═2aae1677-8961-4d22-815e-cea8abd6e21b
# ╠═83cb5d5a-ab00-409a-8046-17b86a5cb5fa
# ╠═5ad9dee6-6281-4b84-9f80-92da1a4e16a7
# ╠═d937eb69-92fc-443b-8cac-d3fb33b787b8
# ╠═f370c1b5-47f2-4af4-b2ff-eb1aac682d4c
# ╠═ac6f1aa1-9da3-419d-8ce9-2e2a07c2deb1
# ╠═9b2a1904-04a1-42cf-8922-c8efe651c4fa
# ╠═6c9456af-8ea3-4255-b345-2954204c0b9f
# ╠═7bf9cc16-5b19-41f6-81e2-17afcf44b519
# ╠═1e0ef00a-72f1-4186-ac18-aaac7cb21a00
# ╠═af220e1d-a938-4bf7-aeba-089e4b31d367
# ╠═ab588ecd-b4ad-49bb-8643-f331bbec5ede
# ╠═18eb700a-7af4-40fe-97c7-1a16344dfebb
# ╠═082f725d-f19f-411e-a8e2-9afee3714883
# ╠═e69c8ef9-368e-443f-ad48-bc4a3a06fc30
# ╠═69b9ca1c-86c0-403b-a017-cd7385930839
# ╠═4bab6517-0675-449b-bc43-db2c5408674f
# ╠═fb6e663b-c630-469f-9e35-ebd517aeecf4
# ╠═48a5e49f-6943-4275-9073-d8447714283d
# ╠═83e37440-249f-4658-aaf3-9a98f3478e9b
# ╠═32ef56b3-e695-4c3b-b254-19c3e6aaf7c2
# ╠═9683205c-642b-4921-99df-0d9d5317ad0e
# ╠═b65aed3b-cb88-4635-b673-a10ca312339f
# ╠═2d90a063-361f-4c97-836d-f45f2d21e921
# ╠═6cabc13b-9bb7-4f74-b7b6-f98435e94d5e
# ╠═5e438b34-6523-48a0-87ee-df8cc446382d
# ╠═91aa9c95-eb65-4edb-a7cf-fe19b22414b6
# ╠═e070368f-c478-4d26-a533-5fc680ccf842
# ╠═4627b530-0d74-48d3-bfb3-fb905300073a
# ╠═7caf05eb-cdcc-4274-ab16-d1fbb6592503
# ╠═bd6bd1f2-9d65-47bf-95f2-13d97fe110c3
# ╠═7fefe23a-62bf-4b6e-8fc9-adeadb6c41dc
# ╠═fb652b42-e455-46b8-abfd-5bc9740bf9ec
# ╠═937704db-0ff9-47cf-bd01-38328b85f373
# ╠═c49a45c8-2976-4926-b1e4-84955b0e0df1
# ╠═14a155de-7d8f-40a4-8b88-d8a9053e6bfa
# ╠═d27304e0-4652-47e4-81e5-eaf6704163f9
# ╠═7521c656-1150-42a4-bccb-4ed9e9f16eb6
# ╠═f02870ae-775d-46bb-90da-a78fe321c95b
# ╠═1968e607-a020-4eeb-b19e-608390d80d8a
# ╠═5fcdb9d3-e7ac-45d1-bea4-d52c0956c72c
# ╠═9b6d7066-2ffb-4623-995d-a2e863164db8
# ╠═48a0fdbb-95cc-4803-a0bb-74385fc4a6a2
# ╠═5d79efb1-0055-49f2-a821-b19ab53c9108
# ╠═3cec201d-3e38-4a2b-b572-4a51c5e23101
# ╠═86ce6c24-40f3-4912-91d5-8f8795d7a512
# ╠═d0fcb65d-104e-485d-bd1c-c9bc38665467
# ╠═78a7ae03-8e74-4c73-ae15-39be972f9711
# ╠═63a9f4c4-1f35-44fd-9148-750565e5b866
# ╠═32acdfb5-5674-493c-aced-71af36c2af20
# ╠═4909fcce-160a-491b-b6d6-5ab5e5683799
# ╠═c4613841-64dd-4dae-be2d-14d898183ef3
# ╠═4aab0fd7-9a98-4699-8493-e36d27d7c9b6
# ╠═fbbb5730-442f-4514-a66f-9abaeec6c3fc
# ╠═b1b0df6f-efee-4d9a-94e3-0c1bab4f1200
# ╠═5cf6f138-6120-48f3-9204-2466fd52f70d
# ╠═797db257-3cbb-4369-a5d3-2c74edd71996
# ╠═00928dfd-dceb-4f7f-a8be-e615197f3d96
# ╠═2036f9fa-47d2-413a-bc9c-f03d79d4acc1
# ╠═d20750f1-89dc-4583-9642-d3a6c6742ea6
# ╠═0d57fb79-32b9-4288-aede-463c51730b43
# ╠═6a70f92f-4028-4c24-a2b6-3d728ece3931
# ╠═5b7193ce-8cc3-4b9b-bdc4-88f418a55f4b
# ╠═73baf97a-7782-4840-ba88-44b850d8a3cf
# ╠═3930d0f2-dfba-40c2-8267-104345ba7a9a
# ╠═d8c760d5-4bbe-43aa-842e-f3a1bed43f2b
# ╠═30c0377a-48cf-4457-853f-24f2c90d11ce
# ╠═f99ae558-1dfb-4439-94df-1bc18ee4586d
# ╠═20735f67-631b-4122-a019-fce28936876c
# ╠═60d45d32-a41a-432f-9ef7-fddc287dae10
# ╠═e6f172bb-bf34-46fd-ab87-0a492c970e77
# ╠═aa7e0ef3-11a0-4f0e-88b4-af504c6cc418
# ╠═e09612b6-ac08-4106-a71d-054959527da8
# ╠═621f24e7-e4e4-4114-824d-d57a7df5079a
# ╠═0988f267-8588-42da-9f75-86b6c31c2810
# ╠═b3d7d55a-cafc-42a5-9884-e3e115aff31a
# ╠═feb17ae4-924a-408d-b308-9e987bd48db6
# ╠═b4b6dc27-3862-4eb4-9a63-a4f9306690d7
# ╠═818d3661-d207-463e-95f8-806d17206cc2
# ╠═a9259808-c4d4-42b1-ab5f-967070602dce
# ╠═22353da5-d63f-4e45-934e-181e64ee91eb
# ╠═2f8a8c76-2770-4442-a2bb-23da1fc15bb0
# ╠═365811f1-0530-4b0e-9a94-e90a272c0260
# ╠═bd8195c4-ae94-405e-9536-9f7b9883a4c9
# ╠═c0caff24-d5dc-46c3-8370-220e979c9f91
