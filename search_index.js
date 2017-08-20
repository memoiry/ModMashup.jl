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
    "location": "index.html#main-index-1",
    "page": "Home",
    "title": "Index",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#Functions-1",
    "page": "Home",
    "title": "Functions",
    "category": "section",
    "text": "Pages = [\"algo/database.md\", \"algo/label_propagation.md\", \"algo/network_integration.md\", \"algo/pipeline.md\", \"algo/common.md\"]\nOrder = [:function]"
},

{
    "location": "index.html#Types-1",
    "page": "Home",
    "title": "Types",
    "category": "section",
    "text": "Pages = [\"algo/database.md\", \"algo/label_propagation.md\", \"algo/network_integration.md\", \"algo/pipeline.md\", \"algo/common.md\"]\nOrder = [:type]"
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
    "text": "import ModMashup\ncd(joinpath(Pkg.dir(\"ModMashup\"), \"test/data\"))\ndir = \"networks\"\ntarget_file = \"target.txt\"\nquerys = \".\"\nid = \"ids.txt\"\nsmooth = true\n\n# Construct the dabase, which contains the preliminary file.\ndatabase = ModMashup.Database(dir, target_file, id, querys, smooth = smooth)\n\n# Define the algorithm you want to use to integrate the networks\nint_model = is(model, :mashup) ? ModMashup.MashupIntegration(): ModMashup.GeneMANIAIntegration()   \nlp_model = ModMashup.LabelPropagation(verbose = true)\n\n# Do both network integration and label propagation\nModMashup.fit!(int_model, lp_model, database)\n\n# Pick up the result\ncombined_network = ModMashup.get_combined_network(int_model)\nnet_weights::Dict{String, Float64} = ModMashup.get_weights(int_model)\nscore = ModMashup.get_score(lp_model)"
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
    "text": "R\njulia 0.5 +Make sure you have julia which is above the version 0.5+ and also R. You can download latest julia from the official website.Enter where netDX latest packages located.cd netDx/inst/bash\nbash install.sh Download the ModMashup.jl from the github, and run the intsall.sh file to get the package working.git clone --recursive https://github.com/memoiry/ModMashup.jl\nmv ModMashup.jl ModMashup"
},

{
    "location": "dev/work_in_R.html#Experimental-results-1",
    "page": "Working in R",
    "title": "Experimental results",
    "category": "section",
    "text": "I have made two experiments to acquire network weight.correlation between H_cur and beta.\ndot product between H_cur and beta.see GSoC report for more details about the experimental result."
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
    "text": "Store general and in-depth information for network integration and label propagation.\n\nFields\n\nstring_nets::Vector{String}: Similarity networks name.\n\ndisease::OneHotAnnotation: Disease annotation for patients.\n\nn_patients::Int: The number of patients in the databse.\n\npatients_index::Dict{String,Int}: Map patient name to their id.\n\ninverse_index::Dict{Int,String}: Map patient id to their name.\n\nnum_cv::Int: The number of cross validation round. Default is 10.\n\nquery_attr::Int: Set the annotaion for query . Default is 1.\n\nstring_querys::Vector{String}: A list of query filename.\n\nsmooth::Int: Perform smooth in the simialarty or not. Default is true.\n\nthread::Int: Number of thread for parallel computing. Default it 1.\n\nConstructor\n\nDatabase(network_dir, target_file, id, query_dir)\n\nCreate new Database.\n\nExample\n\n# get example data directory\nexample_data_dir = joinpath(Pkg.dir(\"ModMashup\"), \"test/data\")\n\n# dir should be a directory containing similairty networks flat file.\nnetwork_dir = joinpaht(example_data_dir,\"networks\")\n\n# target_file should be a flat file contains disaese for patient\ntarget_file = joinpaht(example_data_dir,\"target.txt\")\n\n# Directory where a list of query flat files are located using the \n# same format and naming manner with genemania query.\nquery_dir = example_data_dir\n\n# Id file contains all the name of patients.\nid = joinpaht(example_data_dir,\"ids.txt\")\n\n# Other setting\n## Do smooth in the network or not for mashup integration.\nsmooth = true\n## The number of thread choosen to perform computation.\nthread = 2\n\n# We are ready now, then just construct the database\ndatabase = ModMashup.Database(network_dir, target_file, \n                id, query_dir, smooth = smooth, \n                thread = thread)\n\n\n\n"
},

