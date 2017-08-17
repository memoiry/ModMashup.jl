## Network integration

### Constructor 


The package provided two algorithm for network integration, one is `MashupIntegration` and another is `GeneMANIAIntegration`.

```@docs
MashupIntegration
```

```@docs
GeneMANIAIntegration
```

### Description

We have one generic function `network_integration!` to provide same interface for both mashup and genemania integration. 

The database contains the input. After the computation, the result will be saved on the model.

```@docs
network_integration!(model::MashupIntegration, database::Database)
```

```@docs
network_integration!(model::GeneMANIAIntegration, database::Database)
```

### Example

### References




