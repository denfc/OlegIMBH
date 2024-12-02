"""
dfc 28 November 2024
To limit NIRCam_RADec to the MIRI region, we'll find the extreme values of the MIRI region in RA and Dec, and then limit the NIRCam region to those values.
dfc 29 November 2024
	- Updated to put in the MIRI XY coordinates.
"""

include(joinpath(homedir(), "Gitted/OlegIMBH/src/introTranslate.jl"))

dfMIRI = jldopen(joinpath(datadir("exp_pro/MIRI_RADec.jld2")))["newColumnGroup"]
dfNIRCam = jldopen(joinpath(datadir("exp_pro/NIRCam_RADec.jld2")))["newColumnGroup"]

extremeDecs = extrema(dfMIRI.dec)
extremeRAs = extrema(dfMIRI.ra)

dfNIRClimited = dfNIRCam[(dfNIRCam[!, :dec] .>= extremeDecs[1]) .& (dfNIRCam[!, :dec] .<= extremeDecs[2]) .& (dfNIRCam[!, :ra] .>= extremeRAs[1]) .& (dfNIRCam[!, :ra] .<= extremeRAs[2]), :]

#= roughly proportional to the ratio of the areas of the two regions
Decs = extrema(dfNIRCam.dec)
RAs = extrema(dfNIRCam.ra)

miriArea= (extremeDecs[2] - extremeDecs[1])*(extremeRAs[2] - extremeRAs[1])
nircArea = (Decs[2] - Decs[1]) * (RAs[2] - RAs[1])

println("MIRI/NIRCam ratio: ", miriArea/nircArea)
=#

FITSfile = datadir("exp_raw/Archive_MIRI_Ocen_dolphot/jw04343-o001_t001_miri_f770w_i2d.fits")

# Read the FITS file with AstroImages.AstroImage
img = AstroImage(FITSfile)

# Get the WCS from the image
# Using the explicit wcs object might be slightly more efficient if you're doing many transformations since it avoids extracting the WCS repeatedly.
# Get the first WCS transform from the vector
wcsIMG = wcs(img)[1]  # Use first WCS transform

# Create coordinate matrix (2×N where N is number of points)
coord_matrix = hcat([[ra, dec] for (ra, dec) in zip(dfNIRClimited.ra, dfNIRClimited.dec)]...)

# Transform all coordinates at once
pixel_coords = world_to_pix(wcsIMG, coord_matrix)

# Split into x and y arrays
pixel_x = pixel_coords[1, :]
pixel_y = pixel_coords[2, :]

# Add pixel coordinates to your dataframe
dfNIRClimited.xMIRI = pixel_x
dfNIRClimited.yMIRI = pixel_y

output_file = joinpath(datadir(), "exp_pro/NIRCamLimited.jld2")
jldsave(output_file; dfNIRClimited)

#=
The splat operator (...) is needed here because:

The list comprehension [[ra, dec] for (ra, dec) in zip(...)] creates an array of 2-element arrays
hcat needs its arguments to be individual arrays to concatenate horizontally
The splat operator unpacks the outer array into separate arguments for hcat
Without the splat, you'd be trying to horizontally concatenate a single array of arrays. With the splat, you're concatenating each inner [ra, dec] array as a separate column.

Here's a simpler example to illustrate:
# Without splat - tries to concatenate one array of arrays
hcat([[1,2], [3,4]])        # Error

# With splat - concatenates individual arrays
hcat([[1,2], [3,4]]...)     # Returns 2×2 Matrix: [1 3; 2 4]

An alternative way to write this without the splat would be to use a matrix constructor directly:

coord_matrix = reduce(hcat, [[ra, dec] for (ra, dec) in zip(dfNIRClimited.ra, dfNIRClimited.dec)])

=#