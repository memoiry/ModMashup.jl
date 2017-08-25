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
    "text": "This project is a part of Google summer of code 2017 program. The aim of the project is to reimplement GeneMANIA in Julia to optimize netDx for high-performance computing. "
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
    "text": "Enter Julia REPL.$ juliaThen run the command below in Julia REPL.Pkg.rm(\"ModMashup\")\nPkg.clone(\"https://github.com/memoiry/ModMashup.jl\")"
},

{
    "location": "dev/get_start.html#Example-usage-in-Julia-1",
    "page": "Quick Start",
    "title": "Example usage in Julia",
    "category": "section",
    "text": ""
},

{
    "location": "dev/get_start.html#Usage-1:-Mashup-Feature-Selection-1",
    "page": "Quick Start",
    "title": "Usage 1: Mashup Feature Selection",
    "category": "section",
    "text": "import ModMashup\ncd(joinpath(Pkg.dir(\"ModMashup\"), \"test/data\"))\n\n#Set up database information\ndir = \"networks\"\nlabels = \"target.txt\"\nquerys = \".\"\nid = \"ids.txt\"\nsmooth = true\ntop_net = \"nothing\"\n\n# Construct the dabase, which contains the preliminary file.\ndatabase = ModMashup.Database(dir, id,\n                           querys, labels_file = labels,\n                           smooth = smooth,\n                           int_type = :selection,\n                           top_net = top_net)\n\n# Define the algorithm you want to use to integrate the networks\nmodel = ModMashup.MashupIntegration()\n\n# Running network integration\nModMashup.network_integration!(model, database)\n\nnet_weights = ModMashup.get_weights(model)\ntally = ModMashup.get_tally(model)"
},

{
    "location": "dev/get_start.html#Usage-2:-Mashup-query-runner-for-patients-ranking-using-selected-networks-1",
    "page": "Quick Start",
    "title": "Usage 2: Mashup query runner for patients ranking using selected networks",
    "category": "section",
    "text": "import ModMashup\ncd(joinpath(Pkg.dir(\"ModMashup\"), \"test/data\"))\n\n#Set up database information\ndir = \"networks\"\nquerys = \"CV_1.query\"\nid = \"ids.txt\"\nsmooth = true\n# Top_networks contains selected top ranked networks.\ntop_net = \"top_networks.txt\"\n\n# Construct the dabase, which contains the preliminary file.\ndatabase = ModMashup.Database(dir, id, \n   querys, smooth = smooth,\n   int_type = :ranking,\n   top_net = top_net)\n\n# Define the algorithm you want to use to integrate the networks\nint_model = ModMashup.MashupIntegration()\nlp_model = ModMashup.LabelPropagation(verbose = true)\n\n# Running network integration\nModMashup.fit!(int_model, lp_model, database)\n\n# Pick up the result\n#combined_network = ModMashup.get_combined_network(int_model)\nnet_weights = ModMashup.get_weights(int_model)\nscore = ModMashup.get_score(lp_model)\n    "
},

{
    "location": "dev/CommandLine.html#",
    "page": "Command line tool",
    "title": "Command line tool",
    "category": "page",
    "text": ""
},

{
    "location": "dev/CommandLine.html#Mashup-command-tool-1",
    "page": "Command line tool",
    "title": "Mashup command tool",
    "category": "section",
    "text": "This project provide a Command Line Tool located in mashup.jl, which has two usage.Modified Mashup feature selection.\nLabel propagation for patients ranking.Arguments:\"command\"\n  help = \"what function do you want to use? ie. selection, ranking\"\n  arg_type = String\n  required = true\n\"--net\"\n  help = \"Folder name where the similarity network is stored\"\n  arg_type = String\n  required = true\n\"--id\"\n  help = \"Patients name in the database\"\n  arg_type = String\n  required = true\n\"--labels\"\n  help = \"If for selection, it should be labels file name. If for ranking, it should be query file name and we use it to label patients.\"\n  arg_type = String\n  default = \"nothing\"\n\"--CV_query\"\n  help = \"If for selection, folder name where Query files stored. If for ranking, single query file name for use to label patients\"\n  arg_type = String\n\"--top_net\"\n  help = \"This keyword is used for ranking, it should be file containing selected networks name.\"\n  arg_type = String\n  default = \"nothing\"\n\"--smooth\"\n  help = \"smooth the net or not\"\n  arg_type = Bool\n  default = true\n\"--res_dir\"\n  help = \"where to put the result\"\n  arg_type = String\n\"--cut_off\"\n  help = \"cut_off to select top ranked network in network integration\"\n  arg_type = Int\n  default = 9Outputs:For selectionnetworks_weights_with_name.txt: Txt file mapping networks name to its weights.\nmashup_tally.txt: Txt file mapping networks name to its tally.\ntop_networks.txt: Txt file containing selected networks after cross validation.\nnetworks_index.txt: Txt file mapping networks name to its internal id.\ncv_query.txt: Txt file containing query internal id of each cross validation.\nbeta.txt: Txt file containing beta vector.\nnetworks_weights_each_cv.txt: Txt file containing network weights of each cross validation.\nsingular_value_sqrt.txt: Txt file containing sqrt of singular value.For rankingxxx_mashup_PRANK.txt: Txt file mapping patients name to their weights.\nxxx_mashup_NRANK.txt: Txt file mapping networks name to its weights."
},

