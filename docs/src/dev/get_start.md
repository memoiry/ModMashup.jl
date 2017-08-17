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

Then run the command below in REPL.
```bash
Pkg.rm("ModMashup")
Pkg.clone("https://github.com/memoiry/ModMashup.jl")
```


#### Example usage in Julia

```julia
import ModMashup
cd(joinpath(Pkg.dir("ModMashup"), "test/data"))
dir = "networks"
target_file = "target.txt"
querys = "."
id = "ids.txt"
smooth = true

# Construct the dabase, which contains the preliminary file.
database = ModMashup.Database(dir, target_file, id, 
 querys, smooth = smooth)
    
# Define the algorithm you want to use to integrate the networks
model = ModMashup.MashupIntegration()
    
# Running network integration
ModMashup.network_integration!(model, database)

# Acquire network weights dictionary
net_weight_dict = ModMashup.get_weights(model)

# Acquire Combined network
combined_network = ModMashup.get_comined_network(model)

# Acquire network tally
tally = ModMashup.get_tally(model)

```

### Mashup command tool

This project provide a `Command Line Tool` located in [mashup.jl](https://github.com/memoiry/ModMashup.jl/blob/master/tools/mashup.jl), which has two usage.

1. Modified Mashup feature selection.
2. GeneMANIA query runner same with [GeneMANIA.jar](http://apps.cytoscape.org/apps/genemania).

#### Example 
 
##### Usage 1: Mashup Feature Selection
 
First ensure that you have ModMashup.jl correctly installed in your computer.

```bash
$ var=$(julia -e "println(Pkg.dir())")
$ var="$var/ModMashup/test/data"
$ cd $var
$ mkdir temp_res
$ julia ../../tools/mashup.jl feature_selection --net networks --id ids.txt --target target.txt --CV_query . --smooth true --res_dir temp_res
```

The result will be saved at `temp_res` folder.

##### Usage 2: GeneMANIA query runner

```bash
$ julia ../../tools/mashup.jl query_runner --net networks --id ids.txt --target target.txt --CV_query . --smooth true --res_dir temp_res
```




