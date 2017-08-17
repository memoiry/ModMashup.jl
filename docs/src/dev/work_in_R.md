## Working with R

For those who want to integrate this package into R `netDx` packages, just run the command steps below.

### Required Dependencies

- R
- julia 0.5 +

Make sure you have julia which is above the version 0.5+ and also R. You can download latest julia from the [official website](https://julialang.org/downloads/).

Cd into where netDX latest packages located.

```bash
cd netDx/inst/julia
rm -rf ModMashup
```

Download the ModMashup.jl from the github, and run the `intsall.sh` file to get the package working.

```bash
git clone --recursive https://github.com/memoiry/ModMashup.jl
mv ModMashup.jl ModMashup
bash ModMashup/src/install.sh 
```







