
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
        "--target"
            help = "Query file name"
            arg_type = String
        "--CV_query"
            help = "Folder name where Query files stored"
            arg_type = String
        "--smooth"
            help = "smooth the net or not"
            arg_type = Bool
            default = true
        "--res_dir"
            help = "where to put the result"
            arg_type = String
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
        count +=1 
        if count < 100
            println(net_string," => ",pair_[i][2], " %")
        end
        push!(tmp, (net_string, pair_[i][2]))
    end
    return tmp
end


function main()
    parsed_args = parse_commandline()
    println("Parsed args:")
    for (arg,val) in parsed_args
        println("  $arg  =>  $val")
    end
    #Running feature selection for mashup
    if parsed_args["command"] == "feature_selection"
        # parse arguments
        dir = parsed_args["net"]
        target_file = parsed_args["target"]
        querys = parsed_args["CV_query"]
        id = parsed_args["id"]
        smooth = parsed_args["smooth"]
        res_dir = parsed_args["res_dir"]

        # Construct the dabase, which contains the preliminary file.
        database = ModMashup.Database(dir, target_file, id, 
            querys, smooth = smooth)

        # Define the algorithm you want to use to integrate the networks
        model = ModMashup.MashupIntegration()

        # Running network integration
        ModMashup.network_integration!(model, database)

        # Start Processing the result
        result = model.net_weights
        result_tally = model.tally
        net_index = Dict()

        # Match each networks with its id
        for i = 1:length(database.string_nets)

            net_name = database.string_nets[i]
            net_true_name = split(net_name,".")[1]
            net_index[net_true_name] = i
        end

        # Sort the networks weights 
        result = sort(collect(result),by = x->x[2], rev=true)
        result_tally = sort(collect(result_tally),by = x->x[2], rev=true)

        # Print the result here
        println("============================Start printing result.........================")
        println("Top 100 networks weights from netdx-1800")
        test = print_pair(result)
        tmp = Vector()
        for i in 1:length(test)
            push!(tmp, test[i][2])
        end
        test_tally = print_pair(result_tally)
        test_net_index = print_dict(net_index)

        
        println("======================================End================================")
        # Save the result
        # Smooth or not?
        result_dir = smooth == 1 ? "$(res_dir)/smooth_result" : "$(res_dir)/no_smooth_result"
        if !isdir(result_dir)
            mkdir(result_dir)
        end
        println("Saving the result...Please wait")

        # Save the result and write them into text files
        writedlm("$(result_dir)/networks_weights_with_name.txt", test)
        writedlm("$(result_dir)/networks_weights.txt", tmp)
        writedlm("$(result_dir)/mashup_tally.txt", test_tally)
        writedlm("$(result_dir)/networks_index.txt", test_net_index)
        writedlm("$(result_dir)/cv_query.txt",model.cv_query)
        writedlm("$(result_dir)/beta.txt",model.β)
        writedlm("$(result_dir)/H.txt",model.H)
        writedlm("$(result_dir)/networks_weights_each_cv.txt",model.weights_mat)
        writedlm("$(result_dir)/singular_value_sqrt.txt",model.singular_value_sqrt)
        println("Saved...")

    # This part is left for patient ranling part of netdx.
    # Still unfinished. 
    elseif parsed_args["command"] == "query_runner"
        
        dir = parsed_args["net"]
        target_file = parsed_args["target"]
        querys = parsed_args["CV_query"]
        id = parsed_args["id"]
        smooth = parsed_args["smooth"]
        res_dir = parsed_args["res_dir"]

        # Construct the dabase, which contains the preliminary file.
        database = ModMashup.Database(dir, target_file, id, querys, smooth = smooth)

        # Define the algorithm you want to use to integrate the networks
        model = ModMashup.GeneMANIAIntegration()

        # Running network integration
        ModMashup.network_integration!(model, database)
    else
        error("Please provide correct command.")
    end
end

main()