{
    "location": "dev/CommandLine.html#Example-1",
    "page": "Command line tool",
    "title": "Example",
    "category": "section",
    "text": ""
},

{
    "location": "dev/CommandLine.html#Usage-1:-Mashup-Feature-Selection-1",
    "page": "Command line tool",
    "title": "Usage 1: Mashup Feature Selection",
    "category": "section",
    "text": "First ensure that you have ModMashup.jl correctly installed in your computer.$ var=$(julia -e \"println(Pkg.dir())\")\n$ var=\"$var/ModMashup/test/data\"\n$ cd $var\n$ mkdir temp_res\n$ julia ../../tools/mashup.jl selection --net networks --id ids.txt --labels target.txt --CV_query . --smooth true --res_dir temp_resThe result will be saved at temp_res folder."
},

{
    "location": "dev/CommandLine.html#Usage-2:-Mashup-query-runner-for-patients-ranking-using-selected-networks-1",
    "page": "Command line tool",
    "title": "Usage 2: Mashup query runner for patients ranking using selected networks",
    "category": "section",
    "text": "After feature selection, you can run the command below to get patients ranking.$ julia ../../tools/mashup.jl ranking --top_net temp_res/smooth_result/top_networks.txt --net networks --id ids.txt --CV_query CV_1.query --smooth true --res_dir temp_resThe result will be saved at temp_res folder."
},

{
    "location": "dev/GSoC.html#",
    "page": "GSoC summary - End-to-end example",
    "title": "GSoC summary - End-to-end example",
    "category": "page",
    "text": ""
},

{
    "location": "dev/GSoC.html#GSoC-Project-Summary-and-End-to-End-Example-1",
    "page": "GSoC summary - End-to-end example",
    "title": "GSoC Project Summary and End-to-End Example",
    "category": "section",
    "text": "Google Summer of Code 2017 is approaching to its finish line. Time to sum up what has been completed! Check ModMashup.jl to get all the source code. "
},

{
    "location": "dev/GSoC.html#What?-1",
    "page": "GSoC summary - End-to-end example",
    "title": "What?",
    "category": "section",
    "text": "The goal of the project was to replace GeneMANIA's network integration algorithm with a smaller memory footprint for high-performance computing. And, of course, having a command-line tool that can be integrated into any packages or system. The aim is to reduce the time needed to perform netDX query. Now we can say the project have successfully achieved this goal! (50x faster with promising accuracy)"
},

{
    "location": "dev/GSoC.html#How?-1",
    "page": "GSoC summary - End-to-end example",
    "title": "How?",
    "category": "section",
    "text": "We design a novel method to replace linear regression part of GeneMANIA with a network embedding algorithm called Mashup, check Algorithm details here.The main contribution of ModMashup.Utilize network embedding to infer network weights.\nRun cross validation in single query with a list of queries file, no more time is needed for re-initialization.\nOnly need similarity networks file and utilize julia's internal functionality to index patients' name to their id while GeneMANIA cost many time to construct Java database.Input of this tutorial: Mashup and GeneMANIA example shared same input.TCGA Breast cancer dataset. Information used was patient ID and whether tumour is of subtype ‘Luminal A’ (LumA) or other.\nN=348 patients with 232 as traning samples. Classes={LumA, other} annotation. \nSimilarity nets defined at the level of pathways, using Pearson correlation (ProfileToNetworkDriver) as similarity. Generates 1801 networks."
},

{
    "location": "dev/GSoC.html#Result-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Result",
    "category": "section",
    "text": "This implementation in Julia is 50x faster(90 s ) than Java's implementation(4500 s) while achieving same and even better accuracy than raw GeneMANIA. Class #total #train # selected networks accuracy PPV\nLumA 154 103 83 48/51(94.1%) 48/58(81.4%)\nother 194 129 73 55/65(84.5%) 55/58(94.9%)Table 1: netDX with ModMashup as kernel on BreastCancer dataset.Class #total #train # selected networks accuracy PPV\nLumA 154 103 58 47/51(92.2%) 47/58(81.0%)\nother 194 129 49 54/65(83.1%) 54/58(93.1%)Table 2: netDX with GeneMANIA as kernel on BreastCancer dataset."
},

