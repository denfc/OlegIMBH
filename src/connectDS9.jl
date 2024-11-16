#= retained for information in the comments
function connectDS9(file::String)
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
			println()
			printstyled("Connected to DS9 successfully.\n", color = :green)
			sao.set("raise") # Bring the DS9 window to the front
			load_zoom_grid_color_scale_view(file) # defaults: ; z = "zoom to fit", g = "grid no", c = "cmap scm_greyC", s = "scale log"
		catch e
			error("Failed to connect to DS9; try again\n ", e)
		end
	end
	println("Running DS9 servers: ", readchomp(`xpaget xpans`))
end
=#

# At file level - only initialize once if not already set
if !@isdefined(current_ds9_instrument)
    global current_ds9_instrument = ""
end

function connectDS9(file::String, instrument::String)
    global current_ds9_instrument  # Just declare intent to use global
    needs_restart = false
    
    try
        ds9_servers = readchomp(`xpaget xpans`)
        printstyled("DEBUG: Found DS9 servers: $ds9_servers\n", color=:green)
        
        if !occursin("DS9", ds9_servers)
            printstyled("DEBUG: No DS9 servers found in response\n", color=:yellow)
            needs_restart = true
        elseif current_ds9_instrument != instrument
            printstyled("DEBUG: Instrument change needed\n", color=:yellow)
            try
                run(`pkill -f ds9`)
            catch
                printstyled("DEBUG: pkill failed but continuing\n", color=:yellow)
            end
            needs_restart = true 
        end
    catch e
        printstyled("DEBUG: Error message: $e\n", color=:yellow)
        needs_restart = true
    end
    
    if needs_restart
        ENV["DISPLAY"] = ":0"
        run(`ds9`, wait=false)
        sleep(5)
		for i in 1:3
			try
				sao.connect()
				println()
				printstyled("Connected to DS9 successfully.\n", color = :green)
				sao.set("raise")
				load_zoom_grid_color_scale_view(file)
				current_ds9_instrument = instrument
				return true
			catch e
				@warn("Failed to connect to DS9, $i; trying again\n ", e)
			end
		end
    else
        current_ds9_instrument = instrument  # Update even when not restarting
    end
    
    println("Running DS9 servers: ", readchomp(`xpaget xpans`))
end