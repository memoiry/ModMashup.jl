# ModMashup.jl

## Project Goal and Motivations

The aim of the project is to Reimplement GeneMANIA in Julia to optimize netDx for high-performance computing. 

## Why called ModMashup?

Because the implementation of GeneMANIA in this package is different. We get intuitive from [mashup](http://www.cell.com/cell-systems/fulltext/S2405-4712(16)30360-X?_returnURL=http%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS240547121630360X%3Fshowall%3Dtrue) to replace linear regression part of GeneMANIA for high-performance computing. In short, mashup learns patient embedding and we use this information to derivate network weights.

### [Index](@id main-index)

### Functions


```@index
Pages = ["algo/database.md", "algo/label_propagation.md", "algo/network_integration.md", "algo/pipeline.md", "algo/common.md"]
Order = [:function]
```

### Types

```@index
Pages = ["algo/database.md", "algo/label_propagation.md", "algo/network_integration.md", "algo/pipeline.md", "algo/common.md"]
Order = [:type]
```

