# Check if DS9 servers are running
try
	ds9_servers = readchomp(`xpaget xpans`)
catch e
	println("Error checking for DS9 servers: ", e)
	println("No DS9 servers found. Starting a new DS9 instance.")
	ENV["DISPLAY"] = ":0"  # Set the display to the default value
#=
The ENV["DISPLAY"] = ":0" line sets the DISPLAY environment variable to :0. This environment variable is used by X Window System (commonly referred to as X11) to determine which display (monitor) to use for graphical output.

In more detail:

:0 refers to the first display on the local machine. If you have multiple displays, they would be :1, :2, etc.
Setting ENV["DISPLAY"] = ":0" ensures that any graphical application, like DS9, will attempt to open its window on the first display.
This is particularly useful when running graphical applications from a script or remotely, as it explicitly tells the application where to render its window. If this variable is not set correctly, the application might not know where to display its window, leading to issues like the one you are experiencing where DS9 is running but not visible
=#
    run(`ds9`, wait=false) # Start DS9, but if "false", don't wait for it to finish before returing to the prompt (hangs on "true)
	# run(`ds9 -raise "&"`)
	sleep(3) # Wait for DS9 to start; sometimes works, sometimes doesn't, even at 8 seconds, so leaving it at 2 seconds; just run it again if it doesn't work the first time
	try
		sao.connect()
		println("Connected to DS9 successfully.")
		sao.set("raise") # Bring the DS9 window to the front
		imgFilePath = "/home/dfc123/Gitted/OlegIMBH/data/exp_raw/OmegaCen/jw04343-o002_t001_nircam_clear-f200w_i2d.fits"
		load_zoom_grid_color_scale_view(imgFilePath) # defaults: ; z = "zoom to fit", g = "grid no", c = "cmap scm_greyC", s = "scale log"
	catch e
		error("Failed to connect to DS9; try again\n ", e)
	end
end
println("Running DS9 servers: ", readchomp(`xpaget xpans`))