import GeneMANIA

reload("GeneMANIA")
dir = "KIRC/data/networks"
disease_file = "KIRC/data/annotations/disease.csv"
#index_file = "KIRC/disease_index.txt"
net_sel = ["age","grade","stage"]

#database = GeneMANIA.GMANIA(dir,disease_file,index_file = index_file,net_sel = copy(net_sel))
database = GeneMANIA.GMANIA(dir,disease_file)
model = GeneMANIA.MashupIntegration()
GeneMANIA.network_integration!(model, database)
result = Dict()
result_from_genemania = Dict("stage"=>43.98, "grade"=>37.63, "age"=>18.40)
for (ind, net_name) = enumerate(net_sel)
    result[net_name] = model.net_weights[ind]
end

function print_dict(dict_::Dict)
    tmp = Vector()
    for i in keys(dict_)
        net_string = split(i,"/")[end]
        println(net_string," => ", dict_[i], " %")
        push!(tmp, (net_string, dict_[i]))
    end
    return tmp
end
println("============================Start printing result.........================")
println("==========networks weights from mashup==========")
test = print_dict(result)
writedlm("result/ex1/networks_weights_with_name.txt", test)
println("==========networks weights from genemania==========")
print_dict(result_from_genemania)
println("======================================End================================")
println("Saving the result...Please wait")
#writedlm("result/ex1/cv_query.txt",model.cv_query)
#writedlm("result/ex1/beta.txt",model.β)
#writedlm("result/ex1/H.txt",model.H)
#writedlm("result/ex1/networks_weights.txt",model.net_weights)
#writedlm("result/ex1/networks_weights_each_cv.txt",model.weights_mat)
#writedlm("result/ex1/singular_value_squared.txt",model.singular_value_squared)

nothing

