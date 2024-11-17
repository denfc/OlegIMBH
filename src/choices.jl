"""
dfc 17 November 2024
	- choices function created so that it can be used in `translateCoords.jl` as well
"""
function choices(params::ChoiceParams)
    # full names in main code: instrument, objectTypeIndex, include99s, only99s, randBright, nStart, nBrightest, gross_limits 
    # include99 and only99s should not contradict each otherwise
    # Set this to true for random selection, false for sorted selection
    # the original limits, from JWSt; otherwise, the more stringent limits of the xxx paper are used

    # in calling code: global instruments = ["NIRCAM", "MIRI"]
    instr = instruments[params.instrNumber]
    return instr, params.obTyn, params.inc99s, params.onl99s, params.randB, params.nStrt, params.nB, params.grossLim
end