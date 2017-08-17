#SP document


export 
      rwr,
      load_network,
      searchdir,
      build_index,
      pca
       

"""
    func(x)

Returns double the number `x` plus `1`.
"""
func(x) = 2x + 1


function rwr(A::Matrix, restart_prob)
    n = size(A, 1);
    A = A - diagm(diag(A));
    A = A + diagm(sum(A,1) .== 0);
    P = broadcast(/, A, sum(A,1))
    Q = (eye(n) - (1 - restart_prob) * P) \ (restart_prob * eye(n));
end

function pca(A::Matrix, num::Int64=size(A,2))
    Σ = cov(A, 1, false)
    eigenvalue,eigenvector =  eig(Σ)
    return eigenvalue[1:num], eigenvector[:,1:num]
end

## SP: Purpose? Document.
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

function parse_target(target, patients_index)
    temp = zeros(Int, size(target, 1))
    for i = 1:size(target, 1)
        temp[patients_index[target[i,1]]] = Int(target[i,2])
    end
    return temp
end

function parse_query(query_file, patients_index)
    query = readdlm(query_file)[2,:]
    temp = zeros(Int, length(query))
    for i = 1:length(query)
        temp[i] = patients_index[query[i]]
    end
    return temp
end

function load_net(filename::String,
                  database::Database)
    network = readdlm(filename);
    n_relation = size(network, 1)
    if database.use_index
        for i in 1:n_relation
            for j in 1:2
                network[i,j] = database.patients_index[network[i,j]] 
            end
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

## SP what is this doing?
searchdir(path,key) = filter(x->contains(x,key), readdir(path))
