abstract IgAbstractParams

#IgParams(args...;kwargs...) = NetworkIntegration(args...;kwargs...)

## SP: Separate each "piece" of this .jl file. Or better, put different things in different .jl files. This file has an object definition and a network_integration() function. Put them in two Julia files. 

"""
    MashupIntegration(β, H, net_weights, weights_mat, cv_query, singular_value_squared, tally)

Inside MashupIntegration model, it contains all the result after mashup integration.

* β::Vector: Beta vector as a result of linear regression.
* H::Matrix: rows of H represent patients embendding in networks.
* net_weights::Vector: 
* weights_mat::Matrix: 
* cv_query::Matrix: columns of cv_query is query id for each round of cross validation.
* singular_value_squared::Vector: 
* tally::Vector{Int}: Network tally result
"""
type MashupIntegration <: IgAbstractParams
    β::Vector 
    H::Matrix
    net_weights::Vector
    weights_mat::Matrix
    cv_query::Matrix
    singular_value_squared::Vector
    tally::Vector{Int}
end

type RawMashupIntegration <: IgAbstractParams
    net_weights::Dict{String, Float64}
    normalized::Bool
    reg::Bool
end

MashupIntegration() = MashupIntegration(Vector(), Matrix(), Vector(), Matrix(), Matrix(), Vector(), Vector{Int}())
RawMashupIntegration() = MashupIntegration(Dict{String, Float64}(), true, true)


"""
    get_params(params::MashupIntegration)

Utils function to get resutl from mashup intermediate or final result

Input: Mashup result type.
Output: intermediate and final result.
"""
function get_params(params::MashupIntegration)
    
end
