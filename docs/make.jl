using Documenter, ModMashup


makedocs(clean = false,
        format = :html,
        sitename = "ModMashup.jl",
        pages = Any[
        "Home" => "index.md",
        "Quick Start" => "dev/get_start.md",
        "Command line tool" => "dev/CommandLine.md",
        "GSoC summary - End-to-end example" => "dev/GSoC.md",
        "Algorithms" => Any[
        "Database" => "algo/database.md",
        "Label Propagation" => "algo/label_propagation.md",
        "Network Integration" => "algo/network_integration.md",
        "Pipeline" => "algo/pipeline.md",
        "Common function" => "algo/common.md"],
        "Contribution" => "dev/contributions.md"
    ]
)

deploydocs(
    repo = "github.com/memoiry/ModMashup.jl.git",
    julia = "0.5",
    target = "build",
    deps = nothing,
    make = nothing,
)
