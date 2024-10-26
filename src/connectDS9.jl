# Check if DS9 servers are running
try readchomp(`xpaget xpans`)
	ds9_servers = readchomp(`xpaget xpans`)
catch e
	println("Error checking for DS9 servers: ", e)
	println("No DS9 servers found. Starting a new DS9 instance.")
    run(`ds9`, wait=false) # Start DS9, but don't wait for it to finish before returing to the prompt
    sleep(2) # Wait for DS9 to start; sometimes works, sometimes doesn't, even at 8 seconds, so leaving it at 2 seconds; just run it again if it doesn't work the first time
end
println("Running DS9 servers: ", readchomp(`xpaget xpans`))

# Connect to DS9
try
	sao.connect()
	println("Connected to DS9 successfully.")
	sao.set("raise") # Bring the DS9 window to the front; not sure this works with my set up
catch e
	println("Failed to connect to DS9: ", e)
end