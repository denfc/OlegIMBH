# Check if DS9 servers are running
try readchomp(`xpaget xpans`)
	ds9_servers = readchomp(`xpaget xpans`)
catch e
	println("Error checking for DS9 servers: ", e)
	println("No DS9 servers found. Starting a new DS9 instance.")
    run(`ds9`, wait=false) # Start DS9, but don't wait for it to finish before returing to the prompt
    sleep(3) # Wait for DS9 to start; sometimes works, sometimes doesn't, even at 8 seconds, so leaving it at 2 seconds; just run it again if it doesn't work the first time
	try
		sao.connect()
		println("Connected to DS9 successfully.")
		sao.set("raise") # Bring the DS9 window to the front; not sure this works with my set up
		imgFilePath = "/home/dfc123/Gitted/OlegIMBH/data/exp_raw/OmegaCen/jw04343-o002_t001_nircam_clear-f200w_i2d.fits"
		load_zoom_grid_color_scale_view(imgFilePath) # defaults: ; z = "zoom to fit", g = "grid no", c = "cmap scm_greyC", s = "scale log"
	catch e
		error("Failed to connect to DS9; try again\n ", e)
	end
end
println("Running DS9 servers: ", readchomp(`xpaget xpans`))