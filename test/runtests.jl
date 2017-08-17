using ModMashup
using Base.Test

# Run tests
 
@time @testset "Network Integration Algorithm" begin include("integration_alg_test.jl") end
@time @testset "Label Propagation Algorithm" begin include("label_propagation_alg_test.jl") end
