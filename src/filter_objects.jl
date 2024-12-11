"""
    dfc 20 November 2024
	- taken from DS9Regions.jl
		- added `col_map` parameter to allow for column name mapping so that it can be used both with its original script, `DS9Regions.jl`, and with MatchCoords.jl.  Note that the default parameter is set blank so that the longish dictionary can be assigned inside the function.
	- DrWatson guide: "If upon include("file.jl") there is anything being produced, be it data files, plots or even output to the console, then it should be in scripts."
"""
function filter_objects(
    df::DataFrame, 
    params::ChoiceParams;
    col_map::AbstractDict{Symbol,Symbol}=Dict{Symbol,Symbol}()
)

    # Define defaults inside function
    default_cols = Dict(
        :Column11 => :Column11,  # Object type
        :Column16 => :Column16,  # Magnitude
        :Column29 => :Column29,  # Another magnitude
        :Column6 => :Column6,    # SNR
        :Column10 => :Column10,  # Crowding
        :Column7 => :Column7,    # Sharp
        :Column24 => :Column24,  # qWL1 flag
        :Column37 => :Column37   # qWL2 flag
    )

    # Merge with any provided mappings
    cols = merge(default_cols, col_map)

	# Find indices of rows matching object type
	# bright_ind = findall(x -> x == params.obTyn, df.Column11)

	# Extract values for selected bright objects
	# 16. Instrumental VEGAMAG magnitude, NIRCam_F200W

    # Use mapped column names
    bright_ind = findall(x -> x == params.obTyn, df[!, cols[:Column11]])

	bright16 = df[bright_ind, cols[:Column16]] 
	bright29 = df[bright_ind, cols[:Column29]] 

	bright_SNR = df[bright_ind, cols[:Column6]]
	bright_Crowding = df[bright_ind, cols[:Column10]]
	bright_SharpSq = df[bright_ind, cols[:Column7]].^2
	bright_qWL1_flag = df[bright_ind, cols[:Column24]]
	bright_qWL2_flag = df[bright_ind, cols[:Column37]]

    # Based on grossLim flag, define dictionaries with numerical limits for each parameter

    limits = if params.grossLim
        Dict(
            "SNR" => 4,
            "Crowding" => 2.25,
            "SharpSq" => 0.1,
            "qWL1_flag" => 3,
            "qWL2_flag" => 3
        )
    else
        Dict(
            "SNR" => 5,
            "Crowding" => 0.5,
            "SharpSq" => 0.01,
            "qWL1_flag" => 3,
            "qWL2_flag" => 3
        )
    end

    # Find indices meeting all criteria
    bright_good_ind = findall(i -> bright_SNR[i] >= limits["SNR"] &&
                                  bright_Crowding[i] <= limits["Crowding"] &&
                                  bright_SharpSq[i] <= limits["SharpSq"] &&
                                  bright_qWL1_flag[i] <= limits["qWL1_flag"] &&
                                  bright_qWL2_flag[i] <= limits["qWL2_flag"], 
                                  eachindex(bright_ind))

    printstyled("\nwith 99.999: $(length(bright_good_ind)) under $(params.grossLim ? "gross limits" : "stringent limits")\n", color = :cyan)

    # Handle 99.999 values, i.e., filter out indices where the value in bright16 or bright29 is 99.999
    if !params.inc99s
		# Before filtering
		println("Before filter - 99.999 counts:")
		println("bright16: ", count(x -> x == 99.999, bright16[bright_good_ind]))
		println("bright29: ", count(x -> x == 99.999, bright29[bright_good_ind]))

		bright_good_ind = bright_good_ind[filter(i -> !(df[bright_good_ind[i], cols[:Column16]] == 99.999 || df[bright_good_ind[i], cols[:Column29]] == 99.999), eachindex(bright_good_ind))]
        printstyled("without 99.999: $(length(bright_good_ind))\n", color = :magenta)
    end
    if params.onl99s && params.inc99s
		bright_good_ind = bright_good_ind[filter(i -> bright16[bright_good_ind[i]] == 99.999 && bright29[bright_good_ind[i]] == 99.999, eachindex(bright_good_ind))]
        printstyled("only 99.999: $(length(bright_good_ind))\n", color = :cyan)
    end

    return (bright_good_ind, bright16, bright29, bright_ind)
end