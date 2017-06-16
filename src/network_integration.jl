

export 

    network_integration!, 
    MashupIntegration

abstract IgAbstractParams

#IgParams(args...;kwargs...) = NetworkIntegration(args...;kwargs...)

type MashupIntegration <: IgAbstractParams
    β::Vector
    eigenvalue_list::Matrix
end

MashupIntegration() = MashupIntegration(Vector(), Matrix())

function network_integration!(model::MashupIntegration, database::GMANIA)
    net_files = database.string_nets
    n_net = length(net_files)
    n_patients = database.n_patients
    net = zeros(n_patients * n_net, n_patients);
    eigen_value_list_ = zeros(n_patients,length(net_files))
    #@show eigen_value_list_
    @showprogress 1 "Running diffusion...." for i = 1:length(net_files)
        #verbal ? (@printf "Loading %s\n" net_files[i]) : nothing
        A = load_net(net_files[i], database);#load the similarirty net.
        #verbal ? (@printf "Running diffusion\n") : nothing
        Q = rwr(A, 0.5);#running random walk.
        #R = log(Q + 1/n_patiens); % smoothing
        start = n_patients * (i-1)+1 
        net[start:(start+n_patients-1),:] = Q #concat each net together.
        eigenvalue, eigenvector = pca(A, n_patients)
        A = 0
        Q = 0
        #if length(eigenvalue) == n_patients - 1
        #    latent = [latent;0];
        #end
        eigen_value_list_[:,i] = eigenvalue;
    end
    #@show eigen_value_list_
    #@show typeof(eigen_value_list_)
    #verbal ? (@printf "PCA finished, computing beta vector") : nothing
    eigenvalue, eigenvector = pca(net)
    model.β = eigenvector \ database.disease
    model.eigenvalue_list = eigen_value_list_

    nothing
end

function get_params(params::MashupIntegration)
    
end
