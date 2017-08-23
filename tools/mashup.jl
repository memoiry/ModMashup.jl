
#=
    This is the commnand line
    tool used by R's netDX 
            package 
=#            
using ArgParse
using ModMashup

#=
                        Example 
 Usage 1: 
                Mashup Feature Selection
 julia mashup.jl feature_selection --net net_dir --id ids.txt 
 --target target.txt --CV_query query_dir --smooth true 
 --res_dir res_dir


 Usage 2: 
                 GeneMANIA query runner
 julia mashup.jl query_runner --net net_dir --id ids.txt 
 --target target.txt --CV_query query_dir --smooth true 
 --res_dir res_dir
=# 


# Function to parse the arguments
function parse_commandline()
    s = ArgParseSettings()
    @add_arg_table s begin
        "command"
            help = "what function do you want to use? ie. feature_selection, query_runner"
            arg_type = String
            required = true
        "--net"
            help = "Folder name where the similarity network is stored"
            arg_type = String
            required = true
        "--id"
            help = "Patients name in the database"
            arg_type = String
            required = true
        "--labels"
            help = "Query file name"
            arg_type = String
            default = "nothing"
        "--CV_query"
            help = "Folder name where Query files stored"
            arg_type = String
        "--top_net"
            help = "Folder name where Query files stored"
            arg_type = String
            default = "nothing"
        "--smooth"
            help = "smooth the net or not"
            arg_type = Bool
            default = true
        "--res_dir"
            help = "where to put the result"
            arg_type = String
        "--cut_off"
            help = "where to put the result"
            arg_type = Int
            default = 9
    end

    return parse_args(s)
end


# Function to print the dict
function print_dict(dict_::Dict)
    tmp = Vector()
    for i in keys(dict_)
        net_string = split(i,"/")[end]
        #println(net_string," => ", dict_[i], " %")
        push!(tmp, (net_string, dict_[i]))
    end
    return tmp
end

# Function to print the pair
function print_pair(pair_)
    tmp = Vector()
    count = 0
    for i in 1:length(pair_)
        net_string = split(pair_[i][1], "/")[end]
        #count +=1 
        #if count < 100
        #    println(net_string," => ",pair_[i][2], " %")
        #end
        push!(tmp, (net_string, pair_[i][2]))
    end
    return tmp
end

# Format the score dictionary into GeneMANIA's NRANK file
function print_patient_rank(score, database)
    inverse_index = database.inverse_index
    patients_index = database.patients_index
    n_patients = database.n_patients
    labels = database.labels
    unlabeled_name = map(x -> x[1], score)
    prank = Vector()
    push!(prank   ,("Gene","Score","Description"))    
    for i = 1:n_patients
        patients_name = inverse_index[i]
        if labels[i] == 1
            push!(prank, (patients_name, "", patients_name))
        end
    end

    for i in 1:length(score)
        net_string = score[i][1]
        id_ = patients_index[net_string]
        #@show labels, id_
        if labels[id_] == -1
            push!(prank, (net_string, score[i][2], net_string))
        end
    end

    return prank
end

