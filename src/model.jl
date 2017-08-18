
export 
        Database, 
        SharedDatabase

#typealias SimilarityNetworks Union{Array{Float64,3},Vector{SparseMatrixCSC{Float64,Int64}}}
#typealias SimilarityNetwork Union{Array{Float64,2},SparseMatrixCSC{Float64,Int64}}
typealias OneHotAnnotation Union{Vector{Int},Array{Int, 2}, SparseMatrixCSC{Int64,Int64}}
abstract AbstractDatabase

"""
Store general and in-depth information for network integration and label propagation.

# Fields

`string_nets::Vector{String}`: Similarity networks name.

`disease::OneHotAnnotation`: Disease annotation for patients.

`n_patients::Int`: The number of patients in the databse.

`patients_index::Dict{String,Int}`: Map patient name to their id.

`inverse_index::Dict{Int,String}`: Map patient id to their name.

`num_cv::Int`: The number of cross validation round. Default is 10.

`query_attr::Int`: Set the annotaion for query . Default is 1.

`string_querys::Vector{String}`: A list of query filename.

`smooth::Int`: Perform smooth in the simialarty or not. Default is true.

`thread::Int`: Number of thread for parallel computing. Default it 1.

# Constructor

    Database(network_dir, target_file, id, query_dir)

Create new `Database`.

# Example

```julia
# get example data directory
example_data_dir = joinpath(Pkg.dir("ModMashup"), "test/data")

# dir should be a directory containing similairty networks flat file.
network_dir = joinpaht(example_data_dir,"networks")

# target_file should be a flat file contains disaese for patient
target_file = joinpaht(example_data_dir,"target.txt")

# Directory where a list of query flat files are located using the 
# same format and naming manner with genemania query.
query_dir = example_data_dir

# Id file contains all the name of patients.
id = joinpaht(example_data_dir,"ids.txt")

# Other setting
## Do smooth in the network or not for mashup integration.
smooth = true
## The number of thread choosen to perform computation.
thread = 2

# We are ready now, then just construct the database
database = ModMashup.Database(network_dir, target_file, 
                id, query_dir, smooth = smooth, 
                thread = thread)
```
"""
immutable Database <: AbstractDatabase
    string_nets::Vector{String}
    labels::OneHotAnnotation
    n_patients::Int
    patients_index::Dict{String,Int}
    inverse_index::Dict{Int,String}
    num_cv::Int
    query_attr::Int
    string_querys::Vector{String}
    smooth::Bool
    thread::Int
end
function Database(dir::String,
                disease_file::String,
                index_file::String,
                querys::String;
                num_cv = 10,
                query_attr = 1,
                smooth = true,
                tally = zeros(Int, 10),
                thread = 1)
    # Initialization
    patients_index::Dict{String, Int} = Dict{String, Int}()
    inverse_index::Dict{Int, String} = Dict{Int, String}()
    string_nets = Vector{String}() 

    # Get all similairty file in the network directory 
    # using the "cont.txt" keyword.
    string_nets = searchdir(dir, "cont.txt")
    map!(x -> joinpath(dir, x), string_nets)

    # Build the index to map patients name to id and also id to name.
    patients_index, inverse_index = build_index(index_file)

    # Get all query file
    string_querys = filter(x -> length(x) < 12 ,searchdir(querys, "query"))
    map!(x -> joinpath(querys, x), string_querys)

    # Get patients disease annotation in one vector. (+1 for interested, -1 for other)
    labels = contains(disease_file, "txt") ? parse_target(readdlm(disease_file), patients_index) : readcsv(disease_file)
    n_patients = size(labels,1)

    # return the constructed database
    return Database(string_nets, labels, n_patients,
                  patients_index, inverse_index, num_cv, query_attr, string_querys, smooth, thread)
end



"""
    SharedGeneMANIA

Shared genemania model for shared memory parallel computing (Still unfinished, left to do..)
"""
type SharedDatabase <: AbstractDatabase
    string_nets::Vector{String}
    labels::OneHotAnnotation
    n_patients::Int64
    patients_index::Dict{String,Int64}
end
function SharedDatabase()


end



"""
    share

Convert the normal model to shared model(left to do...)
"""
function share(genemania::Database)



end