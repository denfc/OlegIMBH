"""
dfc 20 November 2024, taken from script `SortMerge.jl`
	  
    - called from matchCoords and matchCoords2
"""
#function sortMergeMatch(lat1, long1, lat2, long2)
function sortMergeMatch(raDec_1, raDec_2)
	# using SortMerge
	# using AstroLib

	lt(v, i, j) = (v[i, 2] < v[j, 2])
	# function sd(v1, v2, i1, i2, threshold_arcsec) # original
	function sd(v1, v2, i1, i2)
		# threshold_deg = threshold_arcsec / 3600. # [deg]
		# d = (v1[i1, 2] - v2[i2, 2]) / threshold_deg
		d = (v1[i1, 2] - v2[i2, 2]) / THRESHOLD_DEG
	#bprintstyled("$d  $(v1[i1, 2])  $(v2[i2, 2])\n", color=:red)
		(abs(d) >= 1)  &&  (return sign(d))
		dd = gcirc(2, v1[i1, 1], v1[i1, 2], v2[i2, 1], v2[i2, 2])
		(dd < THRESHOLD_ARCSEC)  &&  (return 0)
		# if dd < THRESHOLD_ARCSEC
		# 	 printstyled("ddi1i2:  $dd  $i1  $i2", color = :red)  
		# 	 return 0
		# end
		return 999
	end
	# @time j = sortmerge([lat1 long1], [lat2 long2], lt1=lt, lt2=lt, sd=sd, 1.)
	println()
	# @time j = sortmerge([lat1 long1], [lat2 long2], lt1=lt, lt2=lt, sd=sd)
	@time j = sortmerge(raDec_1, raDec_2, lt1=lt, lt2=lt, sd=sd)
	# return j

    # j.matched[1] contains all first indices
    # j.matched[2] contains all second indices
    match_groups = Dict{Int, Vector{Int}}()
    
    # Zip the two vectors together to get matching pairs
    for (idx1, idx2) in zip(j.matched[1], j.matched[2])
        if haskey(match_groups, idx1)
            push!(match_groups[idx1], idx2)
        else
            match_groups[idx1] = [idx2]
        end
    end

    # Process each group to keep single matches or find closest; then calculate RA and Dec differences
    closest_matches = Vector{Tuple{Int,Int,Float64,Float64,Float64}}()
    for (idx1, idx2s) in match_groups
        if length(idx2s) == 1
            idx2 = idx2s[1]
            dist = gcirc(2, raDec_1[idx1, 1], raDec_1[idx1, 2], 
                        raDec_2[idx2, 1], raDec_2[idx2, 2])
            # Calculate RA difference using gcirc at same Dec
            ra_dist = gcirc(2, raDec_1[idx1, 1], raDec_1[idx1, 2],
                           raDec_2[idx2, 1], raDec_1[idx1, 2]) * 
                           sign(raDec_2[idx2, 1] - raDec_1[idx1, 1])
            # Calculate Dec difference using gcirc at same RA
            dec_dist = gcirc(2, raDec_1[idx1, 1], raDec_1[idx1, 2],
                            raDec_1[idx1, 1], raDec_2[idx2, 2]) * 
                            sign(raDec_2[idx2, 2] - raDec_1[idx1, 2])
            push!(closest_matches, (idx1, idx2, dist, ra_dist, dec_dist))
        else
            distances = [gcirc(2, raDec_1[idx1, 1], raDec_1[idx1, 2],
                             raDec_2[idx2, 1], raDec_2[idx2, 2]) for idx2 in idx2s]
            _, best_idx = findmin(distances)
            best_idx2 = idx2s[best_idx]
            ra_dist = gcirc(2, raDec_1[idx1, 1], raDec_1[idx1, 2],
                           raDec_2[best_idx2, 1], raDec_1[idx1, 2]) * 
                           sign(raDec_2[best_idx2, 1] - raDec_1[idx1, 1])
            dec_dist = gcirc(2, raDec_1[idx1, 1], raDec_1[idx1, 2],
                            raDec_1[idx1, 1], raDec_2[best_idx2, 2]) * 
                            sign(raDec_2[best_idx2, 2] - raDec_1[idx1, 2])
            push!(closest_matches, (idx1, best_idx2, distances[best_idx], ra_dist, dec_dist))
        end
    end
    
    return j, closest_matches
end