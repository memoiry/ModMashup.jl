

export network_integration!, 
    solve!,
    check

### This file will contain many network integration algorithm
### I use dispatch to load them in same API.

####################################################
# Mashup network integration Method Implementation #
####################################################

"""
    network_integration!(model::MashupIntegration, database::GMANIA)

Implement modified mashup network integration. Result will be save in the model.
See [`MashupIntegration`](@ref) for more information about the result.

# Arguments

`model::MashupIntegration`: Label Propagation model.

`database::Database`: store general information about the patients.

# Output

`model::LabelPropagation`: Result will be saved in the model fileds.
"""
function network_integration!(model::MashupIntegration,
                              database::Database)
    net_files = database.string_nets
    #@show net_files
    n_net = length(net_files)
    n_patients = database.n_patients
    net = SharedArray{Float64}(n_patients * n_net, n_patients)
    eigen_value_list_ = zeros(n_patients*n_net,n_patients)

    #@show eigen_value_list_
    println("$n_net networks loaded.")
    println("$n_patients patients loaded.")
    println("Running diffusion....")
    tic()
    if database.smooth
        Threads.@threads for i = 1:n_net
            #verbal ? (@printf "Loading %s\n" net_files[i]) : nothing
            A = load_net(net_files[i], database)#load the similarirty net.
            #verbal ? (@printf "Running diffusion\n") : nothing
            Q = rwr(A, 0.5) #running random walk.
            # smooth or not?
            start = n_patients * (i-1)+1 
            R = log(Q + 1/n_patients) #smoothing
            net[start:(start+n_patients-1),:] = R #concat each net together.
            #eigenvalue, eigenvector = pca(A, n_patients)
            #eigen_value_list_[start:(start+n_patients-1),:] = eigenvector;
        end
    else
        Threads.@threads for i = 1:n_net
            #verbal ? (@printf "Loading %s\n" net_files[i]) : nothing
            A = load_net(net_files[i], database)#load the similarirty net.
            #verbal ? (@printf "Running diffusion\n") : nothing
            Q = rwr(A, 0.5) #running random walk.
            # smooth or not?
            start = n_patients * (i-1)+1 
            net[start:(start+n_patients-1),:] = Q
            #eigenvalue, eigenvector = pca(A, n_patients)
            #eigen_value_list_[start:(start+n_patients-1),:] = eigenvector;
        end
    end

    print("Diffusion done, ")
    toc()

    # Perform SVD here
    println("Computing SVD")
    U,S,V = svd(full(net))


    # Find reducde dimension.
    #S_squared = S.^2
    S_sqrt = sqrt(S)
    model.singular_value_sqrt = S_sqrt

    println("Get 0.9 ratio")
    tmp = cumsum(S_sqrt)/sum(S_sqrt).>0.9
    reduced_dim = find(tmp)[1]
    @show reduced_dim
    @show reduced_dim/n_patients

    # Force the reduced dim to 0.1 ratio if lower than this level

    if reduced_dim < n_patients/10.0
        reduced_dim = trunc(Int, n_patients/10.0)
    end

    # Reconstruct H and V matrix using reduced dim
    H = U[:,1:reduced_dim] * diagm(S_sqrt[1:reduced_dim])
    H = [H ones(size(H, 1))]
    V = (diagm(S_sqrt[1:reduced_dim]) * V[1:reduced_dim, :])'
    V = [V ones(size(V, 1))]

    # Use 0 or 1 as query
    query = find(database.labels.==database.query_attr)
    n_query = size(query,1)
    @show n_query


    println("SVD finished, linear regression for β")

    # Linear regression for beta
    β = V \ database.labels


    # Define the number of query each cross validation round 
    num_cv_query = Int(ceil((1-1/10)*n_query))
    cv_query = zeros(num_cv_query, database.num_cv)
    # If for ranking, all query sample is used as positive
    if database.int_type == :ranking
        num_cv_query = n_query
        cv_query = zeros(num_cv_query, database.num_cv)
    end

    weights_mat = zeros(n_net, database.num_cv)
    tally = zeros(Int, n_net)

    # add random seed so the result can be reproduced.
    #protection
    #test_string = ["SIGNALING_EVENTS_MEDIATED_BY_HDAC_CLASS_II_cont.txt",
    #"BIOCARTA_PDGF_PATHWAY_cont.txt",
    #"REGULATION_OF_RETINOBLASTOMA_PROTEIN_cont.txt",
    #"SUPERPATHWAY_OF_CHOLESTEROL_BIOSYNTHESIS_cont.txt",
    #"SUMOYLATION_cont.txt",
    #"BASE_EXCISION_REPAIR_cont.txt",
    #"ACETYLCHOLINE_NEUROTRANSMITTER_RELEASE_CYCLE_cont.txt",
    #"BIOCARTA_EIF4_PATHWAY_cont.txt",
    #"PDGFR-BETA_SIGNALING_PATHWAY_cont.txt",
    #"CLASS_I_MHC_MEDIATED_ANTIGEN_PROCESSING___PRESENTATION_cont.txt"]
    #test_string = ["CONSTITUTIVE_SIGNALING_BY_LIGAND-RESPONSIVE_EGFR_CANCER_VARIANTS_cont.txt",
    #"FORMATION_OF_ATP_BY_CHEMIOSMOTIC_COUPLING_cont.txt",
    #"SYNTHESIS_OF_IP3_AND_IP4_IN_THE_CYTOSOL_cont.txt",
    #"INTERNALIZATION_OF_ERBB1_cont.txt",
    #"SA_PROGRAMMED_CELL_DEATH_cont.txt",
    #"HYPOXIA_RESPONSE_VIA_HIF_ACTIVATION_cont.txt",
    #"E-CADHERIN_SIGNALING_IN_KERATINOCYTES_cont.txt",
    #"REELIN_SIGNALING_PATHWAY_cont.txt",
    #"BIOCARTA_PARKIN_PATHWAY_cont.txt",
    #"G_PROTEIN_GATED_POTASSIUM_CHANNELS_cont.txt"]
    #test_box = Dict{String, Vector}()
    #for sym in test_string
    #    test_box[sym] = Vector{Float64}()
    #end
    ## Protection

    # If running for feature selection
    if database.int_type == :selection
        println("Running cross validation for feature selection ")
        println("Got $(database.num_cv) round query files")

        # Start using cross validation to get network weights
        println("Runing networks weights cv...")
        tic()
        @simd for i = 1:database.num_cv

            # Read query from genemnia's query file
            rand_query = parse_query(database.string_querys[i], database.patients_index)

            # Record the query ID
            cv_query[1:length(rand_query), i] = rand_query

            # For each network, we compute the weight using query
            @simd for j = 1:n_net
                # Get specific network index in H matrix
                base_query = (j-1) * n_query

                # Here we compute the correlation of H and beta
                @inbounds cov_list = cor(H[base_query+rand_query,:]',β)

                # dot product to represent the weight
                #vec_list = H[base_query+rand_query,:] * β

                #protection
                # Aux func for statistics, just ignore here
                #split_str = split(net_files[j], "/")[end]
                #for k = 1:10
                #    top_string_ = test_string[k]
                #    if split_str == top_string_
                #        append!(test_box[top_string_], cov_list)
                #    end
                #end
                #protection

                # Get the mean to represent the weight
                weights_mat[j,i] = mean(cov_list)

                #weights_mat[j,i] = mean(vec_list)

                # If weight > 0, get the tally plus 1.
                #if weights_mat[j,i] < 0
                #    tally[j] += 1
                #end
            end
        end
    elseif database.int_type == :ranking
        # If running for patient ranking

        # Read query from genemnia's query file
        # Record the query ID
        cv_query[1:length(query), 1] = query
        println("Runing networks weights cv...")

        tic()
        Threads.@threads for j = 1:n_net
            # Get specific network index in H matrix
            base_query = (j-1) * n_query

            # Compute network weight using correlation
            cov_list = cor(H[base_query+query, :]',β)

            # Mean across each query to acquire final 
            # network weight.
            weights_mat[j,1] = mean(cov_list)
        end
    else
        error("Unexpected integration type!")
    end
    print("Cross validation done, ")
    toc()

    # Generate network tally 
    # +1 for those top 10% network
    for i = 1:database.num_cv
        num_90 = percentile(weights_mat[:, i], 90)
        for j = 1:n_net
            if weights_mat[j, i] > num_90
                tally[j] += 1
            end
        end
    end


    # Save the box result for statistics
    # Just Ignore there
    #max_length = 0
    #for i in keys(test_box)
    #    vec_ = test_box[i]
    #    if length(vec_) > max_length
    #        max_length = length(vec_)
    #    end
    #end
    #tmp = zeros(max_length,10)##

    #@show test_box
    #for (ind,i) in enumerate(keys(test_box))
    #    temp_index = find(x -> x == i ,test_string)
    #    vec_ = test_box[i]
    #    tmp[1:length(vec_),temp_index] = vec_
    #end
    #writedlm("test_box_smooth.txt", tmp)

    #Protection here

    #for i = 1:num_cv_query
    #    tem_str = @sprintf "result/ex3/networks_weights_each_cv_query_%sth.txt" i
    #    writedlm(tem_str, temp[:,:,i])
    #end

    #Get mean weights for each network
    # +1 to avoid negative weight
    net_weights = vec(mean(weights_mat, 2)) + 1
    # Normalize the weight
    net_weights = net_weights/sum(net_weights)*100

    # Generate a dictionary to map network name to its normalized weight
    # and also map network tally.
    for i = 1:length(database.string_nets)
        net_name = database.string_nets[i]
        net_true_name = split(net_name,".")[1]
        model.net_weights[net_true_name] = net_weights[i]
        model.tally[net_true_name] = tally[i]
    end

    # Combine the netowkr using network weights
    combined_network = zeros(n_patients, n_patients)
    # Combined only for ranking
    if database.int_type == :ranking
        println("Integrate networks....")
        Threads.@threads for i = 1:n_net
            #load the similarirty net.
            net_name = database.string_nets[i]
            net_true_name = split(net_name,".")[1]
            A = load_net(net_name, database)
            combined_network = combined_network + model.net_weights[net_true_name] / 100 * A
        end
        model.combined_network = combined_network
    end

    # save the result into the mashup integration model
    model.cv_query = cv_query
    model.weights_mat = weights_mat
    model.H = H
    model.β = β 
    nothing
end


"""
    network_integration!(model::GeneMANIAIntegration, database::GMANIA)

Implement Raw mashup network integration. Result will be saved in the model.
See [`GeneMANIAIntegration`](@ref) for more information about the result.
"""
function network_integration!(model::GeneMANIAIntegration, database::Database)
    net_files = database.string_nets
    n_net = length(net_files)
    n_feature = n_net + 1
    n_patients = database.n_patients
    #eigen_value_list_ = zeros(n_patients*n_net,n_patients)
    #@show eigen_value_list_
    label_vec = ones(Int, n_patients) * -1
    rand_query = parse_query(database.string_querys[1], database.patients_index)
    label_vec[rand_query] = 1
    @show n_net
    @show label_vec
    RR_sum = zeros(n_patients, n_patients);

    index_pos = find(label_vec .== 1)
    index_neg = find(label_vec .== -1)
    num_pos = length(index_pos)
    num_neg = length(index_neg)
    num_pos_pos = num_pos * (num_pos - 1)
    num_pos_neg = 2 * num_pos * num_pos
    bias_val = 1/(num_pos_pos + num_pos_neg)
    pos_const = 2 * num_neg / (num_pos + num_neg)
    neg_const = -2 * num_pos / (num_pos + num_neg)
    pos_pos_target = pos_const * pos_const
    pos_neg_target = pos_const * neg_const

    KtK = zeros(n_feature, n_feature)
    KtT = zeros(n_feature)

    KtK[1,1] = bias_val
    sum_of_targets = pos_pos_target * num_pos_pos + pos_neg_target * num_pos_neg
    KtT[1] = bias_val * sum_of_targets

    Wpp = zeros(n_feature, num_pos, num_pos)
    Wpn = zeros(n_feature, num_pos, num_neg)

    old_mode = false
    scaled = true

    Threads.@threads for i = 2:n_feature
        #Load the sim matrix
        A = load_net(net_files[i-1], database);

        Wpp[i, :, :] = A[index_pos, index_pos]
        Wpn[i, :, :] = A[index_pos, index_neg]

        ss_Wpp = sum(Wpp[i, :, :])
        ss_Wpn = sum(Wpn[i, :, :])

        KtT[i] = pos_pos_target * ss_Wpp + 2 * pos_neg_target * ss_Wpn
        KtK[i, 1] = bias_val * (ss_Wpp + 2 * ss_Wpn)
        KtK[1, i] = KtK[i, 1]

        for j = 2 : i

            sum_of_prods = 0
            sum_of_prods += sum(Wpp[i, :, :] .* Wpp[j, :, :])
            sum_of_prods += 2 *  sum(Wpn[i, :, :] .* Wpn[j, :, :])

            KtK[i,j] = sum_of_prods
            KtK[j,i] = sum_of_prods
        end

    end

    solve!(KtK, KtT, database, model)
end

"""
    solve!(KtK::Matrix, KtT::Vector, 
    database::Database, model::GeneMANIAIntegration)

Generic Solver for weighting methods computes inverse using QR
factorization (apparently KtK is ill conditioned for original method)
removes row and column of corresponding negative weights and recomputes
until all weight are positive. 

The first column of (the implicit feature matrix) K is assumed to be the bias
"""
function solve!(KtK::Matrix, KtT::Vector, 
    database::Database, model::GeneMANIAIntegration)
    check(KtK, KtT, database)

    ss = abs(sum(KtK, 2))
    @show ss
    max_ss = norm(ss, Inf)
    @show max_ss

    epsilon = eps()
    delta = 1e-16

    gt_ind = find(ss .> max_ss * epsilon)
    @show gt_ind

    KtK_clean = KtK[gt_ind,gt_ind]
    KtT_clean = KtT[gt_ind]
    @show size(KtT_clean)
    @show size(KtK_clean)

    reg_const = 1.0
    if model.reg
        for i = 1 : size(KtK_clean,1)
            KtK_clean[i,i] = KtK_clean[i,i] + reg_const
        end
    end

    done_ = false
    alpha = zeros(length(KtT_clean))

    while(!done_)

        alpha = zeros(length(KtT_clean))
        temp = zeros(length(KtT_clean))
        temp2 = zeros(length(KtT_clean))

        Q, R, P = qr(KtK_clean, Val{true})
        temp = At_mul_B(Q, KtT_clean)
        temp2 = R \ temp
        for i = 1 : length(P)
            alpha[P[i]] = temp2[i]
        end

        total_weights = length(alpha)
        pos_weights = find(alpha .>= delta)
        pos_weights = filter(x -> x!= 1, pos_weights)

        @assert length(pos_weights) != 0
        if length(pos_weights) == total_weights -1
            break
        end

        pos_weights = [1;pos_weights]
        KtK_clean = KtK_clean[pos_weights, pos_weights]
        KtT_clean = KtT_clean[pos_weights]
        gt_ind = gt_ind[pos_weights]
    end

    temp_sum = 0

    for i = 1:length(gt_ind)
        if gt_ind[i] == 1
            continue
        end
        weight = alpha[i]
        temp_sum = temp_sum + weight
        net_string = database.string_nets[gt_ind[i]]
        model.net_weights[net_string] = weight
    end

    if model.normalized
        for i in keys(model.net_weights)
            model.net_weights[i] = model.net_weights[i] / temp_sum
        end
    end
end

"""
    check(KtK::Matrix, KtT::Vector, database::Database)

Check the validation of KtK and KtT.
"""
function check(KtK::Matrix, KtT::Vector, database::Database)
    n = size(KtK,1)
    @assert n == size(KtK, 2)
    @assert n == length(KtT)
    @assert n == length(database.string_nets)+1

end
