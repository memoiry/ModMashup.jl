abstract IgAbstractParams
#IgParams(args...;kwargs...) = NetworkIntegration(args...;kwargs...)

## SP: Separate each "piece" of this .jl file. Or better, put different things in different .jl files. This file has an object definition and a network_integration() function. Put them in two Julia files. 

export MashupIntegration,
    GeneMANIAIntegration
"""
    MashupIntegration(β, H, net_weights, weights_mat, cv_query, singular_value_squared, tally)

Modified Mashup algorithm for network integration.
Inside MashupIntegration model, it contains all the result after mashup integration.

* `β::Vector`: Beta vector as a result of linear regression.
* `H::Matrix`: Rows of H represent patients embendding in networks.
* `net_weights::Vector`: Normalized mean network weights 
* `weights_mat::Matrix`: Columns of weights_mat is computed network weights for each round of cross validation.
* `cv_query::Matrix`: Columns of cv_query is query id for each round of cross validation.
* `singular_value_squared::Vector`: singular value from mashup for dimensianal reduction.
* `tally::Vector{Int}`: Network tally result
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



"""
    GeneMANIAIntegration(net_weights, normalized, reg)

GeneMANIA lienar regression algorithm for network integration.

* `net_weights::Dict{String, Float64}`: A dictionalry map network name to its final network weights result, which is same with GeneMANIA.jar.
* `normalized::Bool`: Wether normlize the network weights
* `reg::Bool`: Wether add regularization term to 
"""
type GeneMANIAIntegration <: IgAbstractParams
    net_weights::Dict{String, Float64}
    normalized::Bool
    reg::Bool
end


MashupIntegration() = MashupIntegration(Vector(), Matrix(), Vector(), Matrix(), Matrix(), Vector(), Vector{Int}())
GeneMANIAIntegration() = GeneMANIAIntegration(Dict{String, Float64}(), true, true)


"""
    get_params(params::MashupIntegration)

Utils function to get resutl from mashup intermediate or final result

Input: Mashup result type.
Output: intermediate and final result.
"""
function get_params(params::MashupIntegration)
    
end
