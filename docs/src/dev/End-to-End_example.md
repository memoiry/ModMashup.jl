
         
         
### End-to-End example in R

For those who want to use [ModMashup](https://github.com/memoiry/ModMashup.jl) in R and reproduce the experiment above.

1. I have developed a [ModMashup command line tool](https://github.com/memoiry/ModMashup.jl/blob/master/tools/mashup.jl) for R's calling. 
2. To wrap Julia's command line tool in R, I created two function to facilitate the procedure.One is [`runMashup.R`](https://gist.github.com/memoiry/30715257430b3896507996c53532fe5c#file-runmashup-r), which is the main function to call mashup command line tool. Another one is [`mashup_runCV_featureSet.R`](https://gist.github.com/memoiry/30715257430b3896507996c53532fe5c#file-mashup_runcv_featureset-r), a wrapper function around `runMashup.R` to facilitate selection of interested networks.


##### Required Dependencies

- R
- julia 0.5 +

Make sure you have julia which is above the version 0.5+ and also R. You can download latest julia from the [official website](https://julialang.org/downloads/).

Enter where latest netDX_mashup packages located. 

```bash
cd netDx_mashup
```

First install netDX R pakcage.

```bash
$ R
install.packages(c("bigmemory","foreach","combinat","doParallel","ROCR","pracma","RColorBrewer","reshape2"))
install.packages("netDx",type="source",repos=NULL)
install.packages("netDx.examples",type="source",repos=NULL)
install.packages("knitr")
```

Then install ModMashup dependency.

```bash
$ cd netDx/inst/julia
$ bash install.sh
```

Test ModMashup package to ensure you have correctly installed it.

```bash
$ julia -e 'Pkg.test("ModMashup")'
```

If the test has passed, everything should be working now.





#### Tutorial


This tutorial shows the steps to build a breast tumour classifier using ModMashup and GeneMANIA(To enable GeneMANIA parts, you need to uncomment GeneMANIA's code below) by integrating gene expression. To keep things simple, in this tutorial we build a binary classifier that discriminates between the Luminal A and other subtypes. You can find the source code of the tutorial at [gist](https://gist.github.com/memoiry/875d62d6cf89a7ac3a34b09d3e34113e) and [generated pdf report](http://memoiry.me/files/Mashup_BreastCancer.pdf).

Through this Tutorial, we will use the following capabilities of ModMashup:

1. Perform feature selection on the training set
2. Assess performance on the test set

The algorithm proceeds in two steps:

1. Feature selection
2. Predicting classes of test samples

##### Set up environment

```julia

################################################################################
#Uncoment GeneMANIA parts to compare it with Mashup using #same queries
################################################################################

rm(list=ls())


# Change this to a local directory where you have write permission
outDir <- sprintf("%s/TCGA_BRCA",getwd())
cat(sprintf("All intermediate files are stored in:\n%s\n",outDir))

numCores 	<- 2L  	# num cores available for parallel processing
GMmemory 	<- 4L  	# java memory in Gb
cutoff		<- 9L  	# score cutoff for feature-selected networks
TRAIN_PROP <- 0.67 	# fraction of samples to use for training

if (file.exists(outDir)) unlink(outDir,recursive=TRUE)
dir.create(outDir)
```

##### Load the netDx software and data packages. Finally, load the breast cancer dataset.

```julia
# import the required packages
require(netDx)
require(netDx.examples)
data(TCGA_BRCA)
```

##### Split the train and test

```julia
subtypes<- c("LumA")
pheno$STATUS[which(!pheno$STATUS %in% subtypes)] <- "other"
subtypes <- c(subtypes,"other") # add residual

pheno$TT_STATUS <- splitTestTrain(pheno,
                                  pctT = TRAIN_PROP,setSeed = 42)
```

##### Create similairty network

```julia
pheno_FULL	<- pheno
xpr_FULL 	<- xpr
pheno		<- subset(pheno,TT_STATUS %in% "TRAIN")
xpr			<- xpr[,which(colnames(xpr)%in% pheno$ID)]

## Pathway
pathFile <- sprintf("%s/extdata/Human_160124_AllPathways.gmt", 
                    path.package("netDx.examples"))
pathwayList <- readPathways(pathFile)
head(pathwayList)
```

##### Gene data networks

From gene expression data, we create one network per cellular pathway. Similarity between two patients is defined as the Pearson correlation of the expression vector; each network is limited to genes for the corresponding pathway. 

```julia
profDir <- sprintf("%s/profiles",outDir)
netDir <- sprintf("%s/networks",outDir)


netList <- makePSN_NamedMatrix(xpr, rownames(xpr), 
                               pathwayList,profDir,verbose=FALSE,
                               numCores=numCores,writeProfiles=FALSE)

netList <- unlist(netList)
head(netList)

##################################################################
## Create GM database and also interaction 'txt' file
#dbDir	<- GM_createDB(profDir, pheno$ID, outDir,numCores=numCores)
##################################################################
```

##### Feature selection for each class

The goal of this step is to extract the networks that are most predictive of a given class. For each subtype, here "LumA" and "other", feature selection is performed once.

- `mashup_runCV_featureSet()`, which runs the cross-validation with successive ModMashup queries and returns top ranked network.


**Remember to set mashup_runCV_featureSet's keyword `write_query` to FALSE if you want to uncomment GeneMANIA's code so that mashup will use query files generated by GeneMANIA for comparing the result.**

```julia
top_net_file <- list()
mashup_tally <- list()
for (g in subtypes) {
  pDir <- sprintf("%s/%s",outDir,g)
  if (file.exists(pDir)) unlink(pDir,recursive=TRUE)
  dir.create(pDir)
  
  cat(sprintf("\n******\nSubtype %s\n",g))
  pheno_subtype <- pheno
  
  ## label patients not in the current class as a residual
  pheno_subtype$STATUS[which(!pheno_subtype$STATUS %in% g)] <- "nonpred"
  ## sanity check
  print(table(pheno_subtype$STATUS,useNA="always"))
  
  GM_resDir    <- sprintf("%s/GM_results",pDir)
  Mashup_resDir <- sprintf("%s/Mashup_results",pDir)
  ## query for feature selection comprises of training 
  ## samples from the class of interest
  trainPred <- pheno$ID[which(pheno$STATUS %in% g)]
  
  
  ######$$Here we call GeneMANIA feature network selection################
  # Cross validation for genemania
  #GM_runCV_featureSet(trainPred, GM_resDir, dbDir$dbDir, 
  #                  nrow(pheno_subtype),verbose=T, numCores=numCores,
  #                    GMmemory=GMmemory)
  #
  # patient similarity ranks
  #prank <- dir(path=GM_resDir,pattern="PRANK$")
  ## network ranks
  #nrank <- dir(path=GM_resDir,pattern="NRANK$")
  #cat(sprintf("Got %i prank files\n",length(prank)))

  # Compute network score
  #pTally	<- GM_networkTally(paste(GM_resDir,nrank,sep="/"))
  #head(pTally)
  # write to file
  #tallyFile	<- sprintf("%s/%s_pathway_CV_score_genemania.txt",GM_resDir,g)
  #write.table(pTally,file=tallyFile,sep="\t",col=T,row=F,quote=F)
  #####################################################################
  
  # Cross validation for mashup
  # remember to set keyword write_query = FALSE if you want to uncomment GeneMANIA algorithm,
  # which indicates mashup will use query file from genemania instead of 
  # generating query files by itself, so the query files are shared between genemania and 
  # mashup for further comparation.
  mashup_res <- mashup_runCV_featureSet(profDir, GM_resDir, pheno_subtype, trainID_pred = trainPred,
                                        write_query = TRUE, smooth = TRUE, verbose=T, 
                                        numCores = numCores, cut_off = cutoff)
  # List of selected top networks name
  mashup_tally[[g]] <- mashup_res$tally
  # Selected top networks txt file name
  top_net_file[[g]] <- mashup_res$top_net
  cat(sprintf("Mashup-%s: %i networks\n",g,length(mashup_tally[[g]])))
}
```

##### Rank test patients using trained model

- `runMashup()`, which runs ModMashup patients ranking and return the name of NRANK file.

```julia
pheno <- pheno_FULL
predRes_GM <- list()
predRes_mashup <- list()
for (g in subtypes) {
  pDir <- sprintf("%s/%s",outDir,g)
  #####################################################################
  # get GeneMANIA's feature selected net names
  #pTally <- read.delim(
  #sprintf("%s/GM_results/%s_pathway_CV_score_genemania.txt",pDir,g),
  #sep="\t",h=T,as.is=T)
  #pTally <- pTally[which(pTally[,2]>=cutoff),1]
  #pTally <- sub(".profile","",pTally)
  #pTally <- sub("_cont","",pTally)
#  
  #cat(sprintf("%s: %i pathways\n",g,length(pTally)))
  #profDir_GM <- sprintf("%s/profiles_GM",pDir)
  #####################################################################
  profDir_mashup <- sprintf("%s/profiles_mashup",pDir)
  if(!file.exists(profDir_mashup)) 
    dir.create(profDir_mashup)
  
  # prepare nets for net mashup db
  tmp <- makePSN_NamedMatrix(xpr_FULL,rownames(xpr),
                             pathwayList[which(names(pathwayList)%in% mashup_tally[[g]])],
                             profDir_mashup,verbose=F,numCores=numCores)
  #####################################################################
  # prepare nets for new genemania db
  #tmp <- makePSN_NamedMatrix(xpr_FULL,rownames(xpr),
  #                           pathwayList[which(names(pathwayList)%in% pTally)],
  #                           profDir_GM,verbose=F,numCores=numCores)
  #
  # create db
  #dbDir <- GM_createDB(profDir_GM,pheno$ID,pDir,numCores=numCores)
  #####################################################################
  
  # Delete existed result file in case conflicts.
  redundant_result_file <- list.files(path = sprintf("%s", pDir), pattern = "query")
  unlink(paste0(pDir, "/",redundant_result_file))
  
  # query of all training samples for this class
  qSamps <- pheno$ID[which(pheno$STATUS %in% g & pheno$TT_STATUS%in%"TRAIN")]
  qFile <- sprintf("%s/%s_query",pDir,g)
  GM_writeQueryFile(qSamps,"all",nrow(pheno),qFile)
  
  # Running patient ranking for mashup
  mashup_resFile <- runMashup(profDir_mashup, qFile, pheno, top_net = top_net_file[[g]], ranking = TRUE, 
                              smooth = TRUE)
  # Save the reresult.
  predRes_mashup[[g]] <- GM_getQueryROC(mashup_resFile, pheno, g, plotIt=TRUE)

  #####################################################################
  ## Running patient ranking for genemania
  #Genemania_resFile <- runGeneMANIA(dbDir$dbDir,qFile,resDir=pDir)
  # Analysis the ROC
  #predRes_GM[[g]] <- GM_getQueryROC(sprintf("%s.PRANK",Genemania_resFile),pheno, g, plotIt=TRUE)
  #####################################################################
}
```

##### Assign labels to test patients

Here we use `GM_OneVAll_getClass()` to label patients by max rank and finally evaluate the performance of the classifier.

```julia
## Stats for Mashup result
predClass_mashup <- GM_OneVAll_getClass(predRes_mashup)
cat("Start Print result of mashup..")
both <- merge(x=pheno,y=predClass_mashup,by="ID")
print(table(both[,c("STATUS","PRED_CLASS")]))
pos <- (both$STATUS %in% "LumA")
tp <- sum(both$PRED_CLASS[pos]=="LumA")
fp <- sum(both$PRED_CLASS[!pos]=="LumA")
tn <- sum(both$PRED_CLASS[!pos]=="other")
fn <- sum(both$PRED_CLASS[pos]=="other")
cat(sprintf("Accuracy = %i of %i (%i %%)\n",tp+tn,nrow(both),
            round(((tp+tn)/nrow(both))*100)))
cat(sprintf("PPV = %i %%\n", round((tp/(tp+fp))*100)))
cat(sprintf("Recall = %i %%\n", round((tp/(tp+fn))*100)))

######################################################################
## Stats for GeneMANIA result
#predClass_GM <- GM_OneVAll_getClass(predRes_GM)
#cat("Start Print result of genemania")
#both <- merge(x=pheno,y=predClass_GM,by="ID")
#print(table(both[,c("STATUS","PRED_CLASS")]))
#pos <- (both$STATUS %in% "LumA")
#tp <- sum(both$PRED_CLASS[pos]=="LumA")
#fp <- sum(both$PRED_CLASS[!pos]=="LumA")
#tn <- sum(both$PRED_CLASS[!pos]=="other")
#fn <- sum(both$PRED_CLASS[pos]=="other")
#cat(sprintf("Accuracy = %i of %i (%i %%)\n",tp+tn,nrow(both),
#            round(((tp+tn)/nrow(both))*100)))
#cat(sprintf("PPV = %i %%\n", round((tp/(tp+fp))*100)))
#cat(sprintf("Recall = %i %%\n", round((tp/(tp+fn))*100)))
#####################################################################
```

#### Credits

[netDX BreastCancer example](http://netdx.org/wp-content/uploads/2016/06/BreastCancer.pdf)








