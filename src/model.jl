
export 
        Database, 
        SharedDatabase

#typealias SimilarityNetworks Union{Array{Float64,3},Vector{SparseMatrixCSC{Float64,Int64}}}
#typealias SimilarityNetwork Union{Array{Float64,2},SparseMatrixCSC{Float64,Int64}}
typealias OneHotAnnotation Union{Vector{Int},Array{Int, 2}, SparseMatrixCSC{Int64,Int64}}
abstract AbstractDatabase

"""
    Database

Database contains needed information for network integration and label propagation.

# Arguments
- `string_nets::Vector{String}`: Similarity networks name.
- `disease::OneHotAnnotation`: Disease annotation for patients.
- `n_patients::Int`: The number of patients in the databse.
- `patients_index::Dict{String,Int}`: Map patient name to their id.
- `inverse_index::Dict{Int,String}`: Map patient id to their name.
- `num_cv::Int`: The number of cross validation round. Default is 10.
- `query_attr::Int`: Set the annotaion for query . Default is 1.
- `string_querys::Vector{String}`: The name of Query patients.
- `smooth::Int`: Perform smooth in the simialarty or not. Default is true.
- `thread::Int`: Number of thread for parallel computing.

# Example

```julia
# get example data directory
example_data_dir = joinpath(Pkg.dir("ModMashup"), "test/data")

# dir should be a directory containing similairty networks flat file.
network_dir = joinpaht(example_data_dir,"networks")

# target_file should be a flat file contains disaese for patient
target_file = joinpaht(example_data_dir,"target.txt")

# Query file using the same format with genemania query
querys = joinpaht(example_data_dir,"query.txt")

# Id file contains all the name of patients.
id = joinpaht(example_data_dir,"ids.txt")

# Other setting
## Do smooth in the network or not for mashup integration.
smooth = true
## The number of thread choosen to perform computation.
thread = 2

# We are ready now, then just construct the database
database = ModMashup.Database(network_dir, target_file, 
                index_file = id, querys = querys,
                smooth = smooth, thread = thread)
```
"""

immutable Database <: AbstractDatabase
    string_nets::Vector{String}
    disease::OneHotAnnotation
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
                disease_file::String;
                index_file = nothing,
                net_sel = nothing,
                num_cv = 10,
                query_attr = 1,
                querys = nothing,
                smooth = true,
                tally = zeros(Int, 10),
                thread = 1)
    patients_index::Dict{String, Int} = Dict{String, Int}()
    inverse_index::Dict{Int, String} = Dict{Int, String}()
    string_nets = Vector{String}() 
    if net_sel != nothing
        @assert isa(net_sel,Vector{String})
        n_net = length(net_sel)
        for i = 1:n_net
            net_sel[i] = @sprintf "%s/%s.txt" dir net_sel[i]
        end
        string_nets = net_sel
    else
        string_nets = searchdir(dir, "cont.txt")
        map!(x -> joinpath(dir, x), string_nets)
    end

    if index_file != nothing
        @assert isa(index_file, String)
        patients_index, inverse_index = build_index(index_file)
    end
    if querys != nothing
        @assert isa(querys, String)
        string_querys = filter(x -> length(x) < 12 ,searchdir(querys, "query"))
        map!(x -> joinpath(querys, x), string_querys)
    end
    disease = contains(disease_file, "txt") ? parse_target(readdlm(disease_file), patients_index) : readcsv(disease_file)
    n_patients = size(disease,1)
    return GMANIA(string_nets, disease, n_patients,
                  patients_index, inverse_index, num_cv, query_attr, string_querys, smooth, thread)
end



"""
    SharedGeneMANIA

Shared genemania model for shared memory parallel computing (Still unfinished, left to do..)
"""
type SharedDatabase <: AbstractDatabase
    string_nets::Vector{String}
    disease::OneHotAnnotation
    n_patients::Int64
    patients_index::Dict{String,Int64}
end


function SharedDatabase()


end



"""
    share

Convert the normal model to shared model
"""
function share(genemania::Database)



end



