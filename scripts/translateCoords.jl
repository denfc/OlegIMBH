"""
	- dfc 16 November 2024 a mess below, but the ingredients, some duplicated, are there
	- dfc 18 Nov; rethinking: will now just use this code once to gerate the two files and then will operate the filters with them.
"""

include(joinpath(homedir(), "Gitted/OlegIMBH/src/introTranslate.jl"))
global INSTRUMENTS = ["NIRCAM", "MIRI"]
instrument = INSTRUMENTS[1]

# Read the data file into a DataFrame
columnsToRead = 1:37
if instrument == "NIRCAM"
	firstWL = "200"
	secondWL = "444"
	FITSfile = datadir("exp_raw/OmegaCen/jw04343-o002_t001_nircam_clear-f200w_i2d.fits")
	data_file = joinpath(datadir(), "exp_raw/OmegaCen/omega_cen_phot")
	output_file = joinpath(datadir(), "exp_pro/NIRCAM_RADec.jld2")
else
	firstWL = "770"
	secondWL = "1500"
	FITSfile = datadir("exp_raw/Archive_MIRI_Ocen_dolphot/jw04343-o001_t001_miri_f770w_i2d.fits")
	data_file = joinpath(datadir(), "exp_raw/Archive_MIRI_Ocen_dolphot/omega_cen_phot_miri")
	output_file = joinpath(datadir(), "exp_pro/MIRI_RADec.jld2")
end

# Read the FITS file with AstroImages.AstroImage
img = AstroImage(FITSfile)

df = CSV.read(data_file,
	DataFrame;
	header=false,
	delim=" ",
	ignorerepeated = true,
	select = columnsToRead
	)

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

# columns to keep in the output DataFrame: 3, 4, 6, 7, 8, 10, 11, 16, 20, 21, 22, 23, 24, 29, 33, 34, 35, 36, 37

# Write the selected columns and translated coordinates to a JLD2 file

# First create the dynamic column name
magCol1 = Symbol("mag" * firstWL)
SNRCol1 = Symbol("SNR" * firstWL)
sharpCol1 = Symbol("sharp" * firstWL)
roundCol1 = Symbol("round" * firstWL)
crowdCol1 = Symbol("crowd" * firstWL)
QualCol1 = Symbol("Qual" * firstWL)
magCol2 = Symbol("mag" * secondWL)
SNRCol2 = Symbol("SNR" * secondWL)
sharpCol2 = Symbol("sharp" * secondWL)
roundCol2 = Symbol("round" * secondWL)
crowdCol2 = Symbol("crowd" * secondWL)
QualCol2 = Symbol("Qual" * secondWL)

# Create a dictionary with all columns
columns = OrderedDict(
    :x => df[:, 3],
    :y => df[:, 4],
    :ra => raDec[:, 1],
    :dec => raDec[:, 2],
    :SNR => df[:, 6],
    :sharp => df[:, 7],
    :round => df[:, 8],
    :crowd => df[:, 10],
    :obType => df[:, 11],
    magCol1 => df[:, 16],
    SNRCol1 => df[:, 20],
    sharpCol1 => df[:, 21],
    roundCol1 => df[:, 22],
    crowdCol1 => df[:, 23],
    QualCol1 => df[:, 24],
    magCol2 => df[:, 29],
    SNRCol2 => df[:, 33],
    sharpCol2 => df[:, 34],
    roundCol2 => df[:, 35],
    crowdCol2 => df[:, 36],
    QualCol2 => df[:, 37]
)

# Create the DataFrame from the dictionary; note that if for some reason we want to use DrWatson to combine the two results, we wouldl leave it as a dictionary and use DrWatson.wsave, but then we couldn't use OrderedDict
newColumnGroup = DataFrame(columns)

# Save to JLD2 file (semicolon is key)
jldsave(output_file; newColumnGroup)

# Testing
df = jldopen(output_file)["newColumnGroup"]
# For testing seeing the saved data with full precision display:
io = IOContext(stdout, :limit=>false, :compact=>false)
show(io, MIME("text/plain"), df[1:3, [:ra, :dec]])