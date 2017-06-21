

export 

    network_integration!, 
    MashupIntegration

abstract IgAbstractParams

#IgParams(args...;kwargs...) = NetworkIntegration(args...;kwargs...)

type MashupIntegration <: IgAbstractParams
    β::Vector
    H::Matrix
    net_weights::Vector
end

MashupIntegration() = MashupIntegration(Vector(), Matrix(), Vector())

function network_integration!(model::MashupIntegration, database::GMANIA)
    net_files = database.string_nets
    n_net = length(net_files)
    n_patients = database.n_patients
    net = zeros(n_patients * n_net, n_patients);
    eigen_value_list_ = zeros(n_patients*n_net,n_patients)
    #@show eigen_value_list_
    #@show n_net
    @showprogress 1 "Running diffusion...." for i = 1:n_net
        #verbal ? (@printf "Loading %s\n" net_files[i]) : nothing
        A = load_net(net_files[i], database);#load the similarirty net.
        #verbal ? (@printf "Running diffusion\n") : nothing
        Q = rwr(A, 0.5);#running random walk.
        start = n_patients * (i-1)+1 
        net[start:(start+n_patients-1),:] = Q #concat each net together.
        #eigenvalue, eigenvector = pca(A, n_patients)
        #eigen_value_list_[start:(start+n_patients-1),:] = eigenvector;
    end
    #@show eigen_value_list_
    #@show typeof(eigen_value_list_)
    #verbal ? (@printf "PCA finished, computing beta vector") : nothing
    #eigenvalue, eigenvector = pca(net)
    U,S,V = svd(net)
    H = U * diagm(S)
    query = find(database.disease.==1)
    n_query = size(query,1)
    @show n_query
    num_cv_query = Int(floor((1-1/database.num_cv)*n_query))
    weights_mat = zeros(n_net, database.num_cv )
    β = V \ database.disease
    @showprogress 1 "Runing networks weights cv..." for i = 1:database.num_cv
        rand_index = randperm(n_query)
        rand_query = query[rand_index][1:num_cv_query]
        for j = 1:n_net
            base_query = (j-1) * n_query
            cov_list = cov(H[base_query+rand_query,:]',β)
            #@show cov_list
            weights_mat[j,i] = mean(cov_list)
        end
    end
    #@show weights_mat
    net_weights = vec(mean(weights_mat, 2))
    model.net_weights = net_weights/sum(net_weights)*100
    #@show model.net_weights
    model.H = H
    model.β = β
    #model.H = eigen_value_list_
    nothing
end

function get_params(params::MashupIntegration)
    
end