{
    "location": "dev/GSoC.html#Relation-between-networks-tally-obtained-from-GeneMANIA-and-ModMashup-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Relation between networks tally obtained from GeneMANIA and ModMashup",
    "category": "section",
    "text": "<p align=\"center\"><img src=\"https://i.loli.net/2017/08/25/599fb1f8203dc.png\" width=500></img></p>Figure 1: networks tally from GeneMANIA versus those from ModMashup for LumA type.<p align=\"center\"><img src=\"https://i.loli.net/2017/08/25/599fb1f43987d.png\" width=500></img></p> Figure 2: networks tally from GeneMANIA versus those from ModMashup for other type."
},

{
    "location": "dev/GSoC.html#Relation-between-networks-weight-obtained-from-GeneMANIA-and-ModMashup-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Relation between networks weight obtained from GeneMANIA and ModMashup",
    "category": "section",
    "text": "I have made two experiments to acquire network weight.Correlation between H_cur and beta.\nDot product between H_cur and beta.see GSoC report for more details about the experimental result."
},

{
    "location": "dev/GSoC.html#End-to-End-example-in-R-1",
    "page": "GSoC summary - End-to-end example",
    "title": "End-to-End example in R",
    "category": "section",
    "text": "For those who want to use ModMashup in R and reproduce the experiment above.I have developed a ModMashup command line tool for R's calling. \nTo wrap Julia's command line tool in R, I created two function to facilitate the procedure.One is runMashup.R, which is the main function to call mashup command line tool. Another one is mashup_runCV_featureSet.R, a wrapper function around runMashup.R to facilitate selection of interested networks."
},

{
    "location": "dev/GSoC.html#Required-Dependencies-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Required Dependencies",
    "category": "section",
    "text": "R\njulia 0.5 +Make sure you have julia which is above the version 0.5+ and also R. You can download latest julia from the official website.Enter where latest netDX_mashup packages located, you can find it in github.$ git clone https://github.com/memoiry/netDx_mashup\n$ cd netDx_mashupFirst install netDX R pakcage$ R\ninstall.packages(c(\"bigmemory\",\"foreach\",\"combinat\",\"doParallel\",\"ROCR\",\"pracma\",\"RColorBrewer\",\"reshape2\"))\ninstall.packages(\"netDx\",type=\"source\",repos=NULL)\ninstall.packages(\"netDx.examples\",type=\"source\",repos=NULL)\ninstall.packages(\"knitr\")Then install ModMashup dependency.## $ cd netDx/inst/julia\n$ bash install.shTest ModMashup package to ensure you have correctly installed it.julia -e 'Pkg.test(\"ModMashup\")'If the test has passed, everything should be working now."
},

{
    "location": "dev/GSoC.html#Tutorial-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Tutorial",
    "category": "section",
    "text": "This tutorial shows the steps to build a breast tumour classifier using ModMashup and GeneMANIA(To enable GeneMANIA parts, you need to uncomment GeneMANIA's code below) by integrating gene expression. To keep things simple, in this tutorial we build a binary classifier that discriminates between the Luminal A and other subtypes. You can find the source code of the tutorial at gist and generated pdf report.Through this Tutorial, we will use the following capabilities of ModMashup:Perform feature selection on the training set\nAssess performance on the test setThe algorithm proceeds in two steps:Feature selection\nPredicting classes of test samples"
},

{
    "location": "dev/GSoC.html#Set-up-environment-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Set up environment",
    "category": "section",
    "text": "\n################################################################################\n#Uncoment GeneMANIA parts to compare it with Mashup using #same queries\n################################################################################\n\nrm(list=ls())\n\n\n# Change this to a local directory where you have write permission\noutDir <- sprintf(\"%s/TCGA_BRCA\",getwd())\ncat(sprintf(\"All intermediate files are stored in:\\n%s\\n\",outDir))\n\nnumCores 	<- 2L  	# num cores available for parallel processing\nGMmemory 	<- 4L  	# java memory in Gb\ncutoff		<- 9L  	# score cutoff for feature-selected networks\nTRAIN_PROP <- 0.67 	# fraction of samples to use for training\n\nif (file.exists(outDir)) unlink(outDir,recursive=TRUE)\ndir.create(outDir)"
},

{
    "location": "dev/GSoC.html#Load-the-netDx-software-and-data-packages.-Finally,-load-the-breast-cancer-dataset.-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Load the netDx software and data packages. Finally, load the breast cancer dataset.",
    "category": "section",
    "text": "# import the required packages\nrequire(netDx)\nrequire(netDx.examples)\ndata(TCGA_BRCA)"
},

