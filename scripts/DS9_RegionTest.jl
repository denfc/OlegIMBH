using DrWatson
@quickactivate "OlegIMBH"
import SAOImageDS9
const sao = SAOImageDS9
using DataFrames

# Connect to DS9
sao.connect()

# Example DataFrame with xy points
df = DataFrame(x = 1001:1010, y = 1000*rand(10))

# Export Plot Data to a Region File
region_file = joinpath(pwd(), "plot.reg")
open(region_file, "w") do f
    write(f, "# Region file format: DS9 version 8.5.0\n")
    write(f, "# green is default but, e.g., could use `global color=red`; format: x y radius \n")
    for row in eachrow(df)
        write(f, "circle $(row.x) $(row.y) 10\n")
    end
end

# Ensure the file is properly closed and exists
if isfile(region_file)
    println("Region file created successfully at $region_file.")
else
    error("Failed to create region file.")
end

# Check file permissions
println("File permissions: ", stat(region_file).mode)

# Verify DS9 connection
try
    sao.set("regions", region_file)
    println("Region file sent to DS9 successfully.")
catch e
    println("Error sending region file to DS9: ", e)
end