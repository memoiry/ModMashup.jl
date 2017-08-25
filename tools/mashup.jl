
#=
    This is the commnand line
    tool used by R's netDX 
            package 
=#            
using ArgParse
using ModMashup

# this scsript can be called with two modes, 
# One is network selection.
# One is patients ranking.

#=
                        Example 
 Usage 1 - network selection: 
                Mashup Feature Selection
 julia mashup.jl selection --net networks 
 --id ids.txt --labels target.txt 
 --CV_query . --smooth true --res_dir temp_res


 Usage 2 - patients ranking: 
          Mashup query runner for patient ranking
julia mashup.jl ranking --top_net top_networks.txt 
--net networks --id ids.txt --CV_query CV_1.query 
--smooth true --res_dir temp_res
=# 


# Function to parse the arguments
function parse_commandline()
    s = ArgParseSettings()
    @add_arg_table s begin
        "command"
            help = "what function do you want to use? ie. selection, ranking"
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
            help = "If for selection, it should be labels file name. If for ranking, it should be query file name and we use it to label patients."
            arg_type = String
            default = "nothing"
        "--CV_query"
            help = "If for selection, folder name where Query files stored. If for ranking, single query file name for use to label patients"
            arg_type = String
        "--top_net"
            help = "This keyword is used for ranking, it should be file containing selected networks name."
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
            help = "cut_off to select top ranked network in network integration"
            arg_type = Int
            default = 9
    end

    return parse_args(s)
end


# Function to print the dict
function print_dict(dict_::Dict)
    lines = Vector()
    for i in keys(dict_)
        net_string = split(i,"/")[end]
        push!(lines, (net_string, dict_[i]))
    end
    return lines
end

# Format dictionary to printable structure
function print_pair(pair_)
    lines = Vector()
    count = 0
    for i in 1:length(pair_)
        net_string = split(pair_[i][1], "/")[end]
        push!(lines, (net_string, pair_[i][2]))
    end
    return lines
end

# Format the score dictionary to pritable file that could be 
# write into into GeneMANIA's NRANK file
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


#---------------------------------------------------------------
# Option "selection": feature selection for mashup
#---------------------------------------------------------------
    #Running feature selection for mashup
    if parsed_args["command"] == "selection"
        # parse arguments
        network_dir = parsed_args["net"]
        labels = parsed_args["labels"]
        query_dir = parsed_args["CV_query"]
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
        # Check http://memoiry.me/ModMashup.jl/algo/database.html for 
        # contructor usage.
        # Construct the dabase, which contains the preliminary file.
        database = ModMashup.Database(network_dir, id,
                                    query_dir, labels_file = labels,
                                    smooth = smooth,
                                    int_type = :selection,
                                    top_net = top_net)

        # Define the algorithm you want to use to integrate the networks
        # model is used for generic methods(network_integration! here) to find how to implementt 
        # corresponding algorith.
        model = ModMashup.MashupIntegration()

        # Running network integration, which is where mashup algorithm is implemented
        ModMashup.network_integration!(model, database)

        # Acquire a dictionary mapping networks name to its weight
        net_weights = ModMashup.get_weights(model)

        # Acquire a dictionary mapping networks name to its tally
        tally = ModMashup.get_tally(model)

        # Start Processing the result
        # net_index is a dictionary mapping networks name to its inernal id in database 
        # for futher reference.
        net_index = Dict()

        # Match each networks with its id
        for i = 1:length(database.string_nets)
            net_name = database.string_nets[i]
            net_true_name = split(net_name,".")[1]
            net_index[net_true_name] = i
        end

        # Sort the networks weights and tally
        net_weights = sort(collect(net_weights),by = x->x[2], rev=true)
        tally = sort(collect(tally),by = x->x[2], rev=true)

        # Format the result for printing since net_weights and tally both are dictionary
        # view_ variable is just a structure making it easy to print the dictionary
        view_weights = print_pair(net_weights)
        view_tally = print_pair(tally)
        view_net_index = print_dict(net_index)

        # Filter tally lower than cut-off
        top_tally_networks = filter(x -> x[2] >= cut_off, view_tally)
        top_tally_networks = map(x -> x[1], top_tally_networks)

        # Get resut directory
        result_dir = smooth == 1 ? "$(res_dir)/smooth_result" : "$(res_dir)/no_smooth_result"
        if !isdir(result_dir)
            mkdir(result_dir)
        end
        println("Saving the result...Please wait")


        # Print the network tally, weights and a various of results here

        # Save the result and write them into text files
        # Txt file mapping networks name to its weights
        writedlm("$(result_dir)/networks_weights_with_name.txt", view_weights)
        # Txt file mapping networks name to its tally 
        writedlm("$(result_dir)/mashup_tally.txt", view_tally)
        # Txt file containing selected networks after cross validation
        writedlm("$(result_dir)/top_networks.txt", top_tally_networks)

        # Below are some internal result for reference
        # Txt file mapping networks name to its internal id
        writedlm("$(result_dir)/networks_index.txt", view_net_index)
        # Txt file containing query internal id of each cross validation 
        writedlm("$(result_dir)/cv_query.txt",model.cv_query)
        # Txt file containing beta vector
        writedlm("$(result_dir)/beta.txt",model.β)
        # Txt file containing H matrix, this file is huge so I comment it,
        # If you want to generate it for reference, just uncomment it.
        #writedlm("$(result_dir)/H.txt",model.H)
        # Txt file containing network weights of each cross validaiton 
        writedlm("$(result_dir)/networks_weights_each_cv.txt",model.weights_mat)
        # Txt file containing sqrt of singular value.
        writedlm("$(result_dir)/singular_value_sqrt.txt",model.singular_value_sqrt)
        println("Saved...")

