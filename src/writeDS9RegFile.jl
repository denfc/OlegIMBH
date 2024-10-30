function DS9_writeRegionFile(x::Vector{Float64}, y::Vector{Float64}, radius::Int64, fName::String; color = "green")
	region_file = joinpath(datadir("sims"), fName)
	region_file = region_file * ".reg"
	open(region_file, "w") do f
		write(f, "# Region file format: DS9 version 8.5.0\n")
		write(f, "# green is default but, e.g., could use `global color=red`; format: x y radius \n")
		write(f, "global color=$color\n")
		for i in eachindex(x)  # could use zip
			write(f, "circle $(x[i]) $(y[i]) $radius\n")
		end
	end
	if isfile(region_file)
		println("Region file created successfully at $region_file.")
		return region_file
	else
		error("Failed to create region file; no return")
	end
end

function DS9_writeRegionFile(x::Int64, y::Int64, radius::Int64, fName::String; text = "")
	region_file = joinpath(datadir("sims"), fName)
	region_file = region_file * ".reg"
	open(region_file, "w") do f
		write(f, "# Region file format: DS9 version 8.5.0\n")
		# Split the text into multiple lines
		lines = split(text, "\n")
		for (i, line) in enumerate(lines)
			write(f, "text($x, $(y - i * 100)) # text={$line}\n")
		end
		if isfile(region_file)
			println("Region file created successfully at $region_file.")
			return region_file
		else
			error("Failed to create region file; no return")
		end
	end
end