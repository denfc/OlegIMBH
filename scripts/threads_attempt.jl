cd(joinpath(homedir(), "Gitted/OlegIMBH"))
using DrWatson
@quickactivate

using CSV
using DataFrames
using Base.Threads

# Function to read a chunk of the file
function read_chunk(file, start_byte, end_byte, delim)
    open(file) do f
        seek(f, start_byte)
        data = read(f, end_byte - start_byte)
        df = CSV.read(IOBuffer(data), DataFrame; header=false, delim=delim, ignorerepeated=true)
        return df
    end
end

# Function to split the file into chunks and read in parallel
function read_file_in_parallel(file, delim=" ")
    if !isfile(file)
        error("File does not exist: $file")
    end

    file_size = filesize(file)
    nthreads = Threads.nthreads()
    chunk_size = ceil(Int, file_size / nthreads)
    
    # Initialize dfs with empty DataFrames
    dfs = [DataFrame() for _ in 1:nthreads]
    
    @threads for i in 1:nthreads
        start_byte = (i - 1) * chunk_size + 1
        end_byte = min(i * chunk_size, file_size)
        
        # Adjust start_byte to the beginning of the next line
        if start_byte > 1
            try
                open(file) do f
                    seek(f, start_byte - 1)
                    readline(f)
                    start_byte = position(f)
                end
            catch e
                @warn "Error adjusting start_byte in thread $i: $e"
                continue
            end
        end
        
        # Adjust end_byte to the end of the current line
        if end_byte < file_size
            try
                open(file) do f
                    seek(f, end_byte)
                    readline(f)
                    end_byte = position(f)
                end
            catch e
                @warn "Error adjusting end_byte in thread $i: $e"
                continue
            end
        end
        
        try
            # Use the adjusted start_byte and end_byte to read the chunk
            dfs[i] = read_chunk(file, start_byte, end_byte, delim)
        catch e
            @warn "Error in thread $i: $e"
            dfs[i] = DataFrame()  # Ensure dfs[i] is initialized even if an error occurs
        end
    end
    
    # Concatenate all data frames
    df = vcat(dfs...)
    
    # Ensure the number of columns is consistent
    max_cols = maximum(ncol.(dfs))
    for i in 1:length(dfs)
        if ncol(dfs[i]) < max_cols
            for _ in ncol(dfs[i])+1:max_cols
                push!(dfs[i], DataFrame(Any[]))
            end
        end
    end
    
    df = vcat(dfs...)
    return df
end

# Example usage
file = "/home/dfc123/Gitted/OlegIMBH/data/exp_raw/OmegaCen/omega_cen_phot"
df = read_file_in_parallel(file)