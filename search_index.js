var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#ModMashup.jl-1",
    "page": "Home",
    "title": "ModMashup.jl",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#Project-Goal-and-Motivations-1",
    "page": "Home",
    "title": "Project Goal and Motivations",
    "category": "section",
    "text": "The aim of the project is to Reimplement GeneMANIA in Julia to optimize netDx for high-performance computing. "
},

{
    "location": "index.html#Why-called-ModMashup?-1",
    "page": "Home",
    "title": "Why called ModMashup?",
    "category": "section",
    "text": "Because the implementation of GeneMANIA in this package is different. We get intuitive from mashup to replace linear regression part of GeneMANIA for high-performance computing. In short, mashup learns patient embedding and we use this information to derivate network weights."
},

{
    "location": "index.html#ModMashup-API-1",
    "page": "Home",
    "title": "ModMashup API",
    "category": "section",
    "text": ""
},

{
    "location": "dev/get_start.html#",
    "page": "Quick Start",
    "title": "Quick Start",
    "category": "page",
    "text": ""
},

{
    "location": "dev/get_start.html#ModMashup.jl-1",
    "page": "Quick Start",
    "title": "ModMashup.jl",
    "category": "section",
    "text": ""
},

{
    "location": "dev/get_start.html#Quick-Start-1",
    "page": "Quick Start",
    "title": "Quick Start",
    "category": "section",
    "text": ""
},

{
    "location": "dev/get_start.html#Required-Dependencies-1",
    "page": "Quick Start",
    "title": "Required Dependencies",
    "category": "section",
    "text": "julia v0.5 +You can download latest Julia from the official website. Version 0.5 or higher is highly recommended."
},

{
    "location": "dev/get_start.html#Installation-1",
    "page": "Quick Start",
    "title": "Installation",
    "category": "section",
    "text": "Enter Julia REPL.$ juliaThen run the command below in REPL.Pkg.rm(\"ModMashup\")\nPkg.clone(\"https://github.com/memoiry/ModMashup.jl\")"
},

{
    "location": "dev/get_start.html#Example-usage-in-Julia-1",
    "page": "Quick Start",
    "title": "Example usage in Julia",
    "category": "section",
    "text": "import ModMashup\ncd(joinpath(Pkg.dir(\"ModMashup\"), \"test/data\"))\ndir = \"networks\"\ntarget_file = \"target.txt\"\nquerys = \".\"\nid = \"ids.txt\"\nsmooth = true\n\n# Construct the dabase, which contains the preliminary file.\ndatabase = ModMashup.Database(dir, target_file, id, \n querys, smooth = smooth)\n    \n# Define the algorithm you want to use to integrate the networks\nmodel = ModMashup.MashupIntegration()\n    \n# Running network integration\nModMashup.network_integration!(model, database)\n\n# Acquire network weights dictionary\nnet_weight_dict = ModMashup.get_weights(model)\n\n# Acquire Combined network\ncombined_network = ModMashup.get_comined_network(model)\n\n# Acquire network tally\ntally = ModMashup.get_tally(model)\n"
},

{
    "location": "dev/get_start.html#Mashup-command-tool-1",
    "page": "Quick Start",
    "title": "Mashup command tool",
    "category": "section",
    "text": "This project provide a Command Line Tool located in mashup.jl, which has two usage.Modified Mashup feature selection.\nGeneMANIA query runner same with GeneMANIA.jar."
},

{
    "location": "dev/get_start.html#Example-1",
    "page": "Quick Start",
    "title": "Example",
    "category": "section",
    "text": ""
},

{
    "location": "dev/get_start.html#Usage-1:-Mashup-Feature-Selection-1",
    "page": "Quick Start",
    "title": "Usage 1: Mashup Feature Selection",
    "category": "section",
    "text": "First ensure that you have ModMashup.jl correctly installed in your computer.$ var=$(julia -e \"println(Pkg.dir())\")\n$ var=\"$var/ModMashup/test/data\"\n$ cd $var\n$ mkdir temp_res\n$ julia ../../tools/mashup.jl feature_selection --net networks --id ids.txt --target target.txt --CV_query . --smooth true --res_dir temp_resThe result will be saved at temp_res folder."
},

