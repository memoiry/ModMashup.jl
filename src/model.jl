
export 
        GMANIA, 
        SharedGMANIA

#typealias SimilarityNetworks Union{Array{Float64,3},Vector{SparseMatrixCSC{Float64,Int64}}}
#typealias SimilarityNetwork Union{Array{Float64,2},SparseMatrixCSC{Float64,Int64}}
typealias OneHotAnnotation Union{Vector{Int},Array{Int, 2}, SparseMatrixCSC{Int64,Int64}}
abstract AbstractGMANIA

"""
    GeneMANIA

Serial genemania model
"""

immutable GMANIA <: AbstractGMANIA
    string_nets::Vector{String}
    disease::OneHotAnnotation
    n_patients::Int
    patients_index::Dict{String,Int}
    inverse_index::Dict{Int,String}
    use_index::Bool
end


function GMANIA(dir::String,
                disease_file::String;
                index_file = nothing,
                net_sel = nothing)
    patients_index::Dict{String, Int} = Dict{String, Int}()
    inverse_index::Dict{Int, String} = Dict{Int, String}()
    string_nets = Vector{String}() 
    if net_sel != nothing
        @assert isa(net_sel,Vector{String})
        n_net = length(net_sel)
        for i = 1:n_net
            net_sel[i] = @sprintf "%s/%s.txt" dir net_sel[i]
        end
        string_nets = net_sel
    else
        string_nets = searchdir(dir, "txt")
        map!(x -> joinpath(dir, x), string_nets)
    end
    disease = contains(disease_file, "txt") ? readdlm(disease_file) : readcsv(disease_file)
    disease = Int.(disease[:,2])
    n_patients = size(disease,1)
    use_index = false
    if index_file != nothing
        @assert isa(index_file, String)
        use_index = true
        patients_index, inverse_index = build_index(index_file)
    end
    return GMANIA(string_nets, disease, n_patients,
                  patients_index, inverse_index, use_index)
end


"""
    SharedGeneMANIA

Shared genemania model for parallel computing
"""
type SharedGMANIA <: AbstractGMANIA
    string_nets::Vector{String}
    disease::OneHotAnnotation
    n_patients::Int64
    patients_index::Dict{String,Int64}
    use_index::Bool
end


function SharedGMANIA()


end



"""
    share

Convert the normal model to shared model
"""
function share(genemania::GMANIA)



end



