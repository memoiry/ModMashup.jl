# GeneMANIA.jl

|Documentation|Build Status|
| :---: | :---: |
|[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://memoiry.github.io/GeneMANIA.jl)|[![Build Status](https://travis-ci.org/memoiry/GeneMANIA.jl.svg?branch=master)](https://travis-ci.org/memoiry/GeneMANIA.jl)|

GeneMANIA is a real-time multiple association network integration algorithm for predicting gene function.

## Usage

#### Installation

```julia
Pkg.add("https://github.com/memoiry/GeneMANIA.jl")
Pkg.test("GeneMANIA")
```

#### Simple example. 

Make sure KIRC dataset is in your current path.

```julia
using GeneMANIA

function test_mashup()
    dir = "KIRC/data/networks"
    disease_file = "KIRC/data/annotations/disease.csv"
    index_file = "KIRC/disease_index.txt"
    net_sel = ["age","grade","stage"]

    database = GMANIA(dir,disease_file,index_file = index_file,net_sel = net_sel)
    model = MashupIntegration()
    network_integration!(model, database)
    verbal ? (@printf "\nStatistics: ") : nothing
    return model
end

@time model = test_mashup();
```

The result is contained in model. you can access the β vector.

```julia
model.β
```

Accessing the eigenvalue (150-by-3 matrix).

```julia
model.eigenvalue_list
```

Make a benchmark for the mashup.

```julia
Pkg.add("BenchmarkTools")
using BenchmarkTools
@benchmark test_mashup(false)
```

## Background

Most successful computational approaches for protein function prediction integrate multiple genomics and proteomics data sources to make inferences about the function of unknown proteins. The most accurate of these algorithms have long running times, making them unsuitable for real-time protein function prediction in large genomes. As a result, the predictions of these algorithms are stored in static databases that can easily become outdated. Thus, GeneMANIA is proposed, that is as accurate as the leading methods, while capable of predicting protein function in real-time.
 
## Reference


[1] Pai et al. (2016). preprint http://biorxiv.org/content/early/2016/10/31/084418

[2] Mostafavi et al. (2010). Bioinformatics. 26:1759. https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2894508/

