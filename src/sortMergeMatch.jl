"""
dfc 20 November 2024, taken from script `SortMerge.jl`
	  
    - called from matchCoords
"""
function sortMergeMatch(lat1, long1, lat2, long2)
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
	@time j = sortmerge([lat1 long1], [lat2 long2], lt1=lt, lt2=lt, sd=sd)
	return j
end