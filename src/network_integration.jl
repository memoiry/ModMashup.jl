

abstract IgAbstractParams

IgParams(args...;kwargs...) = NetworkIntegration(args...;kwargs...)

type NetworkIntegration <: IgAbstractParams
    max_iter::Int32
end

function NetworkIntegration()

end


function network_integration(model::NetworkIntegration, X::Matrix, y::Vector)


end


function get_params(params::NetworkIntegration)
    
end