{
    "location": "dev/GSoC.html#Split-the-train-and-test-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Split the train and test",
    "category": "section",
    "text": "subtypes<- c(\"LumA\")\npheno$STATUS[which(!pheno$STATUS %in% subtypes)] <- \"other\"\nsubtypes <- c(subtypes,\"other\") # add residual\n\npheno$TT_STATUS <- splitTestTrain(pheno,\n                                  pctT = TRAIN_PROP,setSeed = 42)"
},

{
    "location": "dev/GSoC.html#Create-similairty-network-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Create similairty network",
    "category": "section",
    "text": "pheno_FULL	<- pheno\nxpr_FULL 	<- xpr\npheno		<- subset(pheno,TT_STATUS %in% \"TRAIN\")\nxpr			<- xpr[,which(colnames(xpr)%in% pheno$ID)]\n\n## Pathway\npathFile <- sprintf(\"%s/extdata/Human_160124_AllPathways.gmt\", \n                    path.package(\"netDx.examples\"))\npathwayList <- readPathways(pathFile)\nhead(pathwayList)"
},

{
    "location": "dev/GSoC.html#Gene-data-networks-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Gene data networks",
    "category": "section",
    "text": "From gene expression data, we create one network per cellular pathway. Similarity between two patients is defined as the Pearson correlation of the expression vector; each network is limited to genes for the corresponding pathway. profDir <- sprintf(\"%s/profiles\",outDir)\nnetDir <- sprintf(\"%s/networks\",outDir)\n\n\nnetList <- makePSN_NamedMatrix(xpr, rownames(xpr), \n                               pathwayList,profDir,verbose=FALSE,\n                               numCores=numCores,writeProfiles=FALSE)\n\nnetList <- unlist(netList)\nhead(netList)\n\n##################################################################\n## Create GM database and also interaction 'txt' file\n#dbDir	<- GM_createDB(profDir, pheno$ID, outDir,numCores=numCores)\n##################################################################"
},

{
    "location": "dev/GSoC.html#Feature-selection-for-each-class-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Feature selection for each class",
    "category": "section",
    "text": "The goal of this step is to extract the networks that are most predictive of a given class. For each subtype, here \"LumA\" and \"other\", feature selection is performed once.mashup_runCV_featureSet(), which runs the cross-validation with successive ModMashup queries and returns top ranked network.Remember to set mashup_runCV_featureSet's keyword write_query to FALSE if you want to uncomment GeneMANIA's code so that mashup will use query files generated by GeneMANIA for comparing the result.top_net_file <- list()\nmashup_tally <- list()\nfor (g in subtypes) {\n  pDir <- sprintf(\"%s/%s\",outDir,g)\n  if (file.exists(pDir)) unlink(pDir,recursive=TRUE)\n  dir.create(pDir)\n  \n  cat(sprintf(\"\\n******\\nSubtype %s\\n\",g))\n  pheno_subtype <- pheno\n  \n  ## label patients not in the current class as a residual\n  pheno_subtype$STATUS[which(!pheno_subtype$STATUS %in% g)] <- \"nonpred\"\n  ## sanity check\n  print(table(pheno_subtype$STATUS,useNA=\"always\"))\n  \n  GM_resDir    <- sprintf(\"%s/GM_results\",pDir)\n  Mashup_resDir <- sprintf(\"%s/Mashup_results\",pDir)\n  ## query for feature selection comprises of training \n  ## samples from the class of interest\n  trainPred <- pheno$ID[which(pheno$STATUS %in% g)]\n  \n  \n  ######$$Here we call GeneMANIA feature network selection################\n  # Cross validation for genemania\n  #GM_runCV_featureSet(trainPred, GM_resDir, dbDir$dbDir, \n  #                  nrow(pheno_subtype),verbose=T, numCores=numCores,\n  #                    GMmemory=GMmemory)\n  #\n  # patient similarity ranks\n  #prank <- dir(path=GM_resDir,pattern=\"PRANK$\")\n  ## network ranks\n  #nrank <- dir(path=GM_resDir,pattern=\"NRANK$\")\n  #cat(sprintf(\"Got %i prank files\\n\",length(prank)))\n\n  # Compute network score\n  #pTally	<- GM_networkTally(paste(GM_resDir,nrank,sep=\"/\"))\n  #head(pTally)\n  # write to file\n  #tallyFile	<- sprintf(\"%s/%s_pathway_CV_score_genemania.txt\",GM_resDir,g)\n  #write.table(pTally,file=tallyFile,sep=\"\\t\",col=T,row=F,quote=F)\n  #####################################################################\n  \n  # Cross validation for mashup\n  # remember to set keyword write_query = FALSE if you want to uncomment GeneMANIA algorithm,\n  # which indicates mashup will use query file from genemania instead of \n  # generating query files by itself, so the query files are shared between genemania and \n  # mashup for further comparation.\n  mashup_res <- mashup_runCV_featureSet(profDir, GM_resDir, pheno_subtype, trainID_pred = trainPred,\n                                        write_query = TRUE, smooth = TRUE, verbose=T, \n                                        numCores = numCores, cut_off = cutoff)\n  # List of selected top networks name\n  mashup_tally[[g]] <- mashup_res$tally\n  # Selected top networks txt file name\n  top_net_file[[g]] <- mashup_res$top_net\n  cat(sprintf(\"Mashup-%s: %i networks\\n\",g,length(mashup_tally[[g]])))\n}"
},

