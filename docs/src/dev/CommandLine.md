
## Mashup command tool

This project provide a `Command Line Tool` located in [mashup.jl](https://github.com/memoiry/ModMashup.jl/blob/master/tools/mashup.jl), which has two usage.

1. Modified Mashup feature selection.
2. Label propagation for patients ranking.

**Arguments**:

```julia
"command"
  help = "what function do you want to use? ie. selection, ranking"
  arg_type = String
  required = true
"--net"
  help = "Folder name where the similarity network is stored"
  arg_type = String
  required = true
"--id"
  help = "Patients name in the database"
  arg_type = String
  required = true
"--labels"
  help = "If for selection, it should be labels file name. If for ranking, it should be query file name and we use it to label patients."
  arg_type = String
  default = "nothing"
"--CV_query"
  help = "If for selection, folder name where Query files stored. If for ranking, single query file name for use to label patients"
  arg_type = String
"--top_net"
  help = "This keyword is used for ranking, it should be file containing selected networks name."
  arg_type = String
  default = "nothing"
"--smooth"
  help = "smooth the net or not"
  arg_type = Bool
  default = true
"--res_dir"
  help = "where to put the result"
  arg_type = String
"--cut_off"
  help = "cut_off to select top ranked network in network integration"
  arg_type = Int
  default = 9
```
   
**Outputs**:

For selection

1. `networks_weights_with_name.txt`: Txt file mapping networks name to its weights.
2. `mashup_tally.txt`: Txt file mapping networks name to its tally.
3. `top_networks.txt`: Txt file containing selected networks after cross validation.
4. `networks_index.txt`: Txt file mapping networks name to its internal id.
5. `cv_query.txt`: Txt file containing query internal id of each cross validation.
6. `beta.txt`: Txt file containing beta vector.
7. `networks_weights_each_cv.txt`: Txt file containing network weights of each cross validation.
8. `singular_value_sqrt.txt`: Txt file containing sqrt of singular value.

For ranking

1. `xxx_mashup_PRANK.txt`: Txt file mapping patients name to their weights.
2. `xxx_mashup_NRANK.txt`: Txt file mapping networks name to its weights.

         
### Example 
 
#### Usage 1: Mashup Feature Selection
 
First ensure that you have ModMashup.jl correctly installed in your computer.

```bash
$ var=$(julia -e "println(Pkg.dir())")
$ var="$var/ModMashup/test/data"
$ cd $var
$ mkdir temp_res
$ julia ../../tools/mashup.jl selection --net networks --id ids.txt --labels target.txt --CV_query . --smooth true --res_dir temp_res
```

The result will be saved at `temp_res` folder.

#### Usage 2: Mashup query runner for patients ranking using selected networks

After feature selection, you can run the command below to get patients ranking.

```bash
$ julia ../../tools/mashup.jl ranking --top_net temp_res/smooth_result/top_networks.txt --net networks --id ids.txt --CV_query CV_1.query --smooth true --res_dir temp_res
```

The result will be saved at `temp_res` folder.