{
    "location": "dev/get_start.html#Usage-2:-GeneMANIA-query-runner-1",
    "page": "Quick Start",
    "title": "Usage 2: GeneMANIA query runner",
    "category": "section",
    "text": "$ julia ../../tools/mashup.jl query_runner --net networks --id ids.txt --target target.txt --CV_query . --smooth true --res_dir temp_res"
},

{
    "location": "dev/work_in_R.html#",
    "page": "Working in R",
    "title": "Working in R",
    "category": "page",
    "text": ""
},

{
    "location": "dev/work_in_R.html#Working-with-R-1",
    "page": "Working in R",
    "title": "Working with R",
    "category": "section",
    "text": "For those who want to integrate this package into R netDx packages, just run the command steps below."
},

{
    "location": "dev/work_in_R.html#Required-Dependencies-1",
    "page": "Working in R",
    "title": "Required Dependencies",
    "category": "section",
    "text": "R\njulia 0.5 +Make sure you have julia which is above the version 0.5+ and also R. You can download latest julia from the official website.Cd into where netDX latest packages located.cd netDx/inst/julia\nrm -rf ModMashupDownload the ModMashup.jl from the github, and run the intsall.sh file to get the package working.git clone --recursive https://github.com/memoiry/ModMashup.jl\nmv ModMashup.jl ModMashup\nbash ModMashup/src/install.sh "
},

{
    "location": "algo/database.html#",
    "page": "Database",
    "title": "Database",
    "category": "page",
    "text": ""
},

{
    "location": "algo/database.html#ModMashup.Database",
    "page": "Database",
    "title": "ModMashup.Database",
    "category": "Type",
    "text": "Database\n\nDatabase contains needed information for network integration and label propagation.\n\nArguments\n\nstring_nets::Vector{String}: Similarity networks name.\ndisease::OneHotAnnotation: Disease annotation for patients.\nn_patients::Int: The number of patients in the databse.\npatients_index::Dict{String,Int}: Map patient name to their id.\ninverse_index::Dict{Int,String}: Map patient id to their name.\nnum_cv::Int: The number of cross validation round. Default is 10.\nquery_attr::Int: Set the annotaion for query . Default is 1.\nstring_querys::Vector{String}: A list of query filename.\nsmooth::Int: Perform smooth in the simialarty or not. Default is true.\nthread::Int: Number of thread for parallel computing. Default it 1.\n\nExample\n\n# get example data directory\nexample_data_dir = joinpath(Pkg.dir(\"ModMashup\"), \"test/data\")\n\n# dir should be a directory containing similairty networks flat file.\nnetwork_dir = joinpaht(example_data_dir,\"networks\")\n\n# target_file should be a flat file contains disaese for patient\ntarget_file = joinpaht(example_data_dir,\"target.txt\")\n\n# Directory where a list of query flat files are located using the \n# same format and naming manner with genemania query.\nquery_dir = example_data_dir\n\n# Id file contains all the name of patients.\nid = joinpaht(example_data_dir,\"ids.txt\")\n\n# Other setting\n## Do smooth in the network or not for mashup integration.\nsmooth = true\n## The number of thread choosen to perform computation.\nthread = 2\n\n# We are ready now, then just construct the database\ndatabase = ModMashup.Database(network_dir, target_file, \n                id, query_dir, smooth = smooth, \n                thread = thread)\n\n\n\n"
},

{
    "location": "algo/database.html#ModMashup.SharedDatabase",
    "page": "Database",
    "title": "ModMashup.SharedDatabase",
    "category": "Type",
    "text": "SharedGeneMANIA\n\nShared genemania model for shared memory parallel computing (Still unfinished, left to do..)\n\n\n\n"
},

