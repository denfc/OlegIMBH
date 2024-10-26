function DS9_SendRegAndVerify(file::String) # Verify DS9 connection
	try
		sao.set("regions", file)
		println("Region file sent to DS9 successfully.")
	catch e
		println("Error sending region file to DS9: ", e)
	end
end