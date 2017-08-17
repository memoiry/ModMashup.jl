julia ModMashup/src/pkg_info.jl
var = 'cat pkg.txt'
rm -rf "$var/ProgressMeter"
rm -rf "$var/ModMashup"
\cp -rf ModMashup/ProgressMeter $var
\cp -rf ModMashup $var
