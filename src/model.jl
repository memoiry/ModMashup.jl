
export AbstractGeneMANIA, GeneMANIA, SharedGeneMANIA, 

typealias SimilarityNetworks Union{Array{Float64,3},Vector{SparseMatrixCSC{Float64,Int64}}}
typealias SimilarityNetwork Union{Array{Float64,2},SparseMatrixCSC{Float64,Int64}}

abstract AbstractGeneMANIA

"""
    GeneMANIA

Serial genemania model
"""
type GeneMANIA <: AbstractGeneMANIA
    networks::SimilarityNetworks
    annotation::Matirx
    


end

function GeneMANIA()


end

"""
    SharedGeneMANIA

Shared genemania model for parallel computing
"""
type SharedGeneMANIA <: AbstractGeneMANIA


end


function SharedGeneMANIA()


end



"""
    share

Convert the normal model to shared model
"""
function share(genemania::GeneMANIA)



end