{
    "location": "dev/GSoC.html#Rank-test-patients-using-trained-model-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Rank test patients using trained model",
    "category": "section",
    "text": "runMashup(), which runs ModMashup patients ranking and return the name of NRANK file.pheno <- pheno_FULL\npredRes_GM <- list()\npredRes_mashup <- list()\nfor (g in subtypes) {\n  pDir <- sprintf(\"%s/%s\",outDir,g)\n  #####################################################################\n  # get GeneMANIA's feature selected net names\n  #pTally <- read.delim(\n  #sprintf(\"%s/GM_results/%s_pathway_CV_score_genemania.txt\",pDir,g),\n  #sep=\"\\t\",h=T,as.is=T)\n  #pTally <- pTally[which(pTally[,2]>=cutoff),1]\n  #pTally <- sub(\".profile\",\"\",pTally)\n  #pTally <- sub(\"_cont\",\"\",pTally)\n#  \n  #cat(sprintf(\"%s: %i pathways\\n\",g,length(pTally)))\n  #profDir_GM <- sprintf(\"%s/profiles_GM\",pDir)\n  #####################################################################\n  profDir_mashup <- sprintf(\"%s/profiles_mashup\",pDir)\n  if(!file.exists(profDir_mashup)) \n    dir.create(profDir_mashup)\n  \n  # prepare nets for net mashup db\n  tmp <- makePSN_NamedMatrix(xpr_FULL,rownames(xpr),\n                             pathwayList[which(names(pathwayList)%in% mashup_tally[[g]])],\n                             profDir_mashup,verbose=F,numCores=numCores)\n  #####################################################################\n  # prepare nets for new genemania db\n  #tmp <- makePSN_NamedMatrix(xpr_FULL,rownames(xpr),\n  #                           pathwayList[which(names(pathwayList)%in% pTally)],\n  #                           profDir_GM,verbose=F,numCores=numCores)\n  #\n  # create db\n  #dbDir <- GM_createDB(profDir_GM,pheno$ID,pDir,numCores=numCores)\n  #####################################################################\n  \n  # Delete existed result file in case conflicts.\n  redundant_result_file <- list.files(path = sprintf(\"%s\", pDir), pattern = \"query\")\n  unlink(paste0(pDir, \"/\",redundant_result_file))\n  \n  # query of all training samples for this class\n  qSamps <- pheno$ID[which(pheno$STATUS %in% g & pheno$TT_STATUS%in%\"TRAIN\")]\n  qFile <- sprintf(\"%s/%s_query\",pDir,g)\n  GM_writeQueryFile(qSamps,\"all\",nrow(pheno),qFile)\n  \n  # Running patient ranking for mashup\n  mashup_resFile <- runMashup(profDir_mashup, qFile, pheno, top_net = top_net_file[[g]], ranking = TRUE, \n                              smooth = TRUE)\n  # Save the reresult.\n  predRes_mashup[[g]] <- GM_getQueryROC(mashup_resFile, pheno, g, plotIt=TRUE)\n\n  #####################################################################\n  ## Running patient ranking for genemania\n  #Genemania_resFile <- runGeneMANIA(dbDir$dbDir,qFile,resDir=pDir)\n  # Analysis the ROC\n  #predRes_GM[[g]] <- GM_getQueryROC(sprintf(\"%s.PRANK\",Genemania_resFile),pheno, g, plotIt=TRUE)\n  #####################################################################\n}"
},

