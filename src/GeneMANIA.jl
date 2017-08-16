__precompile__()
module GeneMANIA

    #export func


    #using Compat
    #using LowRankModels
    #using PyPlot
    #using NearestNeighbors
    #using Distributions
    #using Optim
    #using NMF
    #using Roots
    #using IterativeSolvers
    #using ParSpMatVec
    using ProgressMeter
    #using GLM
    #using DataFrames
    #import StatsBase: fit!, mode


    # define basic data type
    include("model.jl")

    # define algorithm type
    include("integration_types.jl")

    # define kernel function
    include("network_integration.jl")
    include("label_propagation.jl")

    # utils function
    include("fit.jl")
    include("utils.jl")

    function _mashup()


    end

    function _label_propagation()

    end

end