{
    "location": "algo/database.html#DataBase-1",
    "page": "Database",
    "title": "DataBase",
    "category": "section",
    "text": "DatabaseSharedDatabase"
},

{
    "location": "algo/label_propagation.html#",
    "page": "Label Propagation",
    "title": "Label Propagation",
    "category": "page",
    "text": ""
},

{
    "location": "algo/label_propagation.html#Label-Propagation-1",
    "page": "Label Propagation",
    "title": "Label Propagation",
    "category": "section",
    "text": ""
},

{
    "location": "algo/label_propagation.html#Label-propagation-model-1",
    "page": "Label Propagation",
    "title": "Label propagation model",
    "category": "section",
    "text": ""
},

{
    "location": "algo/label_propagation.html#Generic-propagation-method-1",
    "page": "Label Propagation",
    "title": "Generic propagation method",
    "category": "section",
    "text": ""
},

{
    "location": "algo/label_propagation.html#References-1",
    "page": "Label Propagation",
    "title": "References",
    "category": "section",
    "text": ""
},

{
    "location": "algo/network_integration.html#",
    "page": "Network Integration",
    "title": "Network Integration",
    "category": "page",
    "text": ""
},

{
    "location": "algo/network_integration.html#Network-integration-1",
    "page": "Network Integration",
    "title": "Network integration",
    "category": "section",
    "text": ""
},

{
    "location": "algo/network_integration.html#ModMashup.MashupIntegration",
    "page": "Network Integration",
    "title": "ModMashup.MashupIntegration",
    "category": "Type",
    "text": "MashupIntegration(β, H, net_weights, weights_mat, cv_query, singular_value_sqrt, tally)\n\nModified Mashup algorithm for network integration. Inside MashupIntegration model, it contains all the result after mashup integration.\n\nArguments\n\nβ::Vector: Beta vector as a result of linear regression.\nH::Matrix: Rows of H represent patients embendding in networks.\nnet_weights::Vector: Normalized mean network weights \nweights_mat::Matrix: Columns of weights_mat is computed network weights for each round of cross validation.\ncv_query::Matrix: Columns of cv_query is query id for each round of cross validation.\nsingular_value_sqrt::Vector: singular value from mashup for dimensianal reduction.\ntally::Vector{Int}: Network tally result\n\n\n\n"
},

{
    "location": "algo/network_integration.html#ModMashup.GeneMANIAIntegration",
    "page": "Network Integration",
    "title": "ModMashup.GeneMANIAIntegration",
    "category": "Type",
    "text": "GeneMANIAIntegration(net_weights, normalized, reg)\n\nGeneMANIA lienar regression algorithm for network integration.\n\nArguments\n\nnet_weights::Dict{String, Float64}: A dictionalry map network name to its final network weights result, which is same with GeneMANIA.jar.\nnormalized::Bool: Wether normlize the network weights\nreg::Bool: Wether add regularization term to \n\n\n\n"
},

{
    "location": "algo/network_integration.html#Integration-model-1",
    "page": "Network Integration",
    "title": "Integration model",
    "category": "section",
    "text": "The package provided two algorithm for network integration, one is MashupIntegration and another is GeneMANIAIntegration.MashupIntegrationGeneMANIAIntegration"
},

{
    "location": "algo/network_integration.html#ModMashup.network_integration!-Tuple{ModMashup.MashupIntegration,ModMashup.Database}",
    "page": "Network Integration",
    "title": "ModMashup.network_integration!",
    "category": "Method",
    "text": "network_integration!(model::MashupIntegration, database::GMANIA)\n\nImplement modified mashup network integration. Result will be save in the model. See MashupIntegration for more information about the result.\n\n\n\n"
},

{
    "location": "algo/network_integration.html#ModMashup.network_integration!-Tuple{ModMashup.GeneMANIAIntegration,ModMashup.Database}",
    "page": "Network Integration",
    "title": "ModMashup.network_integration!",
    "category": "Method",
    "text": "network_integration!(model::GeneMANIAIntegration, database::GMANIA)\n\nImplement Raw mashup network integration. Result will be saved in the model. See GeneMANIAIntegration for more information about the result.\n\n\n\n"
},

