using GeneMANIA


function test()
    dir = "KIRC/data/networks"
    disease_file = "KIRC/data/annotations/disease.csv"
    index_file = "KIRC/disease_index.txt"
    net_sel = ["age","grade","stage"]

    database = GMANIA(dir,disease_file,index_file = index_file,net_sel = net_sel)
    model = MashupIntegration()
    network_integration!(model, database)
    true
end

test()