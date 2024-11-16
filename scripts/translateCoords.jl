"""
	dfc 16 November 2024 a mess below, but the ingredients, some duplicated,  are there

"""
using AstroImages
using DataFrames
using JLD2

# Read the FITS file
fits_path = "/home/dfc123/Gitted/OlegIMBH/data/exp_raw/Archive_MIRI_Ocen_dolphot/jw04343-o001_t001_miri_f770w_i2d.fits"
img = AstroImage(fits_path)

data_file = "/path/to/your/datafile.csv"  # Replace with the actual path to your data file
output_file = "/path/to/output.jld2"

# Get WCS transformation from AstroImages
# wcs(img)

# Read the data file into a DataFrame
df = DataFrame(CSV.File(data_file))  # --- copy this from earlier code	

# Extract the x and y columns
x = df[:, :x]
y = df[:, :y]

# Translate the x and y columns into degrees
ra, dec = pix_to_world(img, [x, y])

# Select the specified columns
selected_columns = df[:, [:x, :y, 6, 7, 8, 10, 11, 16, 20, 21, 22, 23, 24, 29]]

# Add the translated coordinates to the DataFrame
selected_columns[:, :ra] = ra
selected_columns[:, :dec] = dec

# Write the selected columns and translated coordinates to a JLD2 file
@save output_file selected_columns

# Convert x,y to world coordinates
coords = Vector{Tuple{Float64,Float64}}()
for i in 1:nrow(df)
    ra, dec = WCS.pix_to_world(wcs, df.x[i], df.y[i])
    push!(coords, (ra, dec))
end

# Create output DataFrame
result = DataFrame(
    x = df.x,
    y = df.y,
    ra = getindex.(coords, 1),
    dec = getindex.(coords, 2),
    col6 = df[:,6],
    col7 = df[:,7],
    col8 = df[:,8],
    col10 = df[:,10],
    col11 = df[:,11],
    col16 = df[:,16],
    col20 = df[:,20],
    col21 = df[:,21],
    col22 = df[:,22],
    col23 = df[:,23],
    col24 = df[:,24],
    col29 = df[:,29]
)

# Save to JLD2 file
save("transformed_coordinates.jld2", "data", result)
close(f)