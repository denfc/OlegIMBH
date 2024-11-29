
df, FITSfile = get_df(instrument) 
connectDS9(FITSfile, instrument)

objectType = ["bright star", "faint      ", "elongated  ", "hot pixel  ", "extended   "] # Column 11
for i in eachindex(objectType)
    println("$i (", objectType[i], "): ", length(findall(x -> x == i, df.Column11)))
end

# Get filtered data
filtered_data = filter_objects(df, params)
bright_good_ind, bright16, bright29, bright_ind = filtered_data  # Destructure the tuple

# Generate values using the filtered data
selected_XYvalues = generate_XYvalues(filtered_data, df, params.randB, params.nB, params.nStrt, params.obTyn)
selected_16_Xvalues, selected_16_Yvalues, selected_29_Xvalues, selected_29_Yvalues = selected_XYvalues

regFile_1 = DS9_writeRegionFile(selected_16_Xvalues, selected_16_Yvalues, 29, "F200"; color = "green")
regFile_2 = DS9_writeRegionFile(selected_29_Xvalues, selected_29_Yvalues, 25, "F444"; color = "red")
if instrument == "NIRCam" regFile_3 = DS9_writeRegionFile(-500, 3500, 75, "text";  text = ds9String)
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
