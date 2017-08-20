## Common function


```@docs
rwr(A::Matrix, restart_prob = 0.5)
```

```@docs
pca(A::Matrix, num::Int64=size(A,2))
```


```@docs
build_index(index_file::String)
```

```@docs
parse_target(target::Matrix, patients_index::Dict{String, Int})
```

```@docs
parse_query(query_file::String, patients_index::Dict{String, Int})
```

```@docs
load_net(filename::String,
                  database::Database)
```

```@docs
searchdir(path::String,key::String)
```

```@docs
get_combined_network
```


```@docs
get_weights
```


```@docs
get_score
```


