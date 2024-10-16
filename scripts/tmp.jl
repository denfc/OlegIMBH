using DrWatson
@quickactivate "OlegIMBH"
using CSV, Plots, DataFrames
df = CSV.read("./data/exp_raw/OmegaCen/omega_cen_phot", DataFrame)
scatter(df[!, 16], df[!, 29])