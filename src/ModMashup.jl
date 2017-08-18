__precompile__(true)
"""
Main module for `ModMashup.jl` -- a Julia package for network selection and 
patient prediction.
"""
module ModMashup


    using IterativeSolvers
    using ArgParse
    using ProgressMeter


    # Define basic data type
    include("model.jl")

    # Define algorithm type
    include("integration_types.jl")

    # Network integration solvers
    include("network_integration.jl")

    # Label propagation solvers
    include("label_propagation.jl")

    # Pipeline to combine integration and propagation
    include("fit.jl")

    # Utils function
    include("common.jl")

end