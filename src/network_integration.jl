

### SP: All of the .jl files need documentation.
###   a) add 1 line brief description of what the .jl file does
###   b) add a detailed description
###   c) what the input parameters are
###   d) what the function returns. The object type and a text description.
export network_integration!, 
    solve!,
    check

### This file will contain many network integration algorithm
### I use dispatch to load them in same API.

"""
    network_integration!(model::MashupIntegration, database::GMANIA)

Implement modified mashup network integration.

- Input: Database contained all the information needed to continue computation.
- Output: Network weights stored in model.
"""
function network_integration!(model::MashupIntegration,
                              database::Database;
                              random_seed::Int = 23334)
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
        if database.smooth
            R = log(Q + 1/n_patients) #smoothing
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

    # Perform SVD here
    println("Computing SVD")
    U,S,V = svd(net)


    # Find reducde dimension.
    #S_squared = S.^2
    S_sqrt = sqrt(S)
    model.singular_value_squared = S_sqrt

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
    query = find(database.disease.==database.query_attr)
    n_query = size(query,1)
    @show n_query

    # Define the number of query each cross validation round 
    num_cv_query = Int(ceil((1-1/database.num_cv)*n_query))
    weights_mat = zeros(n_net, database.num_cv)
    println("SVD finished, linear regression for β")

    # Linear regression for beta
    β = V \ database.disease
    writedlm("V.txt",V)
    writedlm("disease.txt",database.disease)
    @show β
    @show size(H)
    @show V * β - database.disease
    cv_query = zeros(num_cv_query, database.num_cv)
    temp = zeros(n_net, database.num_cv, num_cv_query)
    tally = zeros(Int, n_net)

    # add random seed so the result can be reproduced.
    #srand(random_seed)
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
    if database.string_querys != nothing
        println("Running cross validation for feature selection ")
        # Here we have 10 cross validation round
        @showprogress 1 "Runing networks weights cv..." for i = 1:10
            # Read query from genemnia's query file
            rand_query = parse_query(database.string_querys[i], database.patients_index)

            # Record the query ID
            cv_query[1:length(rand_query), i] = rand_query

            # For each network, we compute the weight using query
            for j = 1:n_net
                # Get network index in H matrix

                base_query = (j-1) * n_query

                # Here we compute the correlation of H and beta

                #cov_list = cor(H[base_query+rand_query,:]',β)
                vec_list = H[base_query+rand_query,:] * β
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
                #weights_mat[j,i] = mean(cov_list)
                weights_mat[j,i] = mean(vec_list)

                # If weight > 0, get the tally plus 1.
                if weights_mat[j,i] > 0
                    tally[j] += 1
                end
            end
        end
    else
    # If running for patient ranking
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

    #Get weights for each network
    net_weights = vec(mean(weights_mat, 2)) + 1
    model.net_weights = net_weights/sum(net_weights)*100

    combined_network = zeros(n_patients, n_patients)

    # Combine the netowkr using network weights
    @showprogress 1 "Integrate networks...." for i = 1:n_net

        A = load_net(net_files[i], database)#load the similarirty net.
        combined_networks = combined_networks + model.net_weights[i] * A
    end

    # save the result into integration model
    model.combined_network = combined_network
    model.cv_query = cv_query
    model.weights_mat = weights_mat
    model.H = H
    model.β = β 
    model.tally = tally
    nothing
end


"""
    network_integration!(model::GeneMANIAIntegration, database::GMANIA)

Implement Raw mashup network integration.

Input: Database
Output: Embedding for each node in the network.
"""
function network_integration!(model::GeneMANIAIntegration, database::Database)
    net_files = database.string_nets
    n_net = length(net_files)
    n_patients = database.n_patients
    eigen_value_list_ = zeros(n_patients*n_net,n_patients)
    #@show eigen_value_list_
    #@show n_net
    RR_sum = zeros(n_patients, n_patients);

    index_pos = find(database.disease .== 1)
    index_neg = find(database.disease .== -1)
    num_pos = length(index_pos)
    num_neg = length(index_neg)
    num_pos_pos = num_pos * (num_pos - 1)
    num_pos_neg = 2 * num_pos * num_pos
    bias_val = 1/(num_pos_pos + num_pos_neg)
    pos_const = 2 * num_neg / (num_pos + num_neg)
    neg_const = -2 * num_pos / (num_pos + num_neg)
    pos_pos_target = pos_const * pos_const
    pos_neg_target = pos_const * neg_const

    KtK = zeros(n_net, n_net)
    KtT = zeros(n_net)

    KtK[1,1] = bias_val
    sum_of_targets = pos_pos_target * num_pos_pos + pos_neg_target * num_pos_neg
    KtT[1] = bias_val * sum_of_targets

    Wpp = zeros(n_net, num_pos, num_pos)
    Wpn = zeors(n_net, num_pos, num_neg)

    old_mode = false
    scaled = true

    @showprogress 1 "Computing network weights...." for i = 1:n_net
        #Load the sim matrix
        A = load_net(net_files[i], database);

        Wpp[i] = A[index_pos, index_pos]
        Wpn[i] = A[index_pos, index_neg]

        ss_Wpp = sum(Wpp[i])
        ss_Wpn = sum(Wpp[i])

        KtT[i] = pos_pos_target * ss_Wpp + 2 * pos_neg_target * ss_Wpn
        KtK[i, 1] = bias_val * (ss_Wpp + 2 * ss_Wpn)
        KtK[1, i] = KtK[i, 0]

        for j = 1 : i

            sum_of_prods = 0
            sum_of_prods += sum(Wpp[i] .* Wpp[j])
            sum_of_prods += 2 *  sum(Wpn[i] .* Wpn[j])

            KtK[i,j] = sum_of_prods
            KtK[j,i] = sum_of_prods
        end

    end

    solve!(KtK, KtT, database, model)
end


function solve!(KtK::Matrix, KtT::Vector, 
    database::Database, model::GeneMANIAIntegration)
    check(KtK, KtT, database)

    ss = abs(sum(KtK, 2))
    max_ss = norm(ss, Inf)

    epsilon = eps()
    delta = 1e-16

    gt_ind = find(ss .> max_ss * epsilon)

    KtK_clean = KtK[gt_ind,gt_ind]
    KtT_clean = KtT[gt_ind]

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


function check(KtK::Matrix, KtT::Vector, database::Database)
    n = size(KtK,1)
    @assert n == size(KtK, 2)
    @assert n == length(KtT)
    @assert length(database.string_nets)

end
