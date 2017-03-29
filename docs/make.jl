push!(LOAD_PATH, "../src")

using Documenter, GeneMANIA


makedocs()


deploydocs(
    deps   = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/memoiry/GeneMANIA.jl.git",
    julia  = "0.5",
    osname = "osx"
)