{
    "location": "algo/database.html#DataBase-1",
    "page": "Database",
    "title": "DataBase",
    "category": "section",
    "text": "Database"
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
    "location": "algo/label_propagation.html#ModMashup.LabelPropagation",
    "page": "Label Propagation",
    "title": "ModMashup.LabelPropagation",
    "category": "Type",
    "text": "Collection of information on the label propagation model. \n\nFields\n\ncombined_network::Matrix: combined network after network integration. labels::Vector: labels for all patients maxiter::Integer: maximum iterations taken by the method. tol::Real: stopping tolerance. verbose::Bool: print cg iteration information. plot::Bool: plot data. score::Vector: Store patient score after label propagation.\n\nConstructor\n\nLabelPropagation()\nLabelPropagation(combined_network, labels)\n\n\n\n"
},

{
    "location": "algo/label_propagation.html#Label-propagation-model-1",
    "page": "Label Propagation",
    "title": "Label propagation model",
    "category": "section",
    "text": "LabelPropagation"
},

{
    "location": "algo/label_propagation.html#ModMashup.label_propagation!-Tuple{ModMashup.LabelPropagation,ModMashup.Database}",
    "page": "Label Propagation",
    "title": "ModMashup.label_propagation!",
    "category": "Method",
    "text": "label_propagation!(model::LabelPropagation, database::Database)\n\nRunning label propagation for patient ranking.\n\nArguments\n\nmodel::LabelPropagation: Label Propagation model.\n\ndatabase::Database: store general information about the patients.\n\nOutput\n\nmodel::LabelPropagation: Result will be saved in the model fileds.\n\nReference\n\nAdapted from: GeneMANIA source code\n\n\n\n"
},

{
    "location": "algo/label_propagation.html#Generic-propagation-method-1",
    "page": "Label Propagation",
    "title": "Generic propagation method",
    "category": "section",
    "text": "label_propagation!(model::LabelPropagation, database::Database)"
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
    "text": "Modified Mashup algorithm for network integration. Inside MashupIntegration model, it contains all the result after mashup integration.\n\nFields\n\nβ::Vector: Beta vector as a result of linear regression.\nH::Matrix: Rows of H represent patients embendding in networks.\nnet_weights::Vector: Normalized mean network weights \nweights_mat::Matrix: Columns of weights_mat is computed network weights for each round of cross validation.\ncv_query::Matrix: Columns of cv_query is query id for each round of cross validation.\nsingular_value_sqrt::Vector: singular value from mashup for dimensianal reduction.\ntally::Vector{Int}: Network tally result\n\nConstructor\n\nMashupIntegration()\n\nCreate empty MashupIntegration model.\n\n\n\n"
},

