"""
dfc 19 November 2023 -- selection stuff taken from DS9Regions, but it wouldn't have worked here as written because of column name changes, but we changed `filter_objects` cleverly to handle both, and now we can use this script to select objects for matching.
"""
const THRESHOLD_ARCSEC = 0.018 # 0.2 # 0.06  # 0.018  # 0.011499064327948718 ? seemed to be the gcirc distance, but now it's 0.017? NOT UNDERSTANDING 'CAUSE NOW AGAIN FIDING 0.0114 ...!
# NIRCam's resolution is 0.031 arcseconds per pixel
# but see email from Oleg (0.2 in Dec, less in RA)
const THRESHOLD_DEG = THRESHOLD_ARCSEC/3600.0 
global INSTRUMENTS = ["NIRCam", "MIRI"]
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
params = ChoiceParams(1, 1, false, false, false, 1, 77
, false)
dump(params)

include(joinpath(homedir(), "Gitted/OlegIMBH/src/introMatch.jl"))
dfMIRI = jldopen(joinpath(datadir("exp_pro/MIRI_RADec.jld2")))["newColumnGroup"]
dfNIRCam = jldopen(joinpath(datadir("exp_pro/NIRCam_RADec.jld2")))["newColumnGroup"]

# # If not already defined, initialize the global variable to track the current DS9 instrument name to empty string
# if !@isdefined(current_ds9_instrument)
#     global current_ds9_instrument = ""
# end

instrument, objectTypeIndex, include99s, only99s, randBright, nStart, nBrightest, gross_limits = choices(params)

miri_col_map = Dict{Symbol,Symbol}(
	:Column11 => :obType,
    :Column16 => :mag770,
    :Column29 => :mag1500,
    :Column6 => :SNR,
    :Column10 => :crowd,
    :Column7 => :sharp,
    :Column24 => :Qual770,
    :Column37 => :Qual1500
	)

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
        :Column3 => :ra,  # Object type
        :Column4 => :dec,  # Magnitude
    )

	objectType = ["bright star", "faint      ", "elongated  ", "hot pixel  ", "extended   "] # Column 11
	printstyled("MIRI\n", color = :light_cyan)
	for i in eachindex(objectType)
		println("$i (", objectType[i], "): ", length(findall(x -> x == i, dfMIRI.obType)))
	end
	printstyled("\nNIRCam\n", color = :light_cyan)
	for i in eachindex(objectType)
		println("$i (", objectType[i], "): ", length(findall(x -> x == i, dfNIRCam.obType)))
	end
	
	filtered_data_MIRI = filter_objects(dfMIRI, params; col_map=miri_col_map)
	filtered_data_NIRCam = filter_objects(dfNIRCam, params; col_map=nircam_col_map)

# Generate values using the filtered data
if instrument == "MIRI" 
	selected_XYvalues = generate_XYvalues(filtered_data_MIRI, dfMIRI, params.randB, params.nB, params.nStrt, params.obTyn; col_map=XY_col_map)

	bright_good_ind, bright16, bright29, bright_ind = filtered_data_MIRI
else 
	selected_XYvalues = generate_XYvalues(filtered_data_NIRCam, dfNIRCam, params.randB, params.nB, params.nStrt, params.obTyn; col_map=XY_col_map) 

	bright_good_ind, bright16, bright29, bright_ind = filtered_data_NIRCam
end

selected_16_Xvalues, selected_16_Yvalues, selected_29_Xvalues, selected_29_Yvalues = selected_XYvalues

ds9String = "$instrument\n"
ds9String *= "$(objectType[objectTypeIndex])\n"
if randBright ds9String *= "$nBrightest random\n" else ds9String *= "$nBrightest sorted\n" end
ds9String *= "includes 99s is $include99s\n"
if include99s && only99s ds9String *= "only 99.999\n" end
ds9String *= "$(length(bright_good_ind)) good\n"
if gross_limits ds9String *= "gross limits" else ds9String *= "stringent limits" end

println()
printstyled("\"$(objectType[objectTypeIndex])\" number= ", length(bright_ind), "; ", color = :light_cyan)
printstyled("number of good ones: ", length(bright_good_ind), "; ", color = :light_cyan)
if randBright printstyled("random selection of ", nBrightest, ".", color = :light_cyan) else printstyled("sorted selection of ", nBrightest, ".", color = :light_cyan) end


# let's match just within MIRI and withing NIRCam to start
# this is Dec RA; want to switch for production run
# j = sortMergeMatch(selected_16_Yvalues, selected_16_Xvalues, selected_29_Yvalues, selected_29_Xvalues)

# DOES IT MATTER?
j = sortMergeMatch(selected_16_Xvalues, selected_16_Yvalues, selected_29_Xvalues, selected_29_Yvalues)

#=
The lines marked with Input 1 and Input 2 report, respectively:

- the number of indices for which a matching pair has been found;
- the total number of elements in input array;
- the fraction of indices for which a matching pair has been found;
- the minimum and maximum multiplicity;
- The last line reports the number of matched pairs in the output.
=# 
# println(j, "\nFollowed by m:")

 #The `subset_with_multiplicity`` function allows to extract the subset of matching entries with a given multiplicity. E.g., to find the matched entries whose index in the first array occurs twice (multiplicity = 2)
 # m = subset_with_multiplicity(j, 1, 2)
 
# m[1] == m[2] == Int64[] # true

# 201.7108045242068 and 201.71079979915106
# 13h 26m 50.6s      

# -47.46737490673237 is -47 deg 28' 02.54'
# gcirc(2, selected_16_Xvalues[24], selected_16_Yvalues[24], selected_29_Xvalues[21], selected_29_Yvalues[21])
# 0.01701020069639246 is the `gcirc` value with all the digits