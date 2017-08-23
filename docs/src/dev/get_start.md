## ModMashup.jl


### Quick Start

#### Required Dependencies

- julia v0.5 +

You can download latest Julia from the [official website](https://julialang.org/downloads/). Version 0.5 or higher is highly recommended.

#### Installation

Enter Julia REPL.

```bash
$ julia
```

Then run the command below in Julia REPL.

```bash
Pkg.rm("ModMashup")
Pkg.clone("https://github.com/memoiry/ModMashup.jl")
```


#### Example usage in Julia


##### Usage 1: Mashup Feature Selection


```julia
import ModMashup
cd(joinpath(Pkg.dir("ModMashup"), "test/data"))

#Set up database information
dir = "networks"
labels = "target.txt"
querys = "."
id = "ids.txt"
smooth = true
top_net = "nothing"

# Construct the dabase, which contains the preliminary file.
database = ModMashup.Database(dir, id,
                           querys, labels_file = labels,
                           smooth = smooth,
                           int_type = :selection,
                           top_net = top_net)

# Define the algorithm you want to use to integrate the networks
model = ModMashup.MashupIntegration()

# Running network integration
ModMashup.network_integration!(model, database)

net_weights = ModMashup.get_weights(model)
tally = ModMashup.get_tally(model)
```

##### Usage 2: Mashup query runner for patients ranking using selected networks


```julia
import ModMashup
cd(joinpath(Pkg.dir("ModMashup"), "test/data"))

#Set up database information
dir = "networks"
querys = "CV_1.query"
id = "ids.txt"
smooth = true
# Top_networks contains selected top ranked networks.
top_net = "top_networks.txt"

# Construct the dabase, which contains the preliminary file.
database = ModMashup.Database(dir, id, 
   querys, smooth = smooth,
   int_type = :ranking,
   top_net = top_net)

# Define the algorithm you want to use to integrate the networks
int_model = ModMashup.MashupIntegration()
lp_model = ModMashup.LabelPropagation(verbose = true)

# Running network integration
ModMashup.fit!(int_model, lp_model, database)

# Pick up the result
#combined_network = ModMashup.get_combined_network(int_model)
net_weights = ModMashup.get_weights(int_model)
score = ModMashup.get_score(lp_model)
    
```

### Mashup command tool

This project provide a `Command Line Tool` located in [mashup.jl](https://github.com/memoiry/ModMashup.jl/blob/master/tools/mashup.jl), which has two usage.

1. Modified Mashup feature selection.
2. Label propagation for patients ranking.

#### Example 
 
##### Usage 1: Mashup Feature Selection
 
First ensure that you have ModMashup.jl correctly installed in your computer.

```bash
$ var=$(julia -e "println(Pkg.dir())")
$ var="$var/ModMashup/test/data"
$ cd $var
$ mkdir temp_res
$ julia ../../tools/mashup.jl selection --net networks --id ids.txt --labels target.txt --CV_query . --smooth true --res_dir temp_res
```

The result will be saved at `temp_res` folder.

##### Usage 2: Mashup query runner for patients ranking using selected networks

After feature selection, you can run the command below to get patients ranking.

```bash
$ julia ../../tools/mashup.jl ranking --top_net temp_res/smooth_result/top_networks.txt --net profiles --id ids.txt --CV_query CV_1.query --smooth true --res_dir temp_res
```

The result will be saved at `temp_res` folder.



