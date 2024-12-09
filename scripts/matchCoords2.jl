"""
dfc 19 November 2023 -- selection stuff taken from DS9Regions, but it wouldn't have worked here as written because of column name changes, but we changed `filter_objects` cleverly to handle both, and now we can use this script to select objects for matching.
dfc 27 November 2024 -- version 2 will do what we thought of originally, comparing MIRI to NIRCAM
"""

const THRESHOLD_ARCSEC = 0.5 #0.5 # 0.2 # 0.06  # 0.018 
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

# `choices.jl`, called in intro, below, needs the above struct
include(joinpath(homedir(), "Gitted/OlegIMBH/src/introMatch.jl"))

nMIRI_STRINGENT = 10877  # numbers obtained by hand 
nNIRCam_STRINGENT = 100479

paramsMIRI = ChoiceParams(1, 1, false, false, false, 1, nMIRI_STRINGENT, false) # under "stringent" limits, 10023 is all the good MIRI objects at "false, false, false"
printstyled("`paramsMIRI`\n", color = :light_cyan)
instrument, objectTypeIndex, include99s, only99s, randBright, nStart, nBrightest, gross_limits = choices(paramsMIRI)
dump(paramsMIRI)
println()
dfMIRI = jldopen(joinpath(datadir("exp_pro/MIRI_RADec.jld2")))["newColumnGroup"]
# dfNIRCam = jldopen(joinpath(datadir("exp_pro/NIRCam_RADec.jld2")))["newColumnGroup"]
# dfNIRCamLimited = dfNIRCam
# paramsAllNIRCLimited = ChoiceParams(1, 1, false, false, false, 1, 108588, false)
dfNIRCamLimited = jldopen(joinpath(datadir("exp_pro/NIRCamLimited.jld2")))["dfNIRClimited"]
paramsAllNIRCLimited = ChoiceParams(1, 1, false, false, false, 1, nNIRCam_STRINGENT, false) # under "stringent" limits, 99377 is all the good NIRCam objects at "false, false, false"


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
        :Column3 => :ra,
        :Column4 => :dec,
    )

	objectType = ["bright star", "faint      ", "elongated  ", "hot pixel  ", "extended   "] # Column 11
	
	printstyled("MIRI\n", color = :light_cyan)
	for i in eachindex(objectType)
		println("$i (", objectType[i], "): ", length(findall(x -> x == i, dfMIRI.obType)))
	end
	
	printstyled("\nNIRCamLimited\n", color = :light_cyan)
	for i in eachindex(objectType)
		println("$i (", objectType[i], "): ", length(findall(x -> x == i, dfNIRCamLimited.obType)))
	end
	
	print("\nMIRI filtering")
	filtered_data_MIRI = filter_objects(dfMIRI, paramsMIRI; col_map=miri_col_map)
	# filtered_data_NIRCam = filter_objects(dfNIRCam, params; col_map=nircam_col_map)
	print("\nNIRCam filtering")
	filtered_data_NIRCam = filter_objects(dfNIRCamLimited, paramsAllNIRCLimited; col_map=nircam_col_map)

	
# Generate values using the filtered data
	selected_XYvaluesMIRI = generate_XYvalues(filtered_data_MIRI, dfMIRI; col_map=XY_col_map)
	selected_16_XvaluesMIRI, selected_16_YvaluesMIRI, selected_29_XvaluesMIRI, selected_29_YvaluesMIRI = selected_XYvaluesMIRI
	bright_good_indMIRI, bright16MIRI, bright29MIRI, bright_indMIRI = filtered_data_MIRI

	selected_XYvaluesNIRC = generate_XYvalues(filtered_data_NIRCam, dfNIRCamLimited; col_map=XY_col_map) 
	bright_good_indNIRC, bright16NIRC, bright29NIRC, bright_indNIRC = filtered_data_NIRCam
	selected_16_XvaluesNIRC, selected_16_YvaluesNIRC, selected_29_XvaluesNIRC, selected_29_YvaluesNIRC = selected_XYvaluesNIRC

#= `ds9String` created for printing to DS9 regions file, so not used here (yet?)
ds9String = "$instrument\n"
ds9String *= "$(objectType[objectTypeIndex])\n"
if randBright ds9String *= "$nBrightest random\n" else ds9String *= "$nBrightest sorted\n" end
ds9String *= "includes 99s is $include99s\n"
if include99s && only99s ds9String *= "only 99.999\n" end
ds9String *= "$(length(bright_good_indMIRI)) good\n"
if gross_limits ds9String *= "gross limits" else ds9String *= "stringent limits" end
=#

println()
printstyled("\"$(objectType[objectTypeIndex])\" number= ", length(bright_indMIRI), "; ", color = :light_cyan)
printstyled("number of good ones: ", length(bright_good_indMIRI), "; ", color = :light_cyan)
if randBright printstyled("random selection of ", nBrightest, ".", color = :light_cyan) else printstyled("sorted selection of ", nBrightest, ".", color = :light_cyan) end

# NOTE WELL: COULD MODIFY TO TAKE INFO FROM DATA FRAMES DIRECTLY; see https://github.com/gcalderone/SortMerge.jl?tab=readme-ov-file

# let's match just within MIRI and within NIRCam to start
# this is Dec RA, as desired; may want to switch XY for production run (Y is indeed declination, X is RA)


