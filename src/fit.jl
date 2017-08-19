##SP: is this file needed? Document/remove

# Use fit to pipeline the two algorithm in one function.
# Since label propagation is still under work
# the file is kept empty for further implementation.
export fit!


"""
    fit!(int_model::MashupIntegration,
             lp_model::LabelPropagation,
             database::Database)

Pipeline the mashup integration and label propagation in one function.


# Arguments

- `database::Database`: Database for computation
- `it_model::MashupIntegration`: GeneMANIAIntegration model contains result from integration
- `lp_model::LabelPropagation`: LabelPropagation model contains result from label propgation

# Outputs

- `it_model::MashupIntegration`: outpus stored in model fileds.
- `lp_model::LabelPropagation`: outpus stored in model fileds.

"""
function fit!(int_model::MashupIntegration,
             lp_model::LabelPropagation,
             database::Database)
    # Running network integration
    network_integration!(int_model, database)

    # Construct Label Propagation model
    update_lp_model_info!(lp_model,
                         int_model.combined_network,
                         database.labels)

    # Running label propagation to get patient score
    label_propagation!(lp_model, database)

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