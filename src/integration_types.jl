abstract IgAbstractParams

#IgParams(args...;kwargs...) = NetworkIntegration(args...;kwargs...)

## SP: Separate each "piece" of this .jl file. Or better, put different things in different .jl files. This file has an object definition and a network_integration() function. Put them in two Julia files. 
type MashupIntegration <: IgAbstractParams
    β::Vector ## SP:document
    H::Matrix
    net_weights::Vector
    weights_mat::Matrix
    cv_query::Matrix
    singular_value_squared::Vector
end

type RawMashupIntegration <: IgAbstractParams
    β::Vector
    H::Matrix
    net_weights::Vector
    weights_mat::Matrix
    cv_query::Matrix
    singular_value_squared::Vector
end

MashupIntegration() = MashupIntegration(Vector(), Matrix(), Vector(), Matrix(), Matrix(), Vector())
RawMashupIntegration() = MashupIntegration(Vector(), Matrix(), Vector(), Matrix(), Matrix(), Vector())


"""
    get_params(params::MashupIntegration)

Utils function to get resutl from mashup intermediate or final result

Input: Mashup result type.
Output: intermediate and final result.
"""
function get_params(params::MashupIntegration)
    
end
