function filter_objects(df::DataFrame, params::ChoiceParams)

	# Find indices of rows matching object type
	bright_ind = findall(x -> x == params.obTyn, df.Column11)

	# Extract values for selected bright objects
	# 16. Instrumental VEGAMAG magnitude, NIRCAM_F200W
	bright16 = df[!, :Column16][bright_ind]
	bright29 = df[!, :Column29][bright_ind]

    bright_SNR = df.Column6[bright_ind]
    bright_Crowding = df.Column10[bright_ind]
    bright_SharpSq = df.Column7[bright_ind].^2
    bright_Q200_flag = df.Column24[bright_ind]
    bright_Q444_flag = df.Column37[bright_ind]

    # Based on grossLim flag, define dictionaries with numerical limits for each parameter

    limits = if params.grossLim
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

    # Find indices meeting all criteria
    bright_good_ind = findall(i -> bright_SNR[i] >= limits["SNR"] &&
                                  bright_Crowding[i] <= limits["Crowding"] &&
                                  bright_SharpSq[i] <= limits["SharpSq"] &&
                                  bright_Q200_flag[i] <= limits["Q200_flag"] &&
                                  bright_Q444_flag[i] <= limits["Q444_flag"], 
                                  eachindex(bright_ind))

    println("\nwith 99.999: $(length(bright_good_ind)) under $(params.grossLim ? "gross limits" : "stringent limits")\n")

    # Handle 99.999 values, i.e., filter out indices where the value in bright16 or bright29 is 99.999
    if !params.inc99s
        bright_good_ind = filter(i -> bright16[i] != 99.999 && bright29[i] != 99.999, eachindex(bright_good_ind))
        println("without 99.999: $(length(bright_good_ind))\n")
    end
    if params.onl99s && params.inc99s
        bright_good_ind = filter(i -> bright16[i] == 99.999 || bright29[i] == 99.999, eachindex(bright_good_ind))
        println("only 99.999: $(length(bright_good_ind))\n")
    end

    return (
    bright_good_ind,  # Creates field named 'bright_good_ind'
    bright16,
    bright29,
    df,
    bright_ind
	)
end