{
    "location": "dev/GSoC.html#Assign-labels-to-test-patients-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Assign labels to test patients",
    "category": "section",
    "text": "Here we use GM_OneVAll_getClass() to label patients by max rank and finally evaluate the performance of the classifier.## Stats for Mashup result\npredClass_mashup <- GM_OneVAll_getClass(predRes_mashup)\ncat(\"Start Print result of mashup..\")\nboth <- merge(x=pheno,y=predClass_mashup,by=\"ID\")\nprint(table(both[,c(\"STATUS\",\"PRED_CLASS\")]))\npos <- (both$STATUS %in% \"LumA\")\ntp <- sum(both$PRED_CLASS[pos]==\"LumA\")\nfp <- sum(both$PRED_CLASS[!pos]==\"LumA\")\ntn <- sum(both$PRED_CLASS[!pos]==\"other\")\nfn <- sum(both$PRED_CLASS[pos]==\"other\")\ncat(sprintf(\"Accuracy = %i of %i (%i %%)\\n\",tp+tn,nrow(both),\n            round(((tp+tn)/nrow(both))*100)))\ncat(sprintf(\"PPV = %i %%\\n\", round((tp/(tp+fp))*100)))\ncat(sprintf(\"Recall = %i %%\\n\", round((tp/(tp+fn))*100)))\n\n######################################################################\n## Stats for GeneMANIA result\n#predClass_GM <- GM_OneVAll_getClass(predRes_GM)\n#cat(\"Start Print result of genemania\")\n#both <- merge(x=pheno,y=predClass_GM,by=\"ID\")\n#print(table(both[,c(\"STATUS\",\"PRED_CLASS\")]))\n#pos <- (both$STATUS %in% \"LumA\")\n#tp <- sum(both$PRED_CLASS[pos]==\"LumA\")\n#fp <- sum(both$PRED_CLASS[!pos]==\"LumA\")\n#tn <- sum(both$PRED_CLASS[!pos]==\"other\")\n#fn <- sum(both$PRED_CLASS[pos]==\"other\")\n#cat(sprintf(\"Accuracy = %i of %i (%i %%)\\n\",tp+tn,nrow(both),\n#            round(((tp+tn)/nrow(both))*100)))\n#cat(sprintf(\"PPV = %i %%\\n\", round((tp/(tp+fp))*100)))\n#cat(sprintf(\"Recall = %i %%\\n\", round((tp/(tp+fn))*100)))\n#####################################################################"
},

{
    "location": "dev/GSoC.html#Credits-1",
    "page": "GSoC summary - End-to-end example",
    "title": "Credits",
    "category": "section",
    "text": "netDX BreastCancer example"
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
    "text": "Store general and in-depth information for network integration and label propagation.\n\nGenerally, it contains all similairty networks's file name, patient id-name dictionary,  query, patients labels, (keyword: smooth or not, use 1 as query or -1, selection or patients ranking, if ranking , provide top_net file containing selected network).\n\nInside Database, I simply use a dictionary to map patients' name to their internal id.\n\nFor example, you can access labels information in Database through  database.labels\n\nFields\n\nstring_nets::Vector{String}: A vector of similarity networks file name.\n\nlabels::OneHotAnnotation: Disease annotation for patients.\n\nn_patients::Int: The number of patients in the databse.\n\npatients_index::Dict{String,Int}: Map patient name to their id.\n\ninverse_index::Dict{Int,String}: Map patient id to their name.\n\nnum_cv::Int: The number of cross validation round. Default is 10.\n\nquery_attr::Int: Set the annotaion for query . Default is 1.\n\nstring_querys::Vector{String}: A list of query filename.\n\nsmooth::Int: Perform smooth in the simialarty or not. Default is true.\n\nint_type::Symbol: Symbol indicate the dabase is for networks selection or  patients ranking. It could be :ranking or :selection, Default is :selection.\n\nthread::Int: The number of thread used to running the program. Default it 1.\n\nKeywords\n\nnum_cv::Int: The number of cross validation round. Default is 10.\n\nquery_attr::Int: Set the annotaion for query . Default is 1.\n\nstring_querys::Vector{String}: A list of query filename.\n\nsmooth::Int: Perform smooth in the simialarty or not. Default is true.\n\nint_type::Symbol: Symbol indicate the dabase is for networks selection or  patients ranking. It could be :ranking or :selection, Default is :selection.\n\nthread::Int: The number of thread used to running the program. Default it 1.\n\ntop_net::String: a txt file contains the name of selected top ranked networks.\n\nConstructor\n\nDatabase(network_dir, id, query_dir;kwarg...)\n\nCreate new Database. See example data in test/data folder.\n\nExample\n\n# enter example data directory\ncd(joinpath(Pkg.dir(\"ModMashup\"), \"test/data\"))\n\n# dir should be a directory containing similairty networks flat file.\nnetwork_dir = \"networks\"\n\n# target_file should be a flat file contains labels for patient\nlabels = \"target.txt\"\n\n# Directory where a list of query flat files are located using the \n# same format and naming manner with genemania query.\n# If database is used to ranking instead of selection,\n# query_dir should be a single query file instead of a directory.\n# query files should contains keyword `query`.\nquery_dir = \".\"\n\n# Id file contains all the name of patients.\nid = \"ids.txt\"\n\n# Other setting\n## Do smooth in the network or not for mashup integration.\nsmooth = true\n\n# Construct the dabase, which contains the preliminary file.\ndatabase = ModMashup.Database(network_dir, id,\n            query_dir, labels = labels,\n            smooth = smooth,\n            int_type = :selection)\n\n\n\n"
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
    "text": "Collection of information on the label propagation model. \n\nFields\n\ncombined_network::Matrix: combined network after network integration.\n\nlabels::Vector: labels for all patients\n\nscore_method::Symbol: z-score or discriminant method to score the patients.\n\nmaxiter::Integer: maximum iterations taken by the method.\n\ntol::Real: stopping tolerance.\n\nverbose::Bool: print cg iteration information.\n\nplot::Bool: plot the norm of the residual from label propagation‘s Conjugate Gradient optimization history.\n\nscore::Vector: Store patient score after label propagation.\n\nConstructor\n\nLabelPropagation()\nLabelPropagation(combined_network, labels)\n\n\n\n"
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
    "text": "Modified Mashup algorithm for network integration. Inside MashupIntegration model, it contains all the result after mashup integration.\n\nFields\n\nβ::Vector: Beta vector as a result of linear regression.\n\nH::Matrix: Rows of H represent patients embendding in networks.\n\nnet_weights::Dict{String, Float64}: Normalized mean network weights \n\nweights_mat::Matrix: Columns of weights_mat is computed network weights for each round of cross validation.\n\ncv_query::Matrix: Columns of cv_query is query id for each round of cross validation.\n\nsingular_value_sqrt::Vector: singular value from mashup for dimensianal reduction.\n\ntally::Dict{String, Int}: Network tally result\n\ncombined_network::Matrix: Combined single similarity network using network weights.\n\nConstructor\n\nMashupIntegration()\n\nCreate empty MashupIntegration model.\n\n\n\n"
},