function main()
    println("Started the program")
    parsed_args = parse_commandline()
    println("Parsed args:")
    for (arg,val) in parsed_args
        println("  $arg  =>  $val")
    end
    #Running feature selection for mashup
    if parsed_args["command"] == "selection"
        # parse arguments
        dir = parsed_args["net"]
        labels = parsed_args["labels"]
        querys = parsed_args["CV_query"]
        id = parsed_args["id"]
        smooth = parsed_args["smooth"]
        top_net = parsed_args["top_net"]
        res_dir = parsed_args["res_dir"]
        cut_off = parsed_args["cut_off"]

        println(" ")
        println("========================================")
        println("Start running network selection ")
        println("========================================")
        println(" ")

        # Construct the dabase, which contains the preliminary file.
        database = ModMashup.Database(dir, id,
                                    querys, labels_file = labels,
                                    smooth = smooth,
                                    int_type = :selection,
                                    top_net = top_net)

        # Define the algorithm you want to use to integrate the networks
        model = ModMashup.MashupIntegration()

        # Running network integration
        ModMashup.network_integration!(model, database)

        net_weights = ModMashup.get_weights(model)
        tally = ModMashup.get_tally(model)

        # Start Processing the result
        net_index = Dict()

        # Match each networks with its id
        for i = 1:length(database.string_nets)
            net_name = database.string_nets[i]
            net_true_name = split(net_name,".")[1]
            net_index[net_true_name] = i
        end

        # Sort the networks weights 
        net_weights = sort(collect(net_weights),by = x->x[2], rev=true)
        tally = sort(collect(tally),by = x->x[2], rev=true)

        # Print the result here
        println("============================Start printing result.........================")
        #Format the result for printing
        view_weights = print_pair(net_weights)
        #view_score = print_pair(score)
        view_tally = print_pair(tally)
        view_net_index = print_dict(net_index)
        top_tally_networks = filter(x -> x[2] >= cut_off, view_tally)
        top_tally_networks = map(x -> x[1], top_tally_networks)
        length(top_tally_networks)

        
        println("======================================End================================")
        # Save the result
        # Smooth or not?
        result_dir = smooth == 1 ? "$(res_dir)/smooth_result" : "$(res_dir)/no_smooth_result"
        if !isdir(result_dir)
            mkdir(result_dir)
        end
        println("Saving the result...Please wait")

        # Save the result and write them into text files
        #writedlm("$(result_dir)/patient_score_with_name.txt", view_score)
        writedlm("$(result_dir)/networks_weights_with_name.txt", view_weights)
        writedlm("$(result_dir)/mashup_tally.txt", view_tally)
        writedlm("$(result_dir)/top_networks.txt", top_tally_networks)

        writedlm("$(result_dir)/networks_index.txt", view_net_index)
        writedlm("$(result_dir)/cv_query.txt",model.cv_query)
        writedlm("$(result_dir)/beta.txt",model.β)
        #writedlm("$(result_dir)/H.txt",model.H)
        writedlm("$(result_dir)/networks_weights_each_cv.txt",model.weights_mat)
        writedlm("$(result_dir)/singular_value_sqrt.txt",model.singular_value_sqrt)
        println("Saved...")

    # This part is left for patient ranling part of netdx.
    # Still unfinished. 
    elseif parsed_args["command"] == "ranking"
        
        dir = parsed_args["net"]
        querys = parsed_args["CV_query"]
        id = parsed_args["id"]
        smooth = parsed_args["smooth"]
        top_net = parsed_args["top_net"]
        res_dir = parsed_args["res_dir"]

        println(" ")
        println("========================================")
        println("Start running label propagation for patients ranking")
        println("========================================")
        println(" ")

        # Construct the dabase, which contains the preliminary file.
        database = ModMashup.Database(dir, id, 
            querys, smooth = smooth,
            int_type = :ranking,
            top_net = top_net)

        # Define the algorithm you want to use to integrate the networks
        int_model = ModMashup.MashupIntegration()
        lp_model = ModMashup.LabelPropagation(verbose = true)

        # Running network integration
        ModMashup.fit!(int_model, lp_model, database)

        # Pick up the result
        #combined_network = ModMashup.get_combined_network(int_model)
        net_weights = ModMashup.get_weights(int_model)
        score = ModMashup.get_score(lp_model)

        # Sort the networks weights 
        net_weights = sort(collect(net_weights),by = x->x[2], rev=true)
        score = sort(collect(score),by = x->x[2], rev=true)

        # Print the result here
        println("============================Start printing result.........================")
        #Format the result for printing
        view_weights = print_pair(net_weights)
        view_score = print_patient_rank(score, database)
        
        println("======================================End================================")
        # Save the result
        # Smooth or not?
        score = smooth ? "$(querys)_smooth_mashup_PRANK.txt" : "$(querys)_no_smooth_mashup_PRANK.txt"
        network_weight = smooth ? "$(querys)_smooth_mashup_NRANK.txt" : "$(querys)_no_smooth_mashup_NRANK.txt"


        println("Saving the result...Please wait")

        # Save the result and write them into text files
        writedlm("$(score)", view_score)
        writedlm("$(network_weight)", view_weights)
        println("Saved...")
    else
        error("Please provide correct command.")
    end
end

main()

