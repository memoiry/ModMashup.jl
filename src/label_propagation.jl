abstract LbpAbstractParams

LbpParams(args...;kwargs...) = LabelPropagation(args...;kwargs...)


type LabelPropagation <: LbpAbstractParams
    max_iter::Int32
end

function LabelPropagation()

end


function label_propagation(model::LabelPropagation, X::Matrix, y::Vector)


end


function get_params(params::LabelPropagation)
end