{
    "location": "algo/network_integration.html#ModMashup.GeneMANIAIntegration",
    "page": "Network Integration",
    "title": "ModMashup.GeneMANIAIntegration",
    "category": "Type",
    "text": "GeneMANIA lienar regression algorithm for network integration.\n\nFields\n\nnet_weights::Dict{String, Float64}: A dictionalry map network name to its final network weights result, which is same with GeneMANIA.jar.\n\ncombined_network::Matrix: Combined single similarity network using network weights.\n\nnormalized::Bool: Wether normlize the network weights.\n\nreg::Bool: Wether add regularization term to the model.\n\n\n\n"
},

{
    "location": "algo/network_integration.html#Integration-model-1",
    "page": "Network Integration",
    "title": "Integration model",
    "category": "section",
    "text": "The package provided two algorithm for network integration, one is MashupIntegration and another is GeneMANIAIntegration (GeneMANIA's raw networks integration is not fully tested).MashupIntegrationGeneMANIAIntegration"
},

{
    "location": "algo/network_integration.html#ModMashup.network_integration!-Tuple{ModMashup.MashupIntegration,ModMashup.Database}",
    "page": "Network Integration",
    "title": "ModMashup.network_integration!",
    "category": "Method",
    "text": "network_integration!(model::MashupIntegration, database::GMANIA)\n\nImplement modified mashup network integration. Result will be save in the model. See MashupIntegration for more information about the result.\n\nArguments\n\nmodel::MashupIntegration: Mashup network integration model.\n\ndatabase::Database: Store general information about the patients and networks. \n\n\n\n"
},

{
    "location": "algo/network_integration.html#ModMashup.network_integration!-Tuple{ModMashup.GeneMANIAIntegration,ModMashup.Database}",
    "page": "Network Integration",
    "title": "ModMashup.network_integration!",
    "category": "Method",
    "text": "network_integration!(model::GeneMANIAIntegration, database::GMANIA)\n\nArguments\n\nmodel::GeneMANIAIntegration: GeneMANIA network integration model.\n\ndatabase::Database: Store general information about the patients and networks. \n\nImplement Raw mashup network integration. Result will be saved in the model. See GeneMANIAIntegration for more information about the result. (Currently not fully tested.)\n\n\n\n"
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
    "text": "fit!(int_model::MashupIntegration,\n         lp_model::LabelPropagation,\n         database::Database)\n\nPipeline the mashup integration and label propagation in one function.\n\nArguments\n\ndatabase::Database: Database for computation\n\nit_model::MashupIntegration: GeneMANIAIntegration model contains result from integration\n\nlp_model::LabelPropagation: LabelPropagation model contains result from label propgation\n\nOutputs\n\nit_model::MashupIntegration: outpus stored in model fileds.\n\nlp_model::LabelPropagation: outpus stored in model fileds.\n\n\n\n"
},

