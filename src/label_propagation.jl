
export LabelPropagation,
    label_propagation!,
    update_lp_model_info!,
    get_score

abstract LbpAbstractParams


LbpParams(args...;kwargs...) = LabelPropagation(args...;kwargs...)

"""
Collection of information on the label propagation model. 

# Fields

`combined_network::Matrix`: combined network after network integration.

`labels::Vector`: labels for all patients

`score_method::Symbol`: z-score or discriminant method to score the patients.

`maxiter::Integer`: maximum iterations taken by the method.

`tol::Real`: stopping tolerance.

`verbose::Bool`: print cg iteration information.

`plot::Bool`: plot the norm of the residual from label propagation‘s Conjugate Gradient optimization history.

`score::Vector`: Store patient score after label propagation.

# Constructor

    LabelPropagation()
    LabelPropagation(combined_network, labels)
"""
type LabelPropagation <: LbpAbstractParams
    combined_network::Matrix
    labels::Vector
    score_method::Symbol
    maxiter::Integer
    tol::Real
    verbose::Bool
    plot::Bool
    score::Dict{String, Float64}
end
function LabelPropagation(combined_network::Matrix,
                         labels::Vector; maxiter = nothing, tol = nothing,
                         verbose::Bool = false, plot::Bool = false,
                         score_method = :discriminant)
    if maxiter == nothing
        maxiter = size(combined_network, 2)
    end
    if tol == nothing
        tol = size(combined_network, 2) * eps()
    end
    score = Dict{String, Float64}()
    return LabelPropagation(combined_network, labels,
        score_method, maxiter, tol, 
        verbose, plot, score)
end


"""
    LabelPropagation(;kwargs...) = LabelPropagation(Matrix(), 
                Vector();kwargs...)

Empty label propagation model with some keywords.
"""
LabelPropagation(;kwargs...) = LabelPropagation(Matrix(), 
                Vector();kwargs...)


"""
    update_lp_model_info!(model::LabelPropagation,
                              combined_network::Matrix,
                              labels::Vector)

Update network and labels information in label proapgation model for 
pipeline usage.
"""
function update_lp_model_info!(model::LabelPropagation,
                              combined_network_::Matrix,
                              labels_::Vector)
    model.combined_network = combined_network_
    model.labels = labels_
    model.maxiter = size(combined_network_, 2)
    model.tol = size(combined_network_, 2) * eps()
end



####################################################
# Label Propagation Method Implementation #
####################################################
"""
    label_propagation!(model::LabelPropagation, database::Database)

Running label propagation for patient ranking.

# Arguments

`model::LabelPropagation`: Label Propagation model.

`database::Database`: store general information about the patients.

# Output

`model::LabelPropagation`: Result will be saved in the model fileds.

# Reference

Adapted from: [GeneMANIA source code](https://github.com/GeneMANIA/genemania/blob/develop/engine/src/main/java/org/genemania/engine/core/propagation/PropagateLabels.java)
"""
function label_propagation!(model::LabelPropagation, database::Database)
    # Initialization
    n_patients = database.n_patients
    score = zeros(n_patients)
    model.labels = set_label_bias(model.labels)

    # get laplacian matrix
    laplacian = model.combined_network
    for i = 1:n_patients
        laplacian[i,i] = sum(laplacian[i,:]) + 1
    end
    laplacian = -laplacian
    for i = 1:n_patients
        laplacian[i,i] = -laplacian[i,i]
    end

    # Check wehter want to plot the norm of residual in cg
    println("\nLabel propagation converge history")

    # Solve A*x=b with the conjugate gradients method.
    score, ch = cg(laplacian, model.labels, maxiter = model.maxiter,
    verbose = model.verbose, plot = model.plot, tol = model.tol, log = true)


    # Check if label propagation is converged
    if ch.isconverged
        println("Label propagation converged")
    else
        println("Label propagation not converged")
    end
    score = convert_score(score, model.score_method)
    #@show sort(score)

    # Store result in score, which maps patient name to its score.
    for i = 1:n_patients
        patient_name = database.inverse_index[i]
        model.score[patient_name] = score[i]
    end
    nothing
end

"""
    set_label_bias(score::Vector)
Returns a propagated vector. This uses average biasing for label biasing.
Any unknowns get (N+ - N-) / (N+ + N-) where N+ is the number of positives 
and N- is the number of negatives.
"""
function set_label_bias(score::Vector)
    n_pos = sum(find(score .== 1))
    n_neg = sum(find(score .== -1))

    bias = 1.0*(n_pos - n_neg) /(n_pos - n_neg)
    score[find(score .== -2)] = bias
    return score
end


"""
    convert_score(score::Vector, 
                      score_method::Symbol)
# Arguments

`score::Vector`: Score vector needed to be converted.
`score_method::Symbol`: Score convert method.

convert score from label progation to explanable patients score.
Currently only support :discriminant.
"""
function convert_score(score::Vector, 
                      score_method::Symbol)
    # convert score
    # if score method choosen is discriminant
    if score_method == :discriminant
        score = 0.5* (score + 1) * 100
    # if score method choosen is zsore
    elseif score_method == :zsore
    else
        error("Unexpected scoring method") 
    end
    return score
end

"""
    get_score(model::LabelPropagation)
# Arguments

`model::LabelPropagation`: Label propagation model.

# Outputs

`score::Dict{String, Float64}`: A dictionary maps patients' name to their score.

Pick up score from model after label propagation.
"""
function get_score(model::LabelPropagation)
    return model.score
end


