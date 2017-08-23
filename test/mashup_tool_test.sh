#!/usr/bin/bash
echo "====================================="
echo "Tesing network selection"
echo "====================================="
var=$(julia -e "println(Pkg.dir())")
var="$var/ModMashup/test/data"
cd $var
mkdir temp_res
julia ../../tools/mashup.jl selection --net networks --id ids.txt --labels target.txt --CV_query . --smooth true --res_dir temp_res
echo "====================================="
echo "Tesing network selection"
echo "====================================="
julia ../../tools/mashup.jl ranking --top_net temp_res/smooth_result/top_networks.txt --net profiles --id ids.txt --CV_query CV_1.query --smooth true --res_dir temp_res