# This part is left for patient ranling part of netdx.
#---------------------------------------------------------------
# Option "ranking": patients ranking for mashup
#---------------------------------------------------------------
    elseif parsed_args["command"] == "ranking"
        
        network_dir = parsed_args["net"]
        query = parsed_args["CV_query"]
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
        database = ModMashup.Database(network_dir, id, 
            query, smooth = smooth,
            int_type = :ranking,
            top_net = top_net)

        # Define the algorithm you want to use to integrate the networks
        # Two types model is used for generic methods to find how to implementt 
        # corresponding algorith.
        int_model = ModMashup.MashupIntegration()
        lp_model = ModMashup.LabelPropagation(verbose = true)

        # Running network integration and patient ranking
        # fit is just a pipeline function to run both network integration 
        # and label progation
        # Running network integration and label progation
        ModMashup.fit!(int_model, lp_model, database)

        # Pick up the result
        # You can pick up combined integration network through function below
        # For ranking, we do not need that so I have commented it.
        #combined_network = ModMashup.get_combined_network(int_model)

        # Acquire a dictionary mapping networks name to its weight
        net_weights = ModMashup.get_weights(int_model)
        # Acquire a dictionary mapping patients name to their score
        score = ModMashup.get_score(lp_model)

        # Sort the networks weights 
        net_weights = sort(collect(net_weights),by = x->x[2], rev=true)
        score = sort(collect(score),by = x->x[2], rev=true)

        ## Format the result for printing since net_weights and score both are dictionary
        # view_ variable is just a structure making it easy to print the dictionary
        #Format the result for printing
        
        view_weights = print_pair(net_weights)
        view_score = print_patient_rank(score, database)
        
        # Save the result
        # Smooth or not?
        # Generate result file name 
        score = smooth ? "$(query)_smooth_mashup_PRANK.txt" : "$(query)_no_smooth_mashup_PRANK.txt"
        network_weight = smooth ? "$(query)_smooth_mashup_NRANK.txt" : "$(query)_no_smooth_mashup_NRANK.txt"


        println("Saving the result...Please wait")

        # Save the result and write them into text files

        # Txt file mapping patients name to their weights
        writedlm("$(score)", view_score)

        # Txt file mapping networks name to its weights
        writedlm("$(network_weight)", view_weights)
        println("Saved...")
    else
        error("Please provide correct command.")
    end
end

main()

