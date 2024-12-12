"""
    dfc 12 Dec 2024, via Copilot
	log(B_1/B_2) = (2/5)(mag_2 - mag_1)
"""
function log_brightness_ratios(df::DataFrame, row_idx::Integer)
    # Validate row index
    1 <= row_idx <= nrow(df) || throw(BoundsError(df, row_idx))
    
    # Extract magnitudes for the row
    m1500 = df[row_idx, :mag1500]
    m770 =  df[row_idx, :mag770]
    m444 =  df[row_idx, :mag444]
    m200 =  df[row_idx, :mag200]
    
    # Calculate log brightness ratios using (2/5)(m2 - m1)
    return (
        r1500_770 = 0.4 * (m770 - m1500),
        r770_444  = 0.4 * (m444 - m770 ),
        r444_200  = 0.4 * (m200 - m444 ),
        r1500_200 = 0.4 * (m200 - m1500)
    )
end

# Usage example:
# ratios = calculate_brightness_ratios(dfMiriNircam, 1)