{
    "location": "algo/pipeline.html#ModMashup.fit!-Tuple{ModMashup.Database,ModMashup.GeneMANIAIntegration,ModMashup.LabelPropagation}",
    "page": "Pipeline",
    "title": "ModMashup.fit!",
    "category": "Method",
    "text": "fit!(database::Database,\n         it_model::GeneMANIAIntegration,\n         lp_model::LabelPropagation)\n\nPipeline the genemania integration and label propagation in one function. (Currently not implemented.)\n\nArguments\n\ndatabase::Database: Database for computation\n\nit_model::GeneMANIAIntegration: GeneMANIAIntegration model contains result from integration\n\nlp_model::LabelPropagation: LabelPropagation model contains result from label propgation\n\n\n\n"
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
    "text": "build_index(index_file::String)\n\nGet two dictionary, one map patients name to its id, another map patient id to its name.\n\nArguments\n\nindex_file::String: \n\nOutputs\n\npatients_index::Dict{String, Int}: map patientd name to its internal id.\n\ninverse_index::Dict{Int, String}: map patientd internal id to its name.\n\nExample\n\n# get example data directory\nexample_data_dir = joinpath(Pkg.dir(\"ModMashup\"), \"test/data\")\n\n# Id file contains all the name of patients.\nid = joinpath(example_data_dir,\"ids.txt\")\n\n# Build the index\npatients_index, inverse_index = build_index(id)\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.parse_target-Tuple{Array{T,2} where T,Dict{String,Int64}}",
    "page": "Common function",
    "title": "ModMashup.parse_target",
    "category": "Method",
    "text": "parse_target(target::Matrix,\n    patients_index::Dict{String, Int})\n\nGet a vector of annotation for patients. (+1 for interested, -1 for others)\n\nInputs\n\ntarget::Matrix: colume one is patient name, colume two is patient label.\n\npatients_index::Dict{String, Int}: map patientd name to its internal id.\n\nOutputs\n\nid_label::Matrix: colume one is patient id, colume two is patient label.\n\nExample\n\n\n# get example data directory\nexample_data_dir = joinpath(Pkg.dir(\"ModMashup\"), \"test/data\")\n\n# Id file contains all the name of patients.\nid = joinpath(example_data_dir,\"ids.txt\")\n\n# Build the patient index\npatients_index, inverse_index = build_index(id)\n\n# target_file should be a flat file contains disaese for patient\ntarget_file = joinpath(example_data_dir,\"target.txt\")\n\n# Build the annotation for each patients\nannotation = parse_target(readdlm(target_file), patients_index)\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.parse_query-Tuple{String,Dict{String,Int64}}",
    "page": "Common function",
    "title": "ModMashup.parse_query",
    "category": "Method",
    "text": "parse_query(query_file, patients_index)\n\nGet query patient id from the query file.\n\nInputs\n\nquery_file::String: query filename whose format same with GeneMANIA query.\n\npatients_index::Dict{String, Int}: map patientd name to its internal id.\n\nOutputs\n\nquery_id::Vector: query patient id.\n\nExample\n\n\n# get example data directory\nexample_data_dir = joinpath(Pkg.dir(\"ModMashup\"), \"test/data\")\n\n# Id file contains all the name of patients.\nid = joinpath(example_data_dir,\"ids.txt\")\n\n# Build the patient index\npatients_index, inverse_index = build_index(id)\n\n# Query file using the same format with genemania query\nquery = joinpath(example_data_dir,\"query.txt\")\n\n# Build the annotation for each patients\nquery = parse_query(query, patients_index)\n\n\n\n"
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
    "text": "get_combined_network(model::IgAbstractParams)\n\nGet combined network from network integration model.\n\nInput\n\nNetwork integration model after perfrom network_integration!.\n\nOutput\n\nCombined network.\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.get_weights",
    "page": "Common function",
    "title": "ModMashup.get_weights",
    "category": "Function",
    "text": "get_weights(model::IgAbstractParams)\n\nGet a dictionalry to map network name to its network weights from network integration model.\n\nInput\n\nNetwork integration model after perfrom network_integration!.\n\nOutput\n\na dictionalry to map network name to its network weights.\n\n\n\n"
},

{
    "location": "algo/common.html#ModMashup.get_score",
    "page": "Common function",
    "title": "ModMashup.get_score",
    "category": "Function",
    "text": "get_score(model::LabelPropagation)\n\nArguments\n\nmodel::LabelPropagation: Label propagation model.\n\nOutputs\n\nscore::Dict{String, Float64}: A dictionary maps patients' name to their score.\n\nPick up score from model after label propagation.\n\n\n\n"
},

{
    "location": "algo/common.html#Common-function-1",
    "page": "Common function",
    "title": "Common function",
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
