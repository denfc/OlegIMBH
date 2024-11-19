"""
dfc 19 November 2023 -- taken from DS9Regions
"""

dfMIRI = jldopen(joinpath(datadir("sims/MIRI_RAD


ec.jld2")))["newColumnGroup"]
dfNIRCAM = jldopen(joinpath(datadir("sims/NIRCAM_RADec.jld2")))["newColumnGroup"]


global INSTRUMENTS = ["NIRCAM", "MIRI"]
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
params = ChoiceParams(2, 1, false, true, false, 1, 30, false)

include(joinpath(homedir(), "Gitted/OlegIMBH/src/introCompare.jl"))
using DataFrames
# If not already defined, initialize the global variable to track the current DS9 instrument name to empty string
if !@isdefined(current_ds9_instrument)
    global current_ds9_instrument = ""
end

instrument, objectTypeIndex, include99s, only99s, randBright, nStart, nBrightest, gross_limits = choices(params)

# Read and process the data once
columnsToRead = 1:37
# Track current instrument state (no need to initialize)
global current_df_instrument


FITSfile = get_df(instrument)
connectDS9(FITSfile, instrument)

objectType = ["bright star", "faint      ", "elongated  ", "hot pixel  ", "extended   "] # Column 11
for i in eachindex(objectType)
    println("$i (", objectType[i], "): ", length(findall(x -> x == i, df.Column11)))
end

# Get filtered data
filtered_data = filter_objects(df, params)
bright_good_ind, bright16, bright29, df, bright_ind = filtered_data  # Destructure the tuple

# Generate values using the filtered data
selected_values = generate_values(filtered_data, params.randB, params.nB, params.nStrt, params.obTyn)
selected_16_Xvalues, selected_16_Yvalues, selected_29_Xvalues, selected_29_Yvalues = selected_values


ds9String = "$instrument\n"
ds9String *= "$(objectType[objectTypeIndex])\n"
if randBright ds9String *= "$nBrightest random\n" else ds9String *= "$nBrightest sorted\n" end
ds9String *= "includes 99s is $include99s\n"
if include99s && only99s ds9String *= "only 99.999\n" end
ds9String *= "$(length(bright_good_ind)) good\n"
if gross_limits ds9String *= "gross limits" else ds9String *= "stringent limits" end

regFile_1 = DS9_writeRegionFile(selected_16_Xvalues, selected_16_Yvalues, 29, "F200"; color = "green")
regFile_2 = DS9_writeRegionFile(selected_29_Xvalues, selected_29_Yvalues, 25, "F444"; color = "red")
if instrument == "NIRCAM" regFile_3 = DS9_writeRegionFile(-500, 3500, 75, "text";  text = ds9String)
else regFile_3 = DS9_writeRegionFile(-124, 950, 35, "text";  text = ds9String)
end # default font_size = 24 can be changed)

# Delete all regions before sending new ones
sao.set("regions", "delete all")
# println("All regions deleted successfully.")
# DS9_SendRegAndVerify(regFile_2)
DS9_SendRegAndVerify(regFile_1)
DS9_SendRegAndVerify(regFile_2)
DS9_SendRegAndVerify(regFile_3)

# regFile_test = "/home/dfc123/Gitted/OlegIMBH/data/sims/F444_save.reg"
# DS9_SendRegAndVerify(regFile_test)

println()
printstyled("\"$(objectType[objectTypeIndex])\" number= ", length(bright_ind), "; ", color = :cyan)
printstyled("number of good ones: ", length(bright_good_ind), "; ", color = :cyan)
if randBright printstyled("random selection of ", nBrightest, ".", color = :cyan) else printstyled("sorted selection of ", nBrightest, ".", color = :cyan) end