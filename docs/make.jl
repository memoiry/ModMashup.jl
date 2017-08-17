using Documenter, ModMashup


makedocs(clean = false,
        format = :html,
        sitename = "ModMashup.jl",
        pages = Any[
        "Home" => "index.md",
        "Quick Start" => "dev/get_start.md",
        "Working in R" => "dev/work_in_R.md",
        "Algorithms" => Any[
        "Database" => "algo/database.md",
        "Label Propagation" => "algo/label_propagation.md",
        "Network Integration" => "algo/network_integration.md",
        "Pipeline" => "algo/pipeline.md"
        ],
        "Util function" => "algo/util_function.md"
    ]
)


deploydocs(
    repo = "github.com/memoiry/GeneMANIA.jl.git",
    julia = "0.5",
    target = "build",
    deps = nothing,
    make = nothing,
)