function get_coord_pair(selection::Int)
    # Dictionary for pairing names
    pair_names = Dict{Int, String}(
        1 => "MIRI_770, NIRCam_444",
        2 => "MIRI_1500, NIRCam_200", 
        3 => "MIRI_1500, MIRI_770",
        4 => "NIRCam_444, NIRCam_200"
    )

    pairs = Dict{Int, Tuple{Matrix{Float64}, Matrix{Float64}}}(
        1 => ([selected_16_YvaluesMIRI selected_16_XvaluesMIRI],
              [selected_29_YvaluesNIRC selected_29_XvaluesNIRC]),
        2 => ([selected_29_YvaluesMIRI selected_29_XvaluesMIRI],
              [selected_16_YvaluesNIRC selected_16_XvaluesNIRC]),
        3 => ([selected_29_YvaluesMIRI selected_29_XvaluesMIRI],
              [selected_16_YvaluesMIRI selected_16_XvaluesMIRI]),
        4 => ([selected_29_YvaluesNIRC selected_29_XvaluesNIRC],
              [selected_16_YvaluesNIRC selected_16_XvaluesNIRC])
    )
    
    @assert 1 <= selection <= 4 "Selection must be between 1 and 4"
    println("\nSelected pair: $(pair_names[selection])")
    return pairs[selection], pair_names[selection]
end

# `A`, `B`, So can copy examples from https://github.com/gcalderone/SortMerge.jl?tab=readme-ov-file
(A, B), pairNames = get_coord_pair(1)  # Will print "Selected pair: MIRI16_NIRC29"


# A = [selected_16_YvaluesMIRI selected_16_XvaluesMIRI] # [dec ra]
# B = [selected_29_YvaluesNIRC selected_29_XvaluesNIRC]
# A = [selected_29_YvaluesMIRI selected_29_XvaluesMIRI] # [dec ra]
# B = [selected_16_YvaluesNIRC selected_16_XvaluesNIRC]
# A = [selected_29_YvaluesMIRI selected_29_XvaluesMIRI] # [dec ra]
# B = [selected_16_YvaluesMIRI selected_16_XvaluesMIRI]
# A = [selected_29_YvaluesNIRC selected_29_XvaluesNIRC] # [dec ra]
# B = [selected_16_YvaluesNIRC selected_16_XvaluesNIRC]

# j = sortMergeMatch(selected_16_YvaluesMIRI, selected_16_XvaluesMIRI, selected_29_YvaluesNIRC, selected_29_XvaluesNIRC)
# j = sortMergeMatch(A, B)
j, nearM = sortMergeMatch(A, B)

# Define the distance selection dictionary
distanceBetween = Dict(
    "overall" => 3,
    "RA" => 4,
    "Dec" => 5
)

# Choose which distance to plot
distance_type = "Dec"

# Modify the histogram line to use the dictionary
ds = map(x -> x[distanceBetween[distance_type]], nearM)

twoWLs = split(pairNames, ", ")
# Create histogram with dynamic xlabel
histogram(ds,
	# bins = 20,  # or specify exact edges: bins = range(0, THRESHOLD_ARCSEC, length=51)
	bins = range(0, THRESHOLD_ARCSEC, length=26), # 51),
    xlabel = "$distance_type distance in arcseconds",
    label = "$(length(ds)) matches out of $(length(selected_16_YvaluesMIRI)) MIRI points\nat threshold distance of $THRESHOLD_ARCSEC", 
    legend = :topleft, 
    title = "$(twoWLs[2]) matched to $(twoWLs[1])", #"MIRI 770 matched to MIRI 1500", #"NIRCam 200 matched to MIRI 1500", #NIRCam 444 matched to MIRI 770", 
    xlims = (0.0, THRESHOLD_ARCSEC),
	)
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

# histogram(dfMIRI[bright_good_indMIRI, :mag1500])
# histogram!(dfNIRCamLimited[bright_good_indNIRC, :mag444])
# histogram!(dfMIRI[bright_good_indMIRI, :mag770])
# histogram!(dfNIRCamLimited[bright_good_indNIRC, :mag200])

# four MAGNITUDE HISTOGRAMS below generated and saved by hand
#=
titleMIRI = "log brightness ratio = 2/5(MIRI 1500 - MIRI 770)"
titleNIRC = "log brightness ratio = 2/5(NIRCam 444 - NIRCam 200)"
labelMIRI = "$nMIRI_STRINGENT 'stringent'\nno 99s"
labelNIRC = "$nNIRCam_STRINGENT 'stringent'\nno 99s"
=#

# histogram(0.4*(dfMIRI[bright_good_indMIRI, :mag1500] - dfMIRI[bright_good_indMIRI, :mag770]), label=labelMIRI, title=titleMIRI)
# histogram(0.4*(dfMIRI[bright_good_indMIRI, :mag1500] - dfMIRI[bright_good_indMIRI, :mag770]), label=labelMIRI, title=titleMIRI, ylims=(0, 10))
# histogram(0.4*(dfNIRCamLimited[bright_good_indNIRC, :mag444] - dfNIRCamLimited[bright_good_indNIRC, :mag200]), label=labelNIRC, title=titleNIRC)
# histogram(0.4*(dfNIRCamLimited[bright_good_indNIRC, :mag444] - dfNIRCamLimited[bright_good_indNIRC, :mag200]), label=labelNIRC, title=titleNIRC, ylims=(0, 10))