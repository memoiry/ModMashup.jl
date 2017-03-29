using Documenter, GeneMANIA


makedocs()


deploydocs(
    repo = "github.com/memoiry/GeneMANIA.jl.git",
    julia = "0.5",
    deps = nothing,
    deps = nothing,
)
