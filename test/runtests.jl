import ModMashup

using Base.Test

# Run tests

function separate_test(model::Symbol)
    #enter the path where the example data located 
    cd(joinpath(Pkg.dir("ModMashup"), "test/data"))

    #Set up database information
    dir = "networks"
    labels = "target.txt"
    querys = "."
    id = "ids.txt"
    smooth = true

    # Generate databse
    database = ModMashup.Database(dir, id, querys, smooth = smooth,
                                labels_file = labels, int_type = :selection)

    # Define the algorithm you want to use to integrate the networks
    int_model = is(model, :mashup) ? ModMashup.MashupIntegration(): ModMashup.GeneMANIAIntegration()   
    
    # Running network integration
    ModMashup.network_integration!(int_model, database)

    #linear regression finshed, extract the combined network and network
    # weigts from the model.
    combined_network = ModMashup.get_combined_network(int_model)
    net_weights::Dict{String, Float64} = ModMashup.get_weights(int_model)

    # Construct Label Propagation model
    lp_model = ModMashup.LabelPropagation(combined_network, 
                                      database.labels, verbose = true)

    # Running label propagation to get patient score
    ModMashup.label_propagation!(lp_model, database)

    # Get patient ranking score
    score = ModMashup.get_score(lp_model)
end

function pipeline_test(model::Symbol)
    #enter the path where the example data located 
    cd(joinpath(Pkg.dir("ModMashup"), "test/data"))

    #Set up database information
    dir = "networks"
    target_file = "target.txt"
    querys = "."
    id = "ids.txt"
    smooth = true

    # Generate databse
    database = ModMashup.Database(dir, id, querys, smooth = smooth,
                                labels_file = labels)
    # Define the algorithm you want to use to integrate the networks
    int_model = is(model, :mashup) ? ModMashup.MashupIntegration(): ModMashup.GeneMANIAIntegration()   
    lp_model = ModMashup.LabelPropagation(verbose = true)

    # Do both network integration and label propagation
    ModMashup.fit!(int_model, lp_model, database)

    # Pick up the result
    combined_network = ModMashup.get_combined_network(int_model)
    net_weights::Dict{String, Float64} = ModMashup.get_weights(int_model)
    score = ModMashup.get_score(lp_model)

end

function main_test(integration_model)
    #Test each method's separate method and pipeline.
    separate_test(integration_model)
    pipeline_test(integration_model)
    true
end

@time @testset "Mashup Integration and Label Propagation" begin main_test(:mashup) end

# GeneMANIA linear regression curretly not fully tested
#@time @testset "Label Propagation Algorithm" begin main_test(:genemania) end