{
    "location": "algo/network_integration.html#Generic-integration-method-1",
    "page": "Network Integration",
    "title": "Generic integration method",
    "category": "section",
    "text": "We have one generic function network_integration! to provide same interface for both mashup and genemania integration. The database contains the input. After the computation, the result will be saved on the model.network_integration!(model::MashupIntegration, database::Database)network_integration!(model::GeneMANIAIntegration, database::Database)"
},

{
    "location": "algo/pipeline.html#",
    "page": "Pipeline",
    "title": "Pipeline",
    "category": "page",
    "text": ""
},

{
    "location": "algo/pipeline.html#ModMashup.fit!-Tuple{ModMashup.Database,ModMashup.MashupIntegration,ModMashup.LabelPropagation}",
    "page": "Pipeline",
    "title": "ModMashup.fit!",
    "category": "Method",
    "text": "fit!(database::Database,\n         it_model::MashupIntegration,\n         lp_model::LabelPropagation)\n\nPipeline the mashup integration and label propagation in one function.\n\nArguments\n\ndatabase::Database: Database for computation\nit_model::MashupIntegration: GeneMANIAIntegration model contains result from integration\nlp_model::LabelPropagation: LabelPropagation model contains result from label propgation\n\n\n\n"
},

{
    "location": "algo/pipeline.html#ModMashup.fit!-Tuple{ModMashup.Database,ModMashup.GeneMANIAIntegration,ModMashup.LabelPropagation}",
    "page": "Pipeline",
    "title": "ModMashup.fit!",
    "category": "Method",
    "text": "fit!(database::Database,\n         it_model::GeneMANIAIntegration,\n         lp_model::LabelPropagation)\n\nPipeline the genemania integration and label propagation in one function.\n\nArguments\n\ndatabase::Database: Database for computation\nit_model::GeneMANIAIntegration: GeneMANIAIntegration model contains result from integration\nlp_model::LabelPropagation: LabelPropagation model contains result from label propgation\n\n\n\n"
},

{
    "location": "algo/pipeline.html#PipeLine-1",
    "page": "Pipeline",
    "title": "PipeLine",
    "category": "section",
    "text": "fit!(database::Database,\n             it_model::MashupIntegration,\n             lp_model::LabelPropagation)fit!(database::Database,\n             it_model::GeneMANIAIntegration,\n             lp_model::LabelPropagation)"
},

{
    "location": "algo/util_function.html#",
    "page": "Util function",
    "title": "Util function",
    "category": "page",
    "text": ""
},

{
    "location": "algo/util_function.html#ModMashup.rwr",
    "page": "Util function",
    "title": "ModMashup.rwr",
    "category": "Function",
    "text": "rwr(A::Matrix, restart_prob = 0.5)\n\nRandom walk with restart.\n\nArguments\n\nA::Matrix: Initial matrix for random walk.\nrestart_prob: Restart probability. Default 0.5.\n\n\n\n"
},

{
    "location": "algo/util_function.html#ModMashup.pca",
    "page": "Util function",
    "title": "ModMashup.pca",
    "category": "Function",
    "text": "pca(A::Matrix, num::Int64=size(A,2))\n\nPerform PCA for a matrix.\n\nInput: a matrix and needed \nOutput: pca vector and pca value\n\nExample\n\njulia> a = rand(5,5)\n5×5 Array{Float64,2}:\n 0.149599  0.318179  0.235567  0.779247  0.276985\n 0.175398  0.109825  0.532561  0.723127  0.621328\n 0.68087   0.639779  0.754652  0.781525  0.264776\n 0.77962   0.446314  0.805693  0.88001   0.655808\n 0.19243   0.43587   0.945708  0.109192  0.196602\n\njulia> pca_value, pca_vector = pca(a)\n([2.77556e-17,0.000524192,0.0396649,0.113626,0.128647],\n[0.483429 0.397074 … -0.376334 -0.679859; -0.738733 0.15917 … -0.379275 -0.170866; … ;\n -0.0942359 -0.593824 … 0.444543 -0.643074; -0.457645 0.345674 … 0.1949 -0.306201])\n\n\n\n"
},

