import ModMashup

using Base.Test

# Run tests

function selection_test()
    #enter the path where the example data located 
    cd(joinpath(Pkg.dir("ModMashup"), "test/data"))

    #Set up database information
    dir = "networks"
    labels = "target.txt"
    querys = "."
    id = "ids.txt"
    smooth = true
    top_net = "nothing"

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
end

function pipeline_test()
    #enter the path where the example data located 
    cd(joinpath(Pkg.dir("ModMashup"), "test/data"))

    #Set up database information
    dir = "networks"
    querys = "CV_1.query"
    id = "ids.txt"
    smooth = true
    top_net = "top_networks.txt"

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

end
 
function main_test()
    #Test each method's separate method and pipeline.
    println(" ")
    println("========================================")
    println("Start testing feature selection")
    println("========================================")
    println(" ")
    selection_test()
    println(" ")
    println("========================================")
    println("Start testing label propagation")
    println("========================================")
    println(" ")
    pipeline_test()
    println(" ")
    println("========================================")
    println("Start testing mashup command line tool")
    println("========================================")
    println(" ")
    cd(joinpath(Pkg.dir("ModMashup"), "test"))
    run(`bash mashup_tool_test.sh`)
    true
end

@time @testset "Mashup Integration and Label Propagation" begin main_test() end

# GeneMANIA linear regression curretly not fully tested
#@time @testset "Label Propagation Algorithm" begin main_test(:genemania) end
