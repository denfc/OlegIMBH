# include(srcdir("introRegions.jl"))
using JLD2
df = jldopen(joinpath(datadir("exp_pro/NIRCamLimited.jld2")))["dfNIRClimited"]


objectType = ["bright star", "faint      ", "elongated  ", "hot pixel  ", "extended   "] # Column 11
for i in eachindex(objectType)
    println("$i (", objectType[i], "): ", length(findall(x -> x == i, df.obType)))
end

nircam_col_map = Dict{Symbol,Symbol}(
	:Column11 => :obType,
	:Column16 => :mag200,
	:Column29 => :mag444,
	:Column6 => :SNR,
	:Column10 => :crowd,
	:Column7 => :sharp,
	:Column24 => :Qual200,
	:Column37 => :Qual444
	)

    XY_col_map = Dict(
        :Column3 => :xMIRI,
        :Column4 => :yMIRI,
    )
# Get filtered data
filtered_data = filter_objects(df, params; col_map=nircam_col_map)
bright_good_ind, bright16, bright29, bright_ind = filtered_data  # Destructure the tuple

# Generate values using the filtered data
selected_XYvalues = generate_XYvalues(filtered_data, df; col_map=XY_col_map)
selected_16_Xvalues, selected_16_Yvalues, selected_29_Xvalues, selected_29_Yvalues = selected_XYvalues

regFile_1 = DS9_writeRegionFile(selected_16_Xvalues, selected_16_Yvalues, 19, "F200Lim"; color = "cyan")
regFile_2 = DS9_writeRegionFile(selected_29_Xvalues, selected_29_Yvalues, 15, "F444Lim"; color = "orange")

# DS9_SendRegAndVerify(regFile_2)
DS9_SendRegAndVerify(regFile_1)
DS9_SendRegAndVerify(regFile_2)
# DS9_SendRegAndVerify(regFile_3)