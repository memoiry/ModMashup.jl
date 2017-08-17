abstract IgAbstractParams
#IgParams(args...;kwargs...) = NetworkIntegration(args...;kwargs...)

## SP: Separate each "piece" of this .jl file. Or better, put different things in different .jl files. This file has an object definition and a network_integration() function. Put them in two Julia files. 

export MashupIntegration,
    GeneMANIAIntegration
"""
    MashupIntegration(β, H, net_weights, weights_mat, cv_query, singular_value_sqrt, tally)

Modified Mashup algorithm for network integration.
Inside MashupIntegration model, it contains all the result after mashup integration.

# Arguments

* `β::Vector`: Beta vector as a result of linear regression.
* `H::Matrix`: Rows of H represent patients embendding in networks.
* `net_weights::Vector`: Normalized mean network weights 
* `weights_mat::Matrix`: Columns of weights_mat is computed network weights for each round of cross validation.
* `cv_query::Matrix`: Columns of cv_query is query id for each round of cross validation.
* `singular_value_sqrt::Vector`: singular value from mashup for dimensianal reduction.
* `tally::Vector{Int}`: Network tally result
"""
type MashupIntegration <: IgAbstractParams
    β::Vector 
    H::Matrix
    net_weights::Dict{String, Float64}
    weights_mat::Matrix
    cv_query::Matrix
    singular_value_sqrt::Vector
    tally::Vector{Int}
    combined_network::Matrix
end



"""
    GeneMANIAIntegration(net_weights, normalized, reg)

GeneMANIA lienar regression algorithm for network integration.

# Arguments

* `net_weights::Dict{String, Float64}`: A dictionalry map network name to its final network weights result, which is same with GeneMANIA.jar.
* `normalized::Bool`: Wether normlize the network weights
* `reg::Bool`: Wether add regularization term to 
"""
type GeneMANIAIntegration <: IgAbstractParams
    net_weights::Dict{String, Float64}
    combined_network::Matrix
    normalized::Bool
    reg::Bool
end


MashupIntegration() = MashupIntegration(Vector(), Matrix(), Dict{String, Float64}(), Matrix(), Matrix(), Vector(), Vector{Int}(), Matrix())
GeneMANIAIntegration() = GeneMANIAIntegration(Dict{String, Float64}(), Matrix(), true, true)


"""
    get_tally(model::MashupIntegration)

Get network tally from mashup model.

- `Input`: Mashup result type.
- `Output`: intermediate and final result.
"""
function get_tally(model::MashupIntegration)
    return model.tally
end

"""
    get_comined_network(model::IgAbstractParams)

Get combined network from network integration model.

- `Input`: Network integration model after perfrom [`network_integration!`](@ref).
- `Output`: Combined network.
"""
function get_comined_network(model::IgAbstractParams)
    return model.combined_network
end


"""
    get_weights(model::IgAbstractParams)

Get a dictionalry to map network name to its network weights from network integration model.

- `Input`: Network integration model after perfrom [`network_integration!`](@ref).
- `Output`: a dictionalry to map network name to its network weights.
"""
function get_weights(model::IgAbstractParams)
    return model.net_weights
end