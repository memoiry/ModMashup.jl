
export 
        Database

#typealias SimilarityNetworks Union{Array{Float64,3},Vector{SparseMatrixCSC{Float64,Int64}}}
#typealias SimilarityNetwork Union{Array{Float64,2},SparseMatrixCSC{Float64,Int64}}
const OneHotAnnotation = Union{Vector{Int},Array{Int, 2}, SparseMatrixCSC{Int64,Int64}}
abstract AbstractDatabase

"""
Store general and in-depth information for network integration and label propagation.

# Fields

`string_nets::Vector{String}`: Similarity networks name.

`labels::OneHotAnnotation`: Disease annotation for patients.

`n_patients::Int`: The number of patients in the databse.

`patients_index::Dict{String,Int}`: Map patient name to their id.

`inverse_index::Dict{Int,String}`: Map patient id to their name.

`num_cv::Int`: The number of cross validation round. Default is 10.

`query_attr::Int`: Set the annotaion for query . Default is 1.

`string_querys::Vector{String}`: A list of query filename.

`smooth::Int`: Perform smooth in the simialarty or not. Default is true.

`int_type::Symbol`: Symbol indicate the dabase is for networks selection or 
patients ranking. It could be `:ranking` or `:selection`, Default is :selection.

`thread::Int`: The number of thread used to running the program. Default it 1.

# Keywords

`top_net::String`: a txt file contains the name of selected top ranked networks.

``

# Constructor

    Database(network_dir, target_file, id, query_dir)

Create new `Database`.

# Example

```julia
# enter example data directory
cd(joinpath(Pkg.dir("ModMashup"), "test/data"))

# dir should be a directory containing similairty networks flat file.
network_dir = "networks"

# target_file should be a flat file contains disaese for patient
labels = "target.txt"

# Directory where a list of query flat files are located using the 
# same format and naming manner with genemania query.
query_dir = "."

# Id file contains all the name of patients.
id = "ids.txt"

# Other setting
## Do smooth in the network or not for mashup integration.
smooth = true

# Construct the dabase, which contains the preliminary file.
database = ModMashup.Database(dir, id,
            querys, labels_file = labels,
            smooth = smooth,
            int_type = :selection)

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
    int_type::Symbol
end
function Database(dir::String,
                index_file::String,
                querys::String;
                top_net::String = "nothing",
                labels_file::String = "nothing",
                num_cv = 10,
                query_attr = 1,
                smooth = true,
                tally = zeros(Int, 10),
                thread = 1,
                int_type = :ranking)

    if int_type == :selection && labels_file == "nothing"
        error("labels file is needed if you want to do network selection")
    end

    # Initialization
    patients_index::Dict{String, Int} = Dict{String, Int}()
    inverse_index::Dict{Int, String} = Dict{Int, String}()
    string_nets = Vector{String}() 

    # If there is no top network 
    if top_net == "nothing"
        # Get all similairty file in the network directory 
        # using the "cont.txt" keyword.
        string_nets = searchdir(dir, "cont.txt")

        # add directory prefix for locating
        map!(x -> joinpath(dir, x), string_nets, string_nets)
    else
    # If top networks is provided
        # Get top network's name
        string_nets = convert(Vector{String}, vec(readdlm(top_net)))

        # add flat file postfix
        map!(x -> x * ".txt", string_nets, string_nets)

        # add directory prefix for locating
        map!(x -> joinpath(dir, x), string_nets, string_nets)
    end

    # Build the index to map patients name to id and also id to name.
    patients_index, inverse_index = build_index(index_file)
    n_patients = length(patients_index)

    # Get query file
    string_querys = Vector{String}()
    # If used for network selection
    # querys shoudl be a directory storing a list of query file
    if int_type == :selection
        @assert isdir(querys)
        string_querys = filter(x -> length(x) < 12 ,searchdir(querys, "query"))
        map!(x -> joinpath(querys, x), string_querys, string_querys)
    # If used for patient ranking 
    # querys should be a single query file
    elseif int_type == :ranking
        @assert isfile(querys)
        push!(string_querys, querys)
    else
        error("Unexpected integration type")
    end

    # Get patients disease labels in one vector. (+1 for interested, -1 for other)
    labels = ones(Int, n_patients) * -1
    # If for network selection, then need a label flat file
    if int_type == :selection
        labels = contains(labels_file, "txt") ? parse_target(readdlm(labels_file), patients_index) : readcsv(disease_file)
    # If for patient ranking, then use query as interested that is +1.
    elseif int_type == :ranking
        query_index = parse_query(string_querys[1], patients_index)
        labels[query_index] = 1
    else
        error("Unexpected integration algorithm")
    end

    num_cv = length(string_querys)

    # return the constructed database
    return Database(string_nets, labels, n_patients,
                  patients_index, inverse_index, num_cv,
                  query_attr, string_querys, smooth, thread,
                  int_type)
end