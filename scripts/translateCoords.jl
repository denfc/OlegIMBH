"""
	dfc 16 November 2024 a mess below, but the ingredients, some duplicated,  are there

"""

include(joinpath(homedir(), "Gitted/OlegIMBH/src/introTranslate.jl"))
global instruments = ["NIRCAM", "MIRI"]
struct ChoiceParams
    instrNumber::Int
    obTyn::Int
    inc99s::Bool
    onl99s::Bool
    randB::Bool
    nStrt::Int
    nB::Int
    grossLim::Bool
end
params = ChoiceParams(2, 1, false, false, false, 1, 31, false)
instrument, objectTypeIndex, include99s, only99s, randBright, nStart, nBrightest, gross_limits = choices(params)

if instrument == "NIRCAM"
	FITSfile = datadir("exp_raw/OmegaCen/jw04343-o002_t001_nircam_clear-f200w_i2d.fits")
	data_file = joinpath(datadir(), "exp_raw/OmegaCen/omega_cen_phot")
	output_file = joinpath(datadir(), "sims/NIRCAM_RADec.jld2")
else
	FITSfile = datadir("exp_raw/Archive_MIRI_Ocen_dolphot/jw04343-o001_t001_miri_f770w_i2d.fits")
	data_file = joinpath(datadir(), "exp_raw/Archive_MIRI_Ocen_dolphot/omega_cen_phot_miri")
	output_file = joinpath(datadir(), "sims/MIRI_RADec.jld2")
end

# Read the FITS file with AstroImages.AstroImage
img = AstroImage(FITSfile)

# Read the data file into a DataFrame
columnsToRead = 1:37

df = CSV.read(joinpath(datadir(), "exp_raw/Archive_MIRI_Ocen_dolphot/omega_cen_phot_miri"), DataFrame; header=false, delim=" ", ignorerepeated = true, select = columnsToRead)




# Extract the x and y columns
x = df[:, :Column3]
y = df[:, :Column4]

# Stack x and y into a 2×N array where each column is a coordinate pair
pixcoords = vcat(x', y')  # Transpose and vertical concatenation because the pix_to_world function expects the coordinates in a specific array format where each column represents a coordinate pair.

#= To see the WCS transformation from AstroImages, you could do:
wcs(img)
=#

# Translate the x and y columns into degrees
raDec = pix_to_world(img, pixcoords)
raDec = raDec'  # Transpose the result to get a 2×N array where one column is the RA and the other is the Dec

# columns to keep in the output DataFrame: 3, 4, 6, 7, 8, 10, 11, 16, 20, 21, 22, 23, 24, 29

# Write the selected columns and translated coordinates to a JLD2 file

# Create output DataFrame
newColumnGroup = DataFrame(
    x = df[:, 3],
    y = df[:, 4],
    ra = raDec[:, 1],
    dec = raDec[:, 2],
    col6 = df[:, 6],
    col7 = df[:, 7],
    col8 = df[:, 8],
    col10 = df[:, 10],
    col11 = df[:, 11],
    col16 = df[:, 16],
    col20 = df[:, 20],
    col21 = df[:, 21],
    col22 = df[:, 22],
    col23 = df[:, 23],
    col24 = df[:, 24],
    col29 = df[:, 29]
)

# Save to JLD2 file (semicolon is key)
jldsave(datadir("exp_pro/transformed_coordinates.jld2"); newColumnGroup)

# jldopen("transformed_coordinates.jld2"), for testing
# For testing the saved data with full precision display:
io = IOContext(stdout, :limit=>false, :compact=>false)
show(io, MIME("text/plain"), df[1:3, [:ra, :dec]])