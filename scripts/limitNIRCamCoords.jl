"""
dfc 28 November 2024
To limit NIRCam_RADec to the MIRI region, we'll find the extreme values of the MIRI region in RA and Dec, and then limit the NIRCam region to those values.
"""

include(joinpath(homedir(), "Gitted/OlegIMBH/src/introTranslate.jl"))

dfMIRI = jldopen(joinpath(datadir("exp_pro/MIRI_RADec.jld2")))["newColumnGroup"]
dfNIRCam = jldopen(joinpath(datadir("exp_pro/NIRCam_RADec.jld2")))["newColumnGroup"]

extremeDecs = extrema(dfMIRI.dec)
extremeRAs = extrema(dfMIRI.ra)

dfNIRClimited = dfNIRCam[(dfNIRCam[!, :dec] .>= extremeDecs[1]) .& (dfNIRCam[!, :dec] .<= extremeDecs[2]) .& (dfNIRCam[!, :ra] .>= extremeRAs[1]) .& (dfNIRCam[!, :ra] .<= extremeRAs[2]), :]

#= roughly proportional to the ratio of the areas of the two regions
Decs = extrema(dfNIRCam.dec)
RAs = extrema(dfNIRCam.ra)

miriArea= (extremeDecs[2] - extremeDecs[1])*(extremeRAs[2] - extremeRAs[1])
nircArea = (Decs[2] - Decs[1]) * (RAs[2] - RAs[1])

println("MIRI/NIRCam ratio: ", miriArea/nircArea)
=#

output_file = joinpath(datadir(), "exp_pro/NIRCamLimited.jld2")
jldsave(output_file; dfNIRClimited)
