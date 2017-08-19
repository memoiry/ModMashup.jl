## Notes for contributing

Contributions are always welcome, as are feature requests and suggestions. Feel free to open issues and pull requests at any time. If you aren't familiar with git or Github please start now.

### Setting workspace up

Fork [ModMashup.jl](https://github.com/memoiry/ModMashup.jl) repository first.

Julia's internal package manager makes it easy to install and modify packages from Github. Any package hosted on Github can be installed via Pkg.clone by providing the repository's URL, so installing a fork on your system is a simple task.

**Remember to replace https://github.com/memoiry/ModMashup.jl with your fork of `ModMashup.jl`**

```bash
$ julia
Pkg.clone("https://github.com/memoiry/ModMashup.jl")
```

Make a test.

```bash
Pkg.test("ModMashup")
```

Everything should be working now, you can find package location in your computer by.

```bash
$ julia -e "println(Pkg.dir("ModMashup"))"
```

Simply make a change in that folder.

### Network integration

For those who want to continue develop mashup network integration algorithm, the only function you need to modify is [network_integration!](https://github.com/memoiry/ModMashup.jl/blob/9275b443bf67608b67f791bcb7b546b6669ab705/src/network_integration.jl#L30).  

#### Modified mashup algorithm for network integration

The implementation of modified mashup algorithm for network integration is still under developing and is not fully verified its effectiveness. 

The current mashup integration algorithm works as below.

1. Random walk with restarts: For each similarity network Ai, we run random walk to obtain Qi.
2. Smoothing: For each Qi, we select smooth or not to smooth. Smooth means Ri = log(abs(Q) + 1/n_patients).
3. Concat each Qi (not smooth) or Ri (smooth) along row axis to get a big matrix N.
4. Run SVD. U,S,V = svd(N) to get U, S, V 
5. Let H = U * S^(1/2).
6. V = S^(1/2) * V. 
7. Linear regression to get Beta = V’ \ annotation ( left divide, annotation is a binary vector, 1 indicates query type, -1 indicates not-query type).
8. Getting network weights through cross-validation

```
For each class cl in classes
   Net_weights = matrix[N networks, 10 CV]
   For k in 1:10 # 10-fold CV
             Qry_k = 90% training samples of class cl 
		  For network j
			# indices corresponding to network j and 
			# within that, samples in Qry_k
             	H_cur = H[(j,Qry_k),] 
              All_weights = corr(H_cur,beta)
        # Or we can get network weight by dot product 
        #     All_weights = H_cur * beta
              Net_weights[j,k] = mean(All_weights)
		  End 
  End
End
```

`Reference:`

 [Compact Integration of Multi-Network Topology for Functional Analysis of Genes](http://www.cell.com/cell-systems/pdf/S2405-4712(16)30360-X.pdf), pages 13.

### Label propagation


For those who want to continue develop label propagation algorithm, the only function you need to modify is [label_propagation!](https://github.com/memoiry/ModMashup.jl/blob/9275b443bf67608b67f791bcb7b546b6669ab705/src/label_propagation.jl#L112)






