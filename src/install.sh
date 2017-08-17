#!/bin/bash
var=$(julia -e "println(Pkg.dir())")
rm -rf "$var/ProgressMeter"
rm -rf "$var/ArgParse"
rm -rf "$var/ModMashup"

\cp -rf ModMashup/third_party/ProgressMeter $var
\cp -rf ModMashup/third_party/ArgParse $var
\cp -rf ModMashup $var
rm pkg.txt
