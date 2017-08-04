

### SP: All of the .jl files need documentation.
###   a) add 1 line brief description of what the .jl file does
###   b) add a detailed description
###   c) what the input parameters are
###   d) what the function returns. The object type and a text description.
export 

    network_integration!, 
    MashupIntegration

### This file will contain many network integration algorithm
### I use dispatch to load them in same API.

"""
    network_integration!(model::MashupIntegration, database::GMANIA)

Implement modified mashup network integration.

Input: Database
Output: network weights.
"""
function network_integration!(model::MashupIntegration,
                              database::GMANIA;
                              random_seed = 23334)
    net_files = database.string_nets
    n_net = length(net_files)
    n_patients = database.n_patients
    net = zeros(n_patients * n_net, n_patients);
    eigen_value_list_ = zeros(n_patients*n_net,n_patients)

### SP: Add a newline break between each logical step of the code.
### makes it easier to read, understand, debug

    #@show eigen_value_list_
    println("$n_net networks loaded.")
    println("$n_patients patients loaded.")
   @showprogress 1 "Running diffusion...." for i = 1:n_net
        #verbal ? (@printf "Loading %s\n" net_files[i]) : nothing
        A = load_net(net_files[i], database)#load the similarirty net.

        #verbal ? (@printf "Running diffusion\n") : nothing
        Q = rwr(A, 0.5) #running random walk.
        # smooth or not?
        start = n_patients * (i-1)+1 
        if database.smooth == 1
            R = log(abs(Q) + 1/n_patients) #smoothing
            net[start:(start+n_patients-1),:] = R #concat each net together.
        else
            net[start:(start+n_patients-1),:] = Q
        end

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
    if reduced_dim < n_patients/10.0
        reduced_dim = trunc(Int, n_patients/10.0)
    end
    @show reduced_dim/n_patients


    #reduced_dim = 12
    H = U[:,1:reduced_dim] * diagm(S[1:reduced_dim])
    #V = V[:,1:reduced_dim]
    V = V[1:reduced_dim, :]


    query = find(database.disease.==database.query_attr)
    n_query = size(query,1)
    @show n_query


    num_cv_query = Int(ceil((1-1/database.num_cv)*n_query))
    weights_mat = zeros(n_net, database.num_cv )
    println("SVD finished, linear regression for β")


    β = V' \ database.disease
    @show β
    @show size(H)
    cv_query = zeros(num_cv_query, database.num_cv)
    temp = zeros(n_net, database.num_cv, num_cv_query)
    tally = zeros(Int, n_net)

### SP: move "for" to next line? Yes
### Set a RNG seed here to get results that you and I can reproduce.
    srand(random_seed)# add random seed so the result can be reproduced.
    if database.string_querys == nothing
        @showprogress 1 "Runing networks weights cv..." for i = 1:database.num_cv
            rand_index = randperm(n_query)
            rand_query = query[rand_index][1:num_cv_query]
            cv_query[:, i] = rand_query
            for j = 1:n_net
                base_query = (j-1) * n_query

    ### SP: Use correlation  (which is bounded by -1,1)
    ### instead of covariance?

                cov_list = cor(H[base_query+rand_query,:]',β)
                #temp[j, i, :] = cov_list
                weights_mat[j,i] = mean(cov_list)
            end
        end
    else
        println("Running cross validation for feature selection ")
        @showprogress 1 "Runing networks weights cv..." for i = 1:10
            rand_query = parse_query(database.string_querys[i], database.patients_index)
            cv_query[1:length(rand_query), i] = rand_query
            for j = 1:n_net
                base_query = (j-1) * n_query

    ### SP: Use correlation  (which is bounded by -1,1)
    ### instead of covariance?

                cov_list = cor(H[base_query+rand_query,:]',β)
                #temp[j, i, :] = cov_list
                weights_mat[j,i] = mean(cov_list)
                if weights_mat[j,i] > 0
                    tally[j] += 1
                end
            end
        end
    end

    #for i = 1:num_cv_query
    #    tem_str = @sprintf "result/ex3/networks_weights_each_cv_query_%sth.txt" i
    #    writedlm(tem_str, temp[:,:,i])
    #end


    model.cv_query = cv_query
    #@show weights_mat


    model.weights_mat = weights_mat
    net_weights = vec(mean(weights_mat, 2))
    model.net_weights = net_weights/sum(net_weights)*100


    #@show model.net_weights
    model.H = H
    model.β = β 
    model.tally = tally
    #model.H = eigen_value_list_
    nothing
end

"""
    network_integration!(model::RawMashupIntegration, database::GMANIA)

Implement Raw mashup network integration.

Input: Database
Output: Embedding for each node in the network.
"""
function network_integration!(model::RawMashupIntegration, database::GMANIA)
    net_files = database.string_nets
    n_net = length(net_files)
    n_patients = database.n_patients
    eigen_value_list_ = zeros(n_patients*n_net,n_patients)
    #@show eigen_value_list_
    #@show n_net
    RR_sum = zeros(n_patients, n_patients);
    @showprogress 1 "Running diffusion...." for i = 1:n_net
        #verbal ? (@printf "Loading %s\n" net_files[i]) : nothing
        A = load_net(net_files[i], database);#load the similarirty net.
        #verbal ? (@printf "Running diffusion\n") : nothing
        Q = rwr(A, 0.5);#running random walk.
        R = log(Q + 1/n_patients); #smoothing
        RR_sum = RR_sum + Q * Q'
    end
    A = 0
    Q = 0
    R = 0
    #eigenvalue, eigenvector = pca(net)
    d, V = eig(RR_sum)
    reduced_dim = 500
    d = d[1:reduced_dim]
    V = V[:, 1:reduced_dim]
    x = diagm(sqrt(sqrt())) * V'
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
