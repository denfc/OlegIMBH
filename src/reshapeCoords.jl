"""
!!! tip "dfc 25 Sept 2024"
    - built orginally in /home/dfc123/Gitted/OlegIMBH/notebooks/P22\\_JWST.jl, this function takes the RA and Dec coordinates `sky_centroid_ra` and `sky_centroid_dec`, which are read from the JWST ECSV file, and it puts them into a (2 X their length) Matrix(Float64) that the functions `crossmatch` and `crossmatch_angular` want.
"""
function reshapeCoords(RA, Dec)
	v = vcat(collect(RA), collect(Dec))
	len_vS2 = div(length(v), 2)
	return reshape(v, 2, len_vS2)
end