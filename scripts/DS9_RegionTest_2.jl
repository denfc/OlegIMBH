using DrWatson
@quickactivate "OlegIMBH"
import SAOImageDS9
const sao = SAOImageDS9

# Connect to DS9
sao.connect()

include(srcdir("writeDS9RegFile.jl"))
include(srcdir("verifyRegFileSent.jl"))
x = [1000., 3000, 500, 700, 900]
y = x

regFile = DS9_writeRegionFile(x, y, 10)
# Can delete all previous regions before sending new ones
sao.set("regions", "delete all")
DS9_SendRegAndVerify(regFile)