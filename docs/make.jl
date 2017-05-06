using Documenter, GeneMANIA


makedocs(clean = false,
        format = :html,
        sitename = "GeneMANIA.jl",
        pages = Any[
        "Home" => "index.md",
        "Quick Start" => "dev/get_start.md",
        "Algorithms" => Any[
        "Label Propagation" => "algo/label_propagation.md",
        "Network Integration" => "algo/network_integration.md"
        ]
    ]
)


deploydocs(
    repo = "github.com/memoiry/GeneMANIA.jl.git",
    julia = "0.5",
    target = "build",
    deps = nothing,
    make = nothing,
)
