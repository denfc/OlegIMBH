# Function to generate random or sorted values
function generate_values(filtered_data, randBright::Bool, nBrightest::Int, nStart::Int, objectTypeIndex::Int)
    bright16_good = filtered_data.bright16[filtered_data.good_indices]
    bright29_good = filtered_data.bright29[filtered_data.good_indices]

    if randBright
        # Generate random indices
        random_indices_16 = rand(1:length(bright16_good), nBrightest)
        random_indices_29 = rand(1:length(bright29_good), nBrightest)

        brightestetN_16 = bright16_good[random_indices_16]
        brightestetN_29 = bright29_good[random_indices_29]
        brightestetN_16_Xvalues = df.Column3[bright_ind][bright_good_ind][random_indices_16]
        brightestetN_16_Yvalues = df.Column4[bright_ind][bright_good_ind][random_indices_16]
        brightestetN_29_Xvalues = df.Column3[bright_ind][bright_good_ind][random_indices_29]
        brightestetN_29_Yvalues = df.Column4[bright_ind][bright_good_ind][random_indices_29]
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
        brightestetN_16 = bright16_good[sorted16_indices][nStart: nFinish]
        brightestetN_29 = bright29_good[sorted29_indices][nStart: nFinish]
        brightestetN_16_Xvalues = df.Column3[bright_ind][bright_good_ind][findall(x -> x in brightestetN_16, bright16_good)]
        brightestetN_16_Yvalues = df.Column4[bright_ind][bright_good_ind][findall(x -> x in brightestetN_16, bright16_good)]
        brightestetN_29_Xvalues = df.Column3[bright_ind][bright_good_ind][findall(x -> x in brightestetN_29, bright29_good)]
        brightestetN_29_Yvalues = df.Column4[bright_ind][bright_good_ind][findall(x -> x in brightestetN_29, bright29_good)]
    end

    return brightestetN_16_Xvalues, brightestetN_16_Yvalues, brightestetN_29_Xvalues, brightestetN_29_Yvalues
end