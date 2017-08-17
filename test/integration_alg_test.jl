import ModMashup


#function test()
#    dir = "ex/KIRC/data/networks"
#    disease_file = "ex/KIRC/data/annotations/disease.csv"
#    database = GMANIA(dir,disease_file, query_attr = 1)
#    model = MashupIntegration()
#    network_integration!(model, database)
#    true
#end

function mashup_test()
    cd(joinpath(Pkg.dir("ModMashup"), "test/data"))
    dir = "networks"
    target_file = "target.txt"
    querys = "."
    id = "ids.txt"
    smooth = true

    # Construct the dabase, which contains the preliminary file.
    database = ModMashup.Database(dir, target_file, id, 
     querys, smooth = smooth)
        
    # Define the algorithm you want to use to integrate the networks
    model = ModMashup.MashupIntegration()
        
    # Running network integration
    ModMashup.network_integration!(model, database)

    # Acquire network weights dictionary
    net_weight_dict = ModMashup.get_weights(model)

    # Acquire Combined network
    combined_network = ModMashup.get_comined_network(model)

    # Acquire network tally
    tally = ModMashup.get_tally(model)
end

mashup_test()
true