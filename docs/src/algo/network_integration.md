## Network integration

### Integration model 


The package provided two algorithm for network integration, one is `MashupIntegration` and another is `GeneMANIAIntegration` (GeneMANIA's raw networks integration is not fully tested).

```@docs
MashupIntegration
```

```@docs
GeneMANIAIntegration
```

### Generic integration method

We have one generic function `network_integration!` to provide same interface for both mashup and genemania integration. 

The database contains the input. After the computation, the result will be saved on the model.

```@docs
network_integration!(model::MashupIntegration, database::Database)
```

```@docs
network_integration!(model::GeneMANIAIntegration, database::Database)
```




