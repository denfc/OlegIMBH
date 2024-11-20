using AstroLib
using SkyCoords

# Test coordinates (in degrees)
ra1, dec1 = 90.0, -30.0
ra2, dec2 = 90.0, -30.0000001

# AstroLib method
dist_gcirc = gcirc(2, ra1, dec1, ra2, dec2)  # Mode 2 = degrees
dist_gcirc /= 3600

# SkyCoords method
coord1 = ICRSCoords(deg2rad(ra1), deg2rad(dec1))
coord2 = ICRSCoords(deg2rad(ra2), deg2rad(dec2))
dist_separation = rad2deg(separation(coord1, coord2))

println("AstroLib distance: $dist_gcirc degrees")
println("SkyCoords distance: $dist_separation degrees")
println("Difference: $(abs(dist_gcirc - dist_separation)) degrees")