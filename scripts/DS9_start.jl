include(joinpath(homedir(), "Gitted/OlegIMBH/src/intro.jl"))
imgFilePath = "/home/dfc123/Gitted/OlegIMBH/data/exp_raw/OmegaCen/jw04343-o002_t001_nircam_clear-f200w_i2d.fits"
load_zoom_grid_color_scale_view(imgFilePath; g = "grid no", c = "cmap grey", s = "scale linear") # defaults: ; z = "zoom to fit", g = "grid yes", c = "cmap color", s = "scale sqrt"