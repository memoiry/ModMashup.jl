#SP document


export 
      rwr,
      searchdir,
      build_index,
      pca,
      parse_query,
      parse_target,
      load_net

"""
    rwr(A::Matrix, restart_prob = 0.5)

Random walk with restart.

# Arguments

`A::Matrix`: Initial matrix for random walk.

`restart_prob`: Restart probability. Default 0.5.

# Outputs

`Q::Matrix`: matrix after random walk.

"""
function rwr(A::Matrix, restart_prob = 0.5)
    n = size(A, 1);
    A = A - diagm(diag(A));
    A = A + diagm(sum(A,1) .== 0);
    P = broadcast(/, A, sum(A,1))
    Q = (eye(n) - (1 - restart_prob) * P) \ (restart_prob * eye(n));
    return Q
end

"""
    pca(A::Matrix, num::Int64=size(A,2))

Perform PCA for a matrix.

# Arguments

`A::Matrix`: matrix for PCA

# keywords

`num::Int64=size(A,2)`: Number of diensions selected.

# Output

pca vector and pca value

`eigenvalue::Vector`: as name suggested.
`eigenvector::Matrix`: columns represent eigen vector.

# Example 

```juli-repl
julia> a = rand(5,5)
5×5 Array{Float64,2}:
 0.149599  0.318179  0.235567  0.779247  0.276985
 0.175398  0.109825  0.532561  0.723127  0.621328
 0.68087   0.639779  0.754652  0.781525  0.264776
 0.77962   0.446314  0.805693  0.88001   0.655808
 0.19243   0.43587   0.945708  0.109192  0.196602

julia> pca_value, pca_vector = pca(a)
([2.77556e-17,0.000524192,0.0396649,0.113626,0.128647],
[0.483429 0.397074 … -0.376334 -0.679859; -0.738733 0.15917 … -0.379275 -0.170866; … ;
 -0.0942359 -0.593824 … 0.444543 -0.643074; -0.457645 0.345674 … 0.1949 -0.306201])
```
"""
function pca(A::Matrix, num::Int64=size(A,2))
    Σ = cov(A, 1, false)
    eigenvalue,eigenvector =  eig(Σ)
    return eigenvalue[1:num], eigenvector[:,1:num]
end

"""
    build_index(index_file::String)

Get two dictionary, one map patients name to its id, another map patient id to its name.

# Arguments

`index_file::String`: 

# Outputs 

`patients_index::Dict{String, Int}`: map patientd name to its internal id.

`inverse_index::Dict{Int, String}`: map patientd internal id to its name.

# Example

```julia
# get example data directory
example_data_dir = joinpath(Pkg.dir("ModMashup"), "test/data")

# Id file contains all the name of patients.
id = joinpaht(example_data_dir,"ids.txt")

# Build the index
patients_index, inverse_index = build_index(id)
```
"""
function build_index(index_file::String)
    index_ = readdlm(index_file)
    patients_index = Dict{String,Int}()
    inverse_index = Dict{Int, String}()
    #index_ = size(index_,1) == 1 ? reshape(index_,2,Int(length(index_)/2)) :index_'
    @assert size(index_, 2) == 1
    n_patients = size(index_, 1)
    for i = 1:n_patients
        patients_index[index_[i,1]] = i
        inverse_index[i] = index_[i,1]
    end
    return patients_index, inverse_index
end

"""
    parse_target(target, patients_index)

Get a vector of annotation for patients. (+1 for interested, -1 for others)

# Inputs

`target::Matrix`: colume one is patient name, colume two is patient label.

`patients_index::Dict{String, Int}`: map patientd name to its internal id.

# Outputs

`id_label::Matrix`: colume one is patient id, colume two is patient label.

# Example

```julia

# get example data directory
example_data_dir = joinpath(Pkg.dir("ModMashup"), "test/data")

# Id file contains all the name of patients.
id = joinpaht(example_data_dir,"ids.txt")

# Build the patient index
patients_index, inverse_index = build_index(id)

# target_file should be a flat file contains disaese for patient
target_file = joinpaht(example_data_dir,"target.txt")

# Build the annotation for each patients
annotation = parse_target(readdlm(target_file), patients_index)
```
"""
function parse_target(target::Matrix,
                     patients_index::Dict{String, Int})
    id_label = zeros(Int, size(target, 1))
    for i = 1:size(target, 1)
        id_label[patients_index[target[i,1]]] = Int(target[i,2])
    end
    return id_label
end

"""
    parse_query(query_file, patients_index)

Get query patient id from the query file.

# Inputs

`query_file::String`: query filename whose format same with GeneMANIA query.

`patients_index::Dict{String, Int}`: map patientd name to its internal id.

# Outputs

`query_id::Vector`: query patient id.

# Example 

```julia

# get example data directory
example_data_dir = joinpath(Pkg.dir("ModMashup"), "test/data")

# Id file contains all the name of patients.
id = joinpaht(example_data_dir,"ids.txt")

# Build the patient index
patients_index, inverse_index = build_index(id)

# Query file using the same format with genemania query
query = joinpaht(example_data_dir,"query.txt")

# Build the annotation for each patients
query = parse_query(query, patients_index)
```
"""
function parse_query(query_file::String,
                    patients_index::Dict{String, Int})
    query = readdlm(query_file)[2,:]
    query_id = zeros(Int, length(query))
    for i = 1:length(query)
        query_id[i] = patients_index[query[i]]
    end
    return query_id
end

"""
    load_net(filename::String,
                  database::Database)

Load similairity network from a flat file. 
Format `patient_name patient_name simialirty_score`.
Use databse to map patient_name to internal id.

# Inputs

`filename::String`: similairty network filename.

`database::Database`: store general information.

# Outputs

`A::Matrix`: similairty network as a matrix.

"""
function load_net(filename::String,
                  database::Database)
    network = readdlm(filename);
    n_relation = size(network, 1)
    # Map patient name to its id
    for i in 1:n_relation
        for j in 1:2
            network[i,j] = database.patients_index[network[i,j]] 
        end
    end
    #@show typeof(network)
    #if isa(network, Array{any,2}) 
    #    network = convert(Array{Float64,2}, network)
    #end
    #@assert isa(network, Array{Float64, 2})
    A = full(sparse(Int.(network[:,1]), Int.(network[:,2]), float.(network[:,3]), database.n_patients, database.n_patients));
    if !isequal(A, A') # symmetrize
        A = A + A'
    end
    A = A + diagm(sum(A, 2) .== 0)
end

"""
    searchdir(path,key)

# Inputs

`path::String`: directory we want to search

`key::String`: keyword that the file we seached contains.

# Outputs

* a list of files whose name contains the keyword provided.

- `Input`: directory we want to search and the keyword.
- `Output`: a list of files whose name contains the keyword provided.
"""
searchdir(path::String,key::String) = filter(x->contains(x,key), readdir(path))
