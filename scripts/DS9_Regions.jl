"""
26 October 2024
If DS9 not running, will open a new one.

Taken originally from `P24a_Brightest.jl`

15 November 2024
Jazzed up.  Now can handle either NIRCAM or MIRI, killing the earlier version that was specific to one or the other when the instrument is changed.  Of course, could also modify it to handle both at once using two frames.
"""

include(joinpath(homedir(), "Gitted/OlegIMBH/src/introRegions.jl"))
# If not already defined, initialize the global variable to track the current DS9 instrument name to empty string
if !@isdefined(current_ds9_instrument)
    global current_ds9_instrument = ""
end

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
params = ChoiceParams(1, 1, false, false, false, 1, 31, false)

instrument, objectTypeIndex, include99s, only99s, randBright, nStart, nBrightest, gross_limits = choices(params)

# Read and process the data once
columnsToRead = 1:37
# Track current instrument state (no need to initialize)
global current_df_instrument

# Function to check and read DataFrame if needed
function get_df(instrument)
    global df, current_df_instrument
    local FITSfile  # Declare FITSfile at function scope
    
    if !@isdefined(df) || current_df_instrument != instrument
        if instrument == "NIRCAM"
            FITSfile = datadir("exp_raw/OmegaCen/jw04343-o002_t001_nircam_clear-f200w_i2d.fits")
            df = CSV.read(joinpath(datadir(), "exp_raw/OmegaCen/omega_cen_phot"), 
                         DataFrame; 
                         header=false, 
                         delim=" ", 
                         ignorerepeated=true, 
                         select=columnsToRead)
        else
            FITSfile = datadir("exp_raw/Archive_MIRI_Ocen_dolphot/jw04343-o001_t001_miri_f770w_i2d.fits")
            df = CSV.read(joinpath(datadir(), "exp_raw/Archive_MIRI_Ocen_dolphot/omega_cen_phot_miri"), 
                         DataFrame; 
                         header=false, 
                         delim=" ", 
                         ignorerepeated=true, 
                         select=columnsToRead)
        end
        current_df_instrument = instrument
    else
        # Set FITSfile even when not reading new data
        FITSfile = 
		if instrument == "NIRCAM"
            datadir("exp_raw/OmegaCen/jw04343-o002_t001_nircam_clear-f200w_i2d.fits")
        else
            datadir("exp_raw/Archive_MIRI_Ocen_dolphot/jw04343-o001_t001_miri_f770w_i2d.fits")
        end
    end
    return FITSfile
end
FITSfile = get_df(instrument)
connectDS9(FITSfile, instrument)


objectType = ["bright star", "faint      ", "elongated  ", "hot pixel  ", "extended   "] # Column 11
for i in eachindex(objectType)
    println("$i (", objectType[i], "): ", length(findall(x -> x == i, df.Column11)))
end

bright_ind = findall(x -> x == objectTypeIndex, df.Column11)

# 16. Instrumental VEGAMAG magnitude, NIRCAM_F200W
# 29. Instrumental VEGAMAG magnitude, NIRCAM_F444W
bright16 = df[!, :Column16][bright_ind]
bright29 = df[!, :Column29][bright_ind]

bright_SNR = df.Column6[bright_ind]
bright_Crowding = df.Column10[bright_ind]
bright_SharpSq = df.Column7[bright_ind].^2
bright_Q200_flag = df.Column24[bright_ind]
bright_Q444_flag = df.Column37[bright_ind]

# Define dictionaries with numerical limits

limits = if gross_limits
    Dict(
        "SNR" => 4,
        "Crowding" => 2.25,
        "SharpSq" => 0.1,
        "Q200_flag" => 3,
        "Q444_flag" => 3
    )
else
    Dict(
        "SNR" => 5,
        "Crowding" => 0.5,
        "SharpSq" => 0.01,
        "Q200_flag" => 3,
        "Q444_flag" => 3
    )
end

bright_good_ind = findall(i -> bright_SNR[i] >= limits["SNR"] &&
                               bright_Crowding[i] <= limits["Crowding"] &&
                               bright_SharpSq[i] <= limits["SharpSq"] &&
                               bright_Q200_flag[i] <= limits["Q200_flag"] &&
                               bright_Q444_flag[i] <= limits["Q444_flag"], eachindex(bright_ind))

print("\nwith 99.999: $(length(bright_good_ind)) under ")
if gross_limits println("gross limits\n") else println("stringent limits") end

# Filter out indices where the value in bright16 or bright29 is 99.999
if !include99s
    bright_good_ind = filter(i -> bright16[i] != 99.999 && bright29[i] != 99.999, eachindex(bright_good_ind))
    println("without 99.999: $(length(bright_good_ind))\n")
end
if only99s && include99s
    bright_good_ind = filter(i -> bright16[i] == 99.999 || bright29[i] == 99.999, eachindex(bright_good_ind))
    println("only 99.999: $(length(bright_good_ind))\n")
end

# Function to generate random or sorted values
function generate_values(randBright::Bool, nBrightest::Int)
    bright16_good = bright16[bright_good_ind]
    bright29_good = bright29[bright_good_ind]

    if randBright
        # Generate random indices
        random_indices_16 = rand(1:length(bright16_good), nBrightest)
        random_indices_29 = rand(1:length(bright29_good), nBrightest)

        brightest10_16 = bright16_good[random_indices_16]
        brightest10_29 = bright29_good[random_indices_29]
        brightest10_16_Xvalues = df.Column3[bright_ind][bright_good_ind][random_indices_16]
        brightest10_16_Yvalues = df.Column4[bright_ind][bright_good_ind][random_indices_16]
        brightest10_29_Xvalues = df.Column3[bright_ind][bright_good_ind][random_indices_29]
        brightest10_29_Yvalues = df.Column4[bright_ind][bright_good_ind][random_indices_29]
    else
        # Sort by value
		if objectTypeIndex == 2
            sorted16_indices = sortperm(bright16_good, rev=true)
            sorted29_indices = sortperm(bright29_good, rev=true)
        else
            sorted16_indices = sortperm(bright16_good)
            sorted29_indices = sortperm(bright29_good)
        end
		nFinish = nStart - 1 + nBrightest
        brightest10_16 = bright16_good[sorted16_indices][nStart: nFinish]
        brightest10_29 = bright29_good[sorted29_indices][nStart: nFinish]
        brightest10_16_Xvalues = df.Column3[bright_ind][bright_good_ind][findall(x -> x in brightest10_16, bright16_good)]
        brightest10_16_Yvalues = df.Column4[bright_ind][bright_good_ind][findall(x -> x in brightest10_16, bright16_good)]
        brightest10_29_Xvalues = df.Column3[bright_ind][bright_good_ind][findall(x -> x in brightest10_29, bright29_good)]
        brightest10_29_Yvalues = df.Column4[bright_ind][bright_good_ind][findall(x -> x in brightest10_29, bright29_good)]
    end

    return brightest10_16_Xvalues, brightest10_16_Yvalues, brightest10_29_Xvalues, brightest10_29_Yvalues
end

# Could put these lines in a function, too, to call from the REPL.
# Generate values
selected_16_Xvalues, selected_16_Yvalues, selected_29_Xvalues, selected_29_Yvalues = generate_values(randBright, nBrightest)

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