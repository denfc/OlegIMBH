"""
dfc 19 November 2023 -- selection stuff taken from DS9Regions
"""

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

include(joinpath(homedir(), "Gitted/OlegIMBH/src/introMatch.jl"))
dfMIRI = jldopen(joinpath(datadir("exp_pro/MIRI_RADec.jld2")))["newColumnGroup"]
dfNIRCAM = jldopen(joinpath(datadir("exp_pro/NIRCAM_RADec.jld2")))["newColumnGroup"]

# If not already defined, initialize the global variable to track the current DS9 instrument name to empty string
if !@isdefined(current_ds9_instrument)
    global current_ds9_instrument = ""
end

instrument, objectTypeIndex, include99s, only99s, randBright, nStart, nBrightest, gross_limits = choices(params)

# Read and process the data once
columnsToRead = 1:37
# Track current instrument state (no need to initialize)
global current_df_instrument

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

println()
printstyled("\"$(objectType[objectTypeIndex])\" number= ", length(bright_ind), "; ", color = :cyan)
printstyled("number of good ones: ", length(bright_good_ind), "; ", color = :cyan)
if randBright printstyled("random selection of ", nBrightest, ".", color = :cyan) else printstyled("sorted selection of ", nBrightest, ".", color = :cyan) end