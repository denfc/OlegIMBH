function readSourceCats()
	# Read Source Catalog Files
		oneDataDir = joinpath(datadir(), "exp_raw")
		threeDataDirs = readdir(oneDataDir)
		threeDataDirs = [joinpath(oneDataDir, threeDataDirs[i]) for i in 1:3]
		threeSourceCats = []
		for dir in 1:3
			fName = threeDataDirs[dir]*"/jw02491-o005_t002_miri_"*threeFrequencies[dir]*"_cat.ecsv"
			push!(threeSourceCats, CSV.read(fName, DataFrame; comment = "#", normalizenames=true)) # formerly removed label column
		end
	
		RA_Dec = [vcat((collect(threeSourceCats[i].sky_centroid_ra))', (collect(threeSourceCats[i].sky_centroid_dec))') for i in 1:3]
		print("Sizes of RA_Dec: ")
		for i in 1:3
			print(size(RA_Dec[i]), " $(threeFrequencies[i]); ", )
		end
		println()
		return RA_Dec, threeSourceCats
	end