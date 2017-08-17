##SP: is this file needed? Document/remove

# Use fit to pipeline the two algorithm in one function.
# Since label propagation is still under work
# the file is kept empty for further implementation.
export fit!


"""
    fit!(database::Database,
             it_model::MashupIntegration,
             lp_model::LabelPropagation)

Pipeline the mashup integration and label propagation in one function.


# Arguments

- `database::Database`: Database for computation
- `it_model::MashupIntegration`: GeneMANIAIntegration model contains result from integration
- `lp_model::LabelPropagation`: LabelPropagation model contains result from label propgation
"""
function fit!(database::Database,
             it_model::MashupIntegration,
             lp_model::LabelPropagation)



end




"""
    fit!(database::Database,
             it_model::GeneMANIAIntegration,
             lp_model::LabelPropagation)

Pipeline the genemania integration and label propagation in one function.

# Arguments

- `database::Database`: Database for computation
- `it_model::GeneMANIAIntegration`: GeneMANIAIntegration model contains result from integration
- `lp_model::LabelPropagation`: LabelPropagation model contains result from label propgation
"""
function fit!(database::Database,
             it_model::GeneMANIAIntegration,
             lp_model::LabelPropagation)



end