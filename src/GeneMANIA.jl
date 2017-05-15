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

    # define kernel function
    include("network_integration.jl")
    include("label_propagation.jl")

    # define basic data type
    include("model.jl")
    include("fit.jl")

    # utils function
    include("utils.jl")

end