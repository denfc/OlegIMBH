function load_zoom_grid_color_scale_view(file; z = "zoom to fit", g = "grid no", c = "cmap scm_greyC", s = "scale pow", v = "view vertical", level = "99.5")
	sao.set("file $file") # loads the file into DS9
	sao.set(v)  # sets the view (to vertical)
	sao.set(g) 	# turns on the grid
	sao.set(c) 	# sets the color map
	sao.set(s) # Set the contrast scale to power
	sao.set("scale mode "*level)
	sao.set(z) 	# sets the zoom level
end