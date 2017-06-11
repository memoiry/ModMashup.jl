import GeneMania


function test()
    dir = "networks"
    disease_file = "annotations/disease.csv"
    index_file = "../disease_index.txt"
    net_sel = ["age","grade","stage"]

    database = GeneMANIA.GMANIA(dir,disease_file,index_file = index_file,net_sel = net_sel)
    model = GeneMANIA.MashupIntegration()
    GeneMANIA.network_integration!(model, database)
end




