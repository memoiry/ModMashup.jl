
### SP: All of the .jl files need documentation.
###   a) add 1 line brief description of what the .jl file does
###   b) add a detailed description
###   c) what the input parameters are
###   d) what the function returns. The object type and a text description.

export 

    network_integration!, 
    MashupIntegration

## SP: What is the purpose of this?
abstract IgAbstractParams

#IgParams(args...;kwargs...) = NetworkIntegration(args...;kwargs...)

## SP: Separate each "piece" of this .jl file. Or better, put different things in different .jl files. This file has an object definition and a network_integration() function. Put them in two Julia files. 
type MashupIntegration <: IgAbstractParams

### SP: Please change from greek symbol to word "beta" everywhere. 
### Easier to edit.
    β::Vector ## SP:document
    H::Matrix
    net_weights::Vector
    weights_mat::Matrix
    cv_query::Matrix
    singular_value_squared::Vector
end

MashupIntegration() = MashupIntegration(Vector(), Matrix(), Vector(), Matrix(), Matrix(), Vector())


### Should be in its own jl file.
function network_integration!(model::MashupIntegration, database::GMANIA)
    net_files = database.string_nets
    n_net = length(net_files)
    n_patients = database.n_patients
    net = zeros(n_patients * n_net, n_patients);
    eigen_value_list_ = zeros(n_patients*n_net,n_patients)

### SP: Add a newline break between each logical step of the code.
### makes it easier to read, understand, debug

    #@show eigen_value_list_
    #@show n_net
    @showprogress 1 "Running diffusion...." for i = 1:n_net
        #verbal ? (@printf "Loading %s\n" net_files[i]) : nothing
        A = load_net(net_files[i], database);#load the similarirty net.

        #verbal ? (@printf "Running diffusion\n") : nothing
        Q = rwr(A, 0.5);#running random walk.
        #R = log(Q + 1/n_patients); #smoothing

        start = n_patients * (i-1)+1 
        net[start:(start+n_patients-1),:] = Q #concat each net together.
        #eigenvalue, eigenvector = pca(A, n_patients)
        #eigen_value_list_[start:(start+n_patients-1),:] = eigenvector;
    end

    #@show net
    #@show eigen_value_list_
    #@show typeof(eigen_value_list_)
    #verbal ? (@printf "PCA finished, computing beta vector") : nothing
    #eigenvalue, eigenvector = pca(net)

    println("Computing SVD")
    U,S,V = svd(net)

    #find reducde dimension.
    S = S.^2
    model.singular_value_squared = S
    tmp = cumsum(S)/sum(S).>0.9

    reduced_dim = find(tmp)[1]
    @show reduced_dim/n_patients

    H = U[:,1:reduced_dim] * diagm(S[1:reduced_dim])
    #V = V[:,1:reduced_dim]
    V = V[1:reduced_dim, :]

    query = find(database.disease.==database.query_attr)
    n_query = size(query,1)
    @show n_query

    num_cv_query = Int(floor((1-1/database.num_cv)*n_query))
    weights_mat = zeros(n_net, database.num_cv )
    println("SVD finished, linear regression for β")

    β = V' \ database.disease
    cv_query = zeros(num_cv_query, database.num_cv)

### SP: move "for" to next line?
### Set a RNG seed here to get results that you and I can reproduce.

    @showprogress 1 "Runing networks weights cv..." for i = 1:database.num_cv
        rand_index = randperm(n_query)
        rand_query = query[rand_index][1:num_cv_query]
        cv_query[:, i] = rand_query
        for j = 1:n_net
            base_query = (j-1) * n_query
### SP: Use correlation  (which is bounded by -1,1)
### instead of covariance?
            cov_list = cov(H[base_query+rand_query,:]',β)

            #@show cov_list
            weights_mat[j,i] = mean(cov_list)
        end
    end

    model.cv_query = cv_query
    
		#@show weights_mat
    model.weights_mat = weights_mat
    net_weights = vec(mean(weights_mat, 2))
    model.net_weights = net_weights/sum(net_weights)*100
    
		#@show model.net_weights
    model.H = H
    model.β = β
    #model.H = eigen_value_list_
    nothing
end

## SP: What is this? An empty function? Document or remove.
function get_params(params::MashupIntegration)
    
end
