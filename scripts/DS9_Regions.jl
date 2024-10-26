"""
26 October 2024)
Cab assume `DS9_start` has run (and so the project has been activated), the ds9 window is open, and the image is loaded with the default settings.  But if that's not the case, it will srun DS9_start.jl to get everything set up.

Taken from `P24a_Brightest.jl``
"""

if !@isdefined(sao) # wimpy 
	startPath = joinpath(homedir(), "Gitted/OlegIMBH/scripts/DS9_start.jl")
	include(startPath)
end

using CSV
using DataFrames
using Random
include(srcdir("writeDS9RegFile.jl"))
include(srcdir("verifyRegFileSent.jl"))

# Read and process the data once
columnsToRead = 1:37
df = CSV.read(joinpath(datadir(), "exp_raw/OmegaCen/omega_cen_phot"), DataFrame; header=false, delim=" ", ignorerepeated = true, select = columnsToRead)

objectType = ["bright star", "faint star ", "elongated  ", "hot pixel  ", "extended   "] # Column 11
for i in eachindex(objectType)
    println("$i (", objectType[i], "): ", length(findall(x -> x == i, df.Column11)))
end

bright_ind = findall(x -> x == 1, df.Column11)

# 16. Instrumental VEGAMAG magnitude, NIRCAM_F200W
# 29. Instrumental VEGAMAG magnitude, NIRCAM_F444W
bright16 = df[!, :Column16][bright_ind]
bright29 = df[!, :Column29][bright_ind]

bright_SNR = df.Column6[bright_ind]
bright_Crowding = df.Column10[bright_ind]
bright_SharpSq = df.Column7[bright_ind].^2
bright_Q200_flag = df.Column24[bright_ind]
bright_Q444_flag = df.Column37[bright_ind]

# Filter out indices where the value in bright16 or bright29 is 99.999
bright_good_ind = filter(i -> bright16[i] != 99.999 && bright29[i] != 99.999, 1:length(bright16))

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
        sorted16_indices = sortperm(bright16_good)
        sorted29_indices = sortperm(bright29_good)

        brightest10_16 = bright16_good[sorted16_indices][1:nBrightest]
        brightest10_29 = bright29_good[sorted29_indices][1:nBrightest]
        brightest10_16_Xvalues = df.Column3[bright_ind][bright_good_ind][findall(x -> x in brightest10_16, bright16_good)]
        brightest10_16_Yvalues = df.Column4[bright_ind][bright_good_ind][findall(x -> x in brightest10_16, bright16_good)]
        brightest10_29_Xvalues = df.Column3[bright_ind][bright_good_ind][findall(x -> x in brightest10_29, bright29_good)]
        brightest10_29_Yvalues = df.Column4[bright_ind][bright_good_ind][findall(x -> x in brightest10_29, bright29_good)]
    end

    return brightest10_16_Xvalues, brightest10_16_Yvalues, brightest10_29_Xvalues, brightest10_29_Yvalues
end

# Example usage
randBright = true  # Set this to true for random selection, false for sorted selection
nBrightest = 30

# Could put these lines in a function, too, to call from the REPL.
# Generate values
brightest10_16_Xvalues, brightest10_16_Yvalues, brightest10_29_Xvalues, brightest10_29_Yvalues = generate_values(randBright, nBrightest)

regFile_1 = DS9_writeRegionFile(brightest10_16_Xvalues, brightest10_16_Yvalues, 25, "F200"; color = "green")
regFile_2 = DS9_writeRegionFile(brightest10_29_Xvalues, brightest10_29_Yvalues, 25, "F444"; color = "red")

# Delete all regions before sending new ones
sao.set("regions", "delete all")
# println("All regions deleted successfully.")
DS9_SendRegAndVerify(regFile_1)
DS9_SendRegAndVerify(regFile_2)