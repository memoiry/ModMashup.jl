using Documenter, GeneMANIA


makedocs(modules=[GeneMANIA],
        doctest=true)


deploydocs(
    repo = "github.com/memoiry/GeneMANIA.jl.git",
    julia = "0.5",
)
