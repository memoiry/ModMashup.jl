# ModMashup.jl

|Documentation|Build Status|
| :---: | :---: | 
|[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://memoiry.github.io/ModMashup.jl)|[![Build Status](https://travis-ci.org/memoiry/ModMashup.jl.svg?branch=master)](https://travis-ci.org/memoiry/ModMashup.jl)

This package provides real-time multiple association network integration algorithm for predicting gene function using both mashup and GeneMANIA.

We utilize Mashup algorithm to replace linear regression part of GeneMANIA, which is proved to be extremely computational efficient.

## Usage

#### Installation

```julia
Pkg.rm("ModMashup")
Pkg.clone("https://github.com/memoiry/ModMashup.jl")
```

#### Integrate with R `netDX` package

See [`Working with R`](http://memoiry.me/ModMashup.jl/dev/GSoC.html) for the information to update R `netDX` package with updated ModMashup.jl.

#### API

See [`Documentation`](https://memoiry.github.io/ModMashup.jl) for more information about API usage.

## Background

Most successful computational approaches for protein function prediction integrate multiple genomics and proteomics data sources to make inferences about the function of unknown proteins. The most accurate of these algorithms have long running times, making them unsuitable for real-time protein function prediction in large genomes. As a result, the predictions of these algorithms are stored in static databases that can easily become outdated. Thus, GeneMANIA is proposed, that is as accurate as the leading methods, while capable of predicting protein function in real-time.
 
## Reference


[1] Pai et al. (2016). preprint http://biorxiv.org/content/early/2016/10/31/084418

[2] Mostafavi et al. (2010). Bioinformatics. 26:1759. https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2894508/

[3] [Compact Integration of Multi-Network Topology for Functional Analysis of Genes](http://www.cell.com/cell-systems/fulltext/S2405-4712(16)30360-X?_returnURL=http%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS240547121630360X%3Fshowall%3Dtrue). Cho, Hyunghoon et al. Cell Systems , Volume 3 , Issue 6 , 540 - 548.e5 

