"""
26 October 2024)
If DS9 not running, will open a new one.

Taken from `P24a_Brightest.jl``
"""

include(joinpath(homedir(), "Gitted/OlegIMBH/src/intro.jl"))

using CSV
using DataFrames
using Random
include(srcdir("writeDS9RegFile.jl"))
include(srcdir("verifyRegFileSent.jl"))

# Read and process the data once
columnsToRead = 1:37
if !isdefined(Main, :df)
    df = CSV.read(joinpath(datadir(), "exp_raw/OmegaCen/omega_cen_phot"), DataFrame; header=false, delim=" ", ignorerepeated = true, select = columnsToRead)
end

objectType = ["bright star", "faint      ", "elongated  ", "hot pixel  ", "extended   "] # Column 11
for i in eachindex(objectType)
    println("$i (", objectType[i], "): ", length(findall(x -> x == i, df.Column11)))
end

objectTypeIndex = 1
bright_ind = findall(x -> x == objectTypeIndex, df.Column11)
# below: print("\"$(objectType[objectTypeIndex])\" number: ", length(bright_ind), "; ")

# 16. Instrumental VEGAMAG magnitude, NIRCAM_F200W
# 29. Instrumental VEGAMAG magnitude, NIRCAM_F444W
bright16 = df[!, :Column16][bright_ind]
bright29 = df[!, :Column29][bright_ind]

bright_SNR = df.Column6[bright_ind]
bright_Crowding = df.Column10[bright_ind]
bright_SharpSq = df.Column7[bright_ind].^2
bright_Q200_flag = df.Column24[bright_ind]
bright_Q444_flag = df.Column37[bright_ind]

bright_good_ind = findall(i -> bright_SNR[i] >= 4 && bright_Crowding[i] <= 2.25 && bright_SharpSq[i] <= 2.25 && bright_Q200_flag[i] <= 3 && bright_Q444_flag[i] <= 3, 1:length(bright_ind) )

println("\nwith 99.999: $(length(bright_good_ind))")
# Filter out indices where the value in bright16 or bright29 is 99.999
bright_good_ind = filter(i -> bright16[i] != 99.999 && bright29[i] != 99.999, 1:length(bright_good_ind))
# below: println("number of good ones: ", length(bright_good_ind))
println("without 99.999: $(length(bright_good_ind))\n")

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
nBrightest = 250

# Could put these lines in a function, too, to call from the REPL.
# Generate values
selected_16_Xvalues, selected_16_Yvalues, selected_29_Xvalues, selected_29_Yvalues = generate_values(randBright, nBrightest)

if randBright ds9String = "$nBrightest random\n" else ds9String = "$nBrightest sorted\n" end
ds9String = "$(objectType[objectTypeIndex])\n"*ds9String*"$(length(bright_good_ind)) good"

regFile_1 = DS9_writeRegionFile(selected_16_Xvalues, selected_16_Yvalues, 29, "F200"; color = "green")
regFile_2 = DS9_writeRegionFile(selected_29_Xvalues, selected_29_Yvalues, 25, "F444"; color = "red")
regFile_3 = DS9_writeRegionFile(-500, 3500, 75, "text";  text = ds9String) # default font_size = 24 can be changed)

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