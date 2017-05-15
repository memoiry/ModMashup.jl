export fit,fit!, LbpParams, IgParams

abstract LbpAbstractParams
abstract IgAbstractParams

LbpParams(args...;kwargs...) = LabelPropagation(args...;kwargs...)
IgParams(args...;kwargs...) = NetworkIntegration(args...;kwargs...)


function fit!(genemania::AbstractGeneMANIA,
             int_params::NetworkIntegration,
             lb_params::LabelPropagation)
    

end



function fit(genemania::AbstractGeneMANIA,
             int_params::NetworkIntegration,
             lb_params::LabelPropagation)



end
