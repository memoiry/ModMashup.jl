import ModMashup

function mashup_pipeline_test()
    # Generate databse
    database = ModMashup.Database(dir, target_file, id, querys, smooth = smooth)

    # Define the algorithm you want to use to integrate the networks
    int_model = ModMashup.MashupIntegration()    

    # Running network integration
    ModMashup.network_integration!(int_model, database)

    # Construct Label Propagation model
    lp_model = ModMashup.LabelPropagation(int_model.combined_network, 
                                      database.labels)

    # Running label propagation to get patient score
    ModMashup.label_propagation!(lp_model, database)

end

function genemania_pipeline_test()
    # Initialization
    cd(joinpath(Pkg.dir("ModMashup"), "test/data"))
    dir = "networks"
    target_file = "target.txt"
    querys = "."
    id = "ids.txt"
    smooth = true
    # Generate databse
    database = ModMashup.Database(dir, target_file, id, querys, smooth = smooth)
    # Define the algorithm you want to use to integrate the networks
    #model = ModMashup.MashupIntegration()
    int_model = ModMashup.GeneMANIAIntegration()    
    # Running network integration
    ModMashup.network_integration!(int_model, database)

    # Construct Label Propagation model
    lp_model = ModMashup.LabelPropagation(int_model.combined_network, 
                                      database.labels)

    # Running label propagation to get patient score
    ModMashup.label_propagation!(lp_model, database)

end

function fit_test()

    cd(joinpath(Pkg.dir("ModMashup"), "test/data"))
    dir = "networks"
    target_file = "target.txt"
    querys = "."
    id = "ids.txt"
    smooth = true
    # Generate databse
    database = ModMashup.Database(dir, target_file, id, querys, smooth = smooth)

    # Define the algorithm you want to use to integrate the networks
    int_model = ModMashup.MashupIntegration() 
    lp_model = ModMashup.LabelPropagation(plot = true)

    ModMashup.fit!(int_model, lp_model, database)
    #@show lp_model.score
end
fit_test()
mashup_test()
true