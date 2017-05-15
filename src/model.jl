
export AbstractGMANIA, GeneMANIA, SharedGMANIA

typealias SimilarityNetworks Union{Array{Float64,3},Vector{SparseMatrixCSC{Float64,Int64}}}
typealias SimilarityNetwork Union{Array{Float64,2},SparseMatrixCSC{Float64,Int64}}
typealias OneHotAnnotation Union{Array{Float64, 2}, SparseMatrixCSC{Int64,Int64}}
abstract AbstractGMANIA

"""
    GeneMANIA

Serial genemania model
"""
type GMANIA <: AbstractGMANIA
    networks::SimilarityNetworks
    annotation::OneHotAnnotation
    


end

function GMANIA()


end

"""
    SharedGeneMANIA

Shared genemania model for parallel computing
"""
type SharedGMANIA <: AbstractGMANIA
    networks::SimilarityNetworks
    annotation::OneHotAnnotation

end


function SharedGMANIA()


end



"""
    share

Convert the normal model to shared model
"""
function share(genemania::GMANIA)



end



