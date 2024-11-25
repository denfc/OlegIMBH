# Function to check and read DataFrame if needed
function get_df(instrument)
    global current_df_instrument
    local FITSfile  # Declare FITSfile at function scope
    
    if !@isdefined(df) || current_df_instrument != instrument
        if instrument == "NIRCam"
            FITSfile = datadir("exp_raw/OmegaCen/jw04343-o002_t001_nircam_clear-f200w_i2d.fits")
            df = CSV.read(joinpath(datadir(), "exp_raw/OmegaCen/omega_cen_phot"), 
                         DataFrame; 
                         header=false, 
                         delim=" ", 
                         ignorerepeated=true, 
                         select=columnsToRead)
        else
            FITSfile = datadir("exp_raw/Archive_MIRI_Ocen_dolphot/jw04343-o001_t001_miri_f770w_i2d.fits")
            df = CSV.read(joinpath(datadir(), "exp_raw/Archive_MIRI_Ocen_dolphot/omega_cen_phot_miri"), 
                         DataFrame; 
                         header=false, 
                         delim=" ", 
                         ignorerepeated=true, 
                         select=columnsToRead)
        end
        current_df_instrument = instrument
    else
        # Set FITSfile even when not reading new data
        FITSfile = 
		if instrument == "NIRCam"
            datadir("exp_raw/OmegaCen/jw04343-o002_t001_nircam_clear-f200w_i2d.fits")
        else
            datadir("exp_raw/Archive_MIRI_Ocen_dolphot/jw04343-o001_t001_miri_f770w_i2d.fits")
        end
    end
    return df, FITSfile
end