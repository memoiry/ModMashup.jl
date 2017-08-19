## Working with R

For those who want to integrate this package into R `netDx` packages, just run the command steps below.

### Required Dependencies

- R
- julia 0.5 +

Make sure you have julia which is above the version 0.5+ and also R. You can download latest julia from the [official website](https://julialang.org/downloads/).

Enter where netDX latest packages located.

```bash
cd netDx/inst/bash
bash install.sh 
```

Download the ModMashup.jl from the github, and run the `intsall.sh` file to get the package working.

```bash
git clone --recursive https://github.com/memoiry/ModMashup.jl
mv ModMashup.jl ModMashup
```


### Experimental results

I have made two experiments to acquire network weight.

- correlation between H_cur and beta.
- dot product between H_cur and beta.

see [GSoC report](https://docs.google.com/document/d/1OOcEZSCVdYF9aZbSPtgS9CCERti0DXsUJuTi3JMKYpI/edit?usp=sharing) for more details about the experimental result.








