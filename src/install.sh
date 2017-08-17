mv ModMashup/src/pkg_info.jl .
julia pkg_info.jl pkg.txt
var = 'cat pkg.txt'
rm -rf "$var/ProgressMeter"
rm -rf "$var/ModMashup"
\cp -rf ModMashup/ProgressMeter ~/.julia/v0.5
