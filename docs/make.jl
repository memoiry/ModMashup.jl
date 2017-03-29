using Documenter, GeneMANIA


makedocs(
    format = :html,
    sitename = "GeneMANIA",
    pages = Any[
        "Home" => "index.md"
        ]

    )


deploydocs(
    repo = "github.com/memoiry/GeneMANIA.jl.git",
    target = "build",
    deps = nothing,
    deps = nothing,
)