{
    "location": "algo/util_function.html#ModMashup.build_index-Tuple{String}",
    "page": "Util function",
    "title": "ModMashup.build_index",
    "category": "Method",
    "text": "build_index(index_file::String)\n\nGet two dictionary, one map patients name to its id, another map patient id to its name.\n\nExample\n\n# get example data directory\nexample_data_dir = joinpath(Pkg.dir(\"ModMashup\"), \"test/data\")\n\n# Id file contains all the name of patients.\nid = joinpaht(example_data_dir,\"ids.txt\")\n\n# Build the index\npatients_index, inverse_index = build_index(id)\n\n\n\n"
},

{
    "location": "algo/util_function.html#ModMashup.parse_target-Tuple{Any,Any}",
    "page": "Util function",
    "title": "ModMashup.parse_target",
    "category": "Method",
    "text": "parse_target(target, patients_index)\n\nGet a vector of annotation for patients. (+1 for interested, -1 for others)\n\nExample\n\n\n# get example data directory\nexample_data_dir = joinpath(Pkg.dir(\"ModMashup\"), \"test/data\")\n\n# Id file contains all the name of patients.\nid = joinpaht(example_data_dir,\"ids.txt\")\n\n# Build the patient index\npatients_index, inverse_index = build_index(id)\n\n# target_file should be a flat file contains disaese for patient\ntarget_file = joinpaht(example_data_dir,\"target.txt\")\n\n# Build the annotation for each patients\nannotation = parse_target(readdlm(target_file), patients_index)\n\n\n\n"
},

{
    "location": "algo/util_function.html#ModMashup.parse_query-Tuple{Any,Any}",
    "page": "Util function",
    "title": "ModMashup.parse_query",
    "category": "Method",
    "text": "parse_query(query_file, patients_index)\n\nGet query patient id from the query file.\n\nExample\n\n\n# get example data directory\nexample_data_dir = joinpath(Pkg.dir(\"ModMashup\"), \"test/data\")\n\n# Id file contains all the name of patients.\nid = joinpaht(example_data_dir,\"ids.txt\")\n\n# Build the patient index\npatients_index, inverse_index = build_index(id)\n\n# Query file using the same format with genemania query\nquery = joinpaht(example_data_dir,\"query.txt\")\n\n# Build the annotation for each patients\nquery = parse_query(query, patients_index)\n\n\n\n"
},

{
    "location": "algo/util_function.html#ModMashup.load_net-Tuple{String,ModMashup.Database}",
    "page": "Util function",
    "title": "ModMashup.load_net",
    "category": "Method",
    "text": "load_net(filename::String,\n              database::Database)\n\nLoad similairity network from a flat file.  Format patient_name patient_name simialirty_score. Use databse to map patient_name to internal id.\n\n\n\n"
},

{
    "location": "algo/util_function.html#ModMashup.searchdir-Tuple{Any,Any}",
    "page": "Util function",
    "title": "ModMashup.searchdir",
    "category": "Method",
    "text": "searchdir(path,key)\n\nInput: directory we want to search and the keyword.\nOutput: a list of files whose name contains the keyword provided.\n\n\n\n"
},

{
    "location": "algo/util_function.html#Util-function-1",
    "page": "Util function",
    "title": "Util function",
    "category": "section",
    "text": "rwr(A::Matrix, restart_prob = 0.5)pca(A::Matrix, num::Int64=size(A,2))build_index(index_file::String)parse_target(target, patients_index)parse_query(query_file, patients_index)load_net(filename::String,\n                  database::Database)searchdir(path,key)"
},

]}
