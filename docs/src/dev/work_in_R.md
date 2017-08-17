## Working with R

For those who want to integrate this package into R `netDx` packages, just run the command steps below.

### Required Dependencies

- R
- julia 0.5 +

Make sure you have R and julia installed in your computer, cd into where netDX latest packages located.

```bash
cd netDx/inst/julia
rm -rf ModMashup
```

Then just download the ModMashup.jl from the github

```bash
git clone --recursive https://github.com/memoiry/ModMashup.jl
mv ModMashup.jl ModMashup
cp ModMashup/src/install.sh .
bash install.sh
```








