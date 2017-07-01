import GeneMANIA

reload("GeneMANIA")
dir = "mashup_data/networks/yeast"
disease_file = "mashup_data/annotations/disease.txt"

database = GeneMANIA.GMANIA(dir,disease_file, query_attr = 0)
model = GeneMANIA.MashupIntegration()
GeneMANIA.network_integration!(model, database)
result = Dict()

for (ind, net_name) = enumerate(database.string_nets)
    result[net_name] = model.net_weights[ind]
end
result = sort(collect(result),by = x->x[2], rev=true)
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
println("============================Start printing result.........================")
println("Top 100 networks weights from mashup")
test = print_pair(result)
tmp = Vector()
for i in 1:length(test)
    push!(tmp, test[i][2])
end
writedlm("result/ex2_0/networks_weights_with_name.txt", test)
println("======================================End================================")
println("Saving the result...Please wait")
writedlm("result/ex2_0/cv_query.txt",model.cv_query)
writedlm("result/ex2_0/beta.txt",model.β)
writedlm("result/ex2_0/H.txt",model.H)
writedlm("result/ex2_0/networks_weights.txt",tmp)
writedlm("result/ex2_0/networks_weights_each_cv.txt",model.weights_mat)
writedlm("result/ex2_0/singular_value_squared.txt",model.singular_value_squared)

nothing

