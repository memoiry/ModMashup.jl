module GeneMANIA

    #export func


    #using Compat
    #using LowRankModels
    using PyPlot
    using NearestNeighbors
    using Distributions
    using Optim
    using NMF
    using Roots
    using IterativeSolvers
    #import StatsBase: fit!, mode

    # define basic data type
    include("fit.jl")
    include("model.jl")

    # define kernel function
    include("network_integration.jl")
    include("label_propagation.jl")

    # utils function
    include("utils.jl")

end