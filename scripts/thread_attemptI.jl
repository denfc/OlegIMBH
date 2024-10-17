cd(joinpath(homedir(), "Gitted/OlegIMBH"))
using DrWatson
@quickactivate

using CSV
using DataFrames
using Base.Threads

# Define the column names explicitly
column_names = [:Column1, :Column2, :Column3, :Column4, :Column5, :Column6, :Column7, :Column8, :Column9, :Column10, :Column11, :Column12, :Column13, :Column14, :Column15, :Column16, :Column17, :Column18, :Column19, :Column20, :Column21, :Column22, :Column23, :Column24, :Column25, :Column26, :Column27, :Column28, :Column29, :Column30]

# Function to read a chunk of the file
function read_chunk(file, start_byte, end_byte, columnsToRead, column_names)
    open(file) do f
        seek(f, start_byte)
        data = read(f, end_byte - start_byte)
        csv_file = CSV.File(IOBuffer(data); header=false, select=columnsToRead, delim=" ", ignorerepeated = true,)
        df = DataFrame(csv_file)
        rename!(df, column_names[columnsToRead])
        return df
    end
end

# Function to split the file into chunks and read in parallel
function read_file_in_parallel(file, columnsToRead, column_names)
    file_size = filesize(file)
    nthreads = Threads.nthreads()
    chunk_size = ceil(Int, file_size / nthreads)
    
    dfs = Vector{DataFrame}(undef, nthreads)
    
    @threads for i in 1:nthreads
        start_byte = (i - 1) * chunk_size + 1
        end_byte = min(i * chunk_size, file_size)
        
        # Adjust start_byte to the beginning of the next line
        if start_byte > 1
            open(file) do f
                seek(f, start_byte - 1)
                readline(f)
                start_byte = position(f)
            end
        end
        
        # Adjust end_byte to the end of the current line
        if end_byte < file_size
            open(file) do f
                seek(f, end_byte)
                readline(f)
                end_byte = position(f)
            end
        end
        
        # Use the adjusted start_byte and end_byte to read the chunk
        dfs[i] = read_chunk(file, start_byte, end_byte, columnsToRead, column_names)
    end
    
    # Concatenate all data frames
    df = vcat(dfs...)
    return df
end

# Define the columns to read
columnsToRead = 16:29  # Specify the columns you want to read

# Read the file in parallel
df = read_file_in_parallel("./data/exp_raw/OmegaCen/omega_cen_phot", columnsToRead, column_names)

# Verify the number of rows
println("Number of rows: ", nrow(df))