{
    "location": "algo/network_integration.html#ModMashup.GeneMANIAIntegration",
    "page": "Network Integration",
    "title": "ModMashup.GeneMANIAIntegration",
    "category": "Type",
    "text": "GeneMANIA lienar regression algorithm for network integration.\n\nFields\n\nnet_weights::Dict{String, Float64}: A dictionalry map network name to its final network weights result, which is same with GeneMANIA.jar.\nnormalized::Bool: Wether normlize the network weights\nreg::Bool: Wether add regularization term to \n\n\n\n"
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
    "text": "network_integration!(model::MashupIntegration, database::GMANIA)\n\nImplement modified mashup network integration. Result will be save in the model. See MashupIntegration for more information about the result.\n\nArguments\n\nmodel::MashupIntegration: Label Propagation model.\n\ndatabase::Database: store general information about the patients.\n\nOutput\n\nmodel::LabelPropagation: Result will be saved in the model fileds.\n\n\n\n"
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
    "location": "algo/pipeline.html#ModMashup.fit!-Tuple{ModMashup.MashupIntegration,ModMashup.LabelPropagation,ModMashup.Database}",
    "page": "Pipeline",
    "title": "ModMashup.fit!",
    "category": "Method",
    "text": "fit!(int_model::MashupIntegration,\n         lp_model::LabelPropagation,\n         database::Database)\n\nPipeline the mashup integration and label propagation in one function.\n\nArguments\n\ndatabase::Database: Database for computation\nit_model::MashupIntegration: GeneMANIAIntegration model contains result from integration\nlp_model::LabelPropagation: LabelPropagation model contains result from label propgation\n\nOutputs\n\nit_model::MashupIntegration: outpus stored in model fileds.\nlp_model::LabelPropagation: outpus stored in model fileds.\n\n\n\n"
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
    "text": "fit!(int_model::MashupIntegration,\n             lp_model::LabelPropagation,\n             database::Database)fit!(database::Database,\n             it_model::GeneMANIAIntegration,\n             lp_model::LabelPropagation)"
},

{
    "location": "algo/common.html#",
    "page": "Common function",
    "title": "Common function",
    "category": "page",
    "text": ""
},

{
    "location": "algo/common.html#ModMashup.rwr",
    "page": "Common function",
    "title": "ModMashup.rwr",
    "category": "Function",
    "text": "rwr(A::Matrix, restart_prob = 0.5)\n\nRandom walk with restart.\n\nArguments\n\nA: Initial matrix for random walk.\n\nrestart_prob: Restart probability. Default 0.5.\n\nOutputs\n\nQ::Matrix: matrix after random walk.\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.pca",
    "page": "Common function",
    "title": "ModMashup.pca",
    "category": "Function",
    "text": "pca(A::Matrix, num::Int64=size(A,2))\n\nPerform PCA for a matrix.\n\nArguments\n\nA::Matrix: matrix for PCA\n\nkeywords\n\nnum::Int64=size(A,2): Number of diensions selected.\n\nOutput\n\npca vector and pca value\n\neigenvalue::Vector: as name suggested. eigenvector::Matrix: columns represent eigen vector.\n\nExample\n\njulia> a = rand(5,5)\n5×5 Array{Float64,2}:\n 0.149599  0.318179  0.235567  0.779247  0.276985\n 0.175398  0.109825  0.532561  0.723127  0.621328\n 0.68087   0.639779  0.754652  0.781525  0.264776\n 0.77962   0.446314  0.805693  0.88001   0.655808\n 0.19243   0.43587   0.945708  0.109192  0.196602\n\njulia> pca_value, pca_vector = pca(a)\n([2.77556e-17,0.000524192,0.0396649,0.113626,0.128647],\n[0.483429 0.397074 … -0.376334 -0.679859; -0.738733 0.15917 … -0.379275 -0.170866; … ;\n -0.0942359 -0.593824 … 0.444543 -0.643074; -0.457645 0.345674 … 0.1949 -0.306201])\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.build_index-Tuple{String}",
    "page": "Common function",
    "title": "ModMashup.build_index",
    "category": "Method",
    "text": "build_index(index_file::String)\n\nGet two dictionary, one map patients name to its id, another map patient id to its name.\n\nArguments\n\nindex_file::String: \n\nOutputs\n\npatients_index::Dict{String, Int}: map patientd name to its internal id.\n\ninverse_index::Dict{Int, String}: map patientd internal id to its name.\n\nExample\n\n# get example data directory\nexample_data_dir = joinpath(Pkg.dir(\"ModMashup\"), \"test/data\")\n\n# Id file contains all the name of patients.\nid = joinpaht(example_data_dir,\"ids.txt\")\n\n# Build the index\npatients_index, inverse_index = build_index(id)\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.parse_target-Tuple{Array{T,2},Dict{String,Int64}}",
    "page": "Common function",
    "title": "ModMashup.parse_target",
    "category": "Method",
    "text": "parse_target(target, patients_index)\n\nGet a vector of annotation for patients. (+1 for interested, -1 for others)\n\nInputs\n\ntarget::Matrix: colume one is patient name, colume two is patient label.\n\npatients_index::Dict{String, Int}: map patientd name to its internal id.\n\nOutputs\n\nid_label::Matrix: colume one is patient id, colume two is patient label.\n\nExample\n\n\n# get example data directory\nexample_data_dir = joinpath(Pkg.dir(\"ModMashup\"), \"test/data\")\n\n# Id file contains all the name of patients.\nid = joinpaht(example_data_dir,\"ids.txt\")\n\n# Build the patient index\npatients_index, inverse_index = build_index(id)\n\n# target_file should be a flat file contains disaese for patient\ntarget_file = joinpaht(example_data_dir,\"target.txt\")\n\n# Build the annotation for each patients\nannotation = parse_target(readdlm(target_file), patients_index)\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.parse_query-Tuple{String,Dict{String,Int64}}",
    "page": "Common function",
    "title": "ModMashup.parse_query",
    "category": "Method",
    "text": "parse_query(query_file, patients_index)\n\nGet query patient id from the query file.\n\nInputs\n\nquery_file::String: query filename whose format same with GeneMANIA query.\n\npatients_index::Dict{String, Int}: map patientd name to its internal id.\n\nOutputs\n\nquery_id::Vector: query patient id.\n\nExample\n\n\n# get example data directory\nexample_data_dir = joinpath(Pkg.dir(\"ModMashup\"), \"test/data\")\n\n# Id file contains all the name of patients.\nid = joinpaht(example_data_dir,\"ids.txt\")\n\n# Build the patient index\npatients_index, inverse_index = build_index(id)\n\n# Query file using the same format with genemania query\nquery = joinpaht(example_data_dir,\"query.txt\")\n\n# Build the annotation for each patients\nquery = parse_query(query, patients_index)\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.load_net-Tuple{String,ModMashup.Database}",
    "page": "Common function",
    "title": "ModMashup.load_net",
    "category": "Method",
    "text": "load_net(filename::String,\n              database::Database)\n\nLoad similairity network from a flat file.  Format patient_name patient_name simialirty_score. Use databse to map patient_name to internal id.\n\nInputs\n\nfilename::String: similairty network filename.\n\ndatabase::Database: store general information.\n\nOutputs\n\nA::Matrix: similairty network as a matrix.\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.searchdir-Tuple{String,String}",
    "page": "Common function",
    "title": "ModMashup.searchdir",
    "category": "Method",
    "text": "searchdir(path,key)\n\nInputs\n\npath::String: directory we want to search\n\nkey::String: keyword that the file we seached contains.\n\nOutputs\n\na list of files whose name contains the keyword provided.\nInput: directory we want to search and the keyword.\nOutput: a list of files whose name contains the keyword provided.\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.get_combined_network",
    "page": "Common function",
    "title": "ModMashup.get_combined_network",
    "category": "Function",
    "text": "get_combined_network(model::IgAbstractParams)\n\nGet combined network from network integration model.\n\nInput: Network integration model after perfrom network_integration!.\nOutput: Combined network.\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.get_weights",
    "page": "Common function",
    "title": "ModMashup.get_weights",
    "category": "Function",
    "text": "get_weights(model::IgAbstractParams)\n\nGet a dictionalry to map network name to its network weights from network integration model.\n\nInput: Network integration model after perfrom network_integration!.\nOutput: a dictionalry to map network name to its network weights.\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.get_score",
    "page": "Common function",
    "title": "ModMashup.get_score",
    "category": "Function",
    "text": "Pick up score from model after label propagation.\n\n\n\n"
},

{
    "location": "algo/common.html#Util-function-1",
    "page": "Common function",
    "title": "Util function",
    "category": "section",
    "text": "rwr(A::Matrix, restart_prob = 0.5)pca(A::Matrix, num::Int64=size(A,2))build_index(index_file::String)parse_target(target::Matrix, patients_index::Dict{String, Int})parse_query(query_file::String, patients_index::Dict{String, Int})load_net(filename::String,\n                  database::Database)searchdir(path::String,key::String)get_combined_networkget_weightsget_score"
},

{
    "location": "dev/contributions.html#",
    "page": "Contribution",
    "title": "Contribution",
    "category": "page",
    "text": ""
},

{
    "location": "dev/contributions.html#Notes-for-contributing-1",
    "page": "Contribution",
    "title": "Notes for contributing",
    "category": "section",
    "text": "Contributions are always welcome, as are feature requests and suggestions. Feel free to open issues and pull requests at any time. If you aren't familiar with git or Github please start now."
},

{
    "location": "dev/contributions.html#Setting-workspace-up-1",
    "page": "Contribution",
    "title": "Setting workspace up",
    "category": "section",
    "text": "Fork ModMashup.jl repository first.Julia's internal package manager makes it easy to install and modify packages from Github. Any package hosted on Github can be installed via Pkg.clone by providing the repository's URL, so installing a fork on your system is a simple task.Remember to replace https://github.com/memoiry/ModMashup.jl with your fork of ModMashup.jl$ julia\nPkg.clone(\"https://github.com/memoiry/ModMashup.jl\")Make a test.Pkg.test(\"ModMashup\")Everything should be working now, you can find package location in your computer by.$ julia -e \"println(Pkg.dir(\"ModMashup\"))\"Simply make a change in that folder."
},

{
    "location": "dev/contributions.html#Network-integration-1",
    "page": "Contribution",
    "title": "Network integration",
    "category": "section",
    "text": "For those who want to continue develop mashup network integration algorithm, the only function you need to modify is network_integration!.  "
},

{
    "location": "dev/contributions.html#Modified-mashup-algorithm-for-network-integration-1",
    "page": "Contribution",
    "title": "Modified mashup algorithm for network integration",
    "category": "section",
    "text": "The implementation of modified mashup algorithm for network integration is still under developing and is not fully verified its effectiveness. The current mashup integration algorithm works as below.Random walk with restarts: For each similarity network Ai, we run random walk to obtain Qi.\nSmoothing: For each Qi, we select smooth or not to smooth. Smooth means Ri = log(abs(Q) + 1/n_patients).\nConcat each Qi (not smooth) or Ri (smooth) along row axis to get a big matrix N.\nRun SVD. U,S,V = svd(N) to get U, S, V \nLet H = U * S^(1/2).\nV = S^(1/2) * V. \nLinear regression to get Beta = V’ \\ annotation ( left divide, annotation is a binary vector, 1 indicates query type, -1 indicates not-query type).\nGetting network weights through cross-validationFor each class cl in classes\n   Net_weights = matrix[N networks, 10 CV]\n   For k in 1:10 # 10-fold CV\n             Qry_k = 90% training samples of class cl \n		  For network j\n			# indices corresponding to network j and \n			# within that, samples in Qry_k\n             	H_cur = H[(j,Qry_k),] \n              All_weights = corr(H_cur,beta)\n        # Or we can get network weight by dot product \n        #     All_weights = H_cur * beta\n              Net_weights[j,k] = mean(All_weights)\n		  End \n  End\nEndReference:Compact Integration of Multi-Network Topology for Functional Analysis of Genes, pages 13."
},

{
    "location": "dev/contributions.html#Label-propagation-1",
    "page": "Contribution",
    "title": "Label propagation",
    "category": "section",
    "text": "For those who want to continue develop label propagation algorithm, the only function you need to modify is label_propagation!"
},

]}
