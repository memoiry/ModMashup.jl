GOAL: Use patient similarity networks generated using patient data in order to
predict patient survival status. In this case, use patient's age, tumor grade
and tumor stage to generate similarity networks in order to predict patients
survival status.

Predictor run using KIRC (kidney cancer) patient clinical data where the input
is three networks, each representing a clinical data variable (tumor grade, age
and tumor stage).

FILES:
1) GENES.txt
  -Provides the IDs for nodes (in this case genes are patient_IDs)

2) NETWORKS.txt
  -Provides the names of the input networks along with a numeric identifier
  (1,2 or 3 in this case), which is later used to refer to reach networks as
  1.1, 1.2 or 1.3

3) INTERACTIONS (folder)
  -Contains the interactions for each network with the naming convention
  mentioned above (training samples only).
      i.e) 1.1 is the network generated using the "age" variable
  -Each of these networks was generated using the specified clinical variable.
    This means the edge weights are based solely on that clinical variable,
    which is why we have three networks (one for each clinical variable).

4) KIRC_clinNets_pheno_matrix.csv
  -This file contains the phenotype matrix with survival information for each
  patients (both train and test samples). The file has the following columns:
    pkey: unique integer identifier for each patient
    ID: unique string identifier for each patient
    age: patient age
    grade: grade of patient's tumor
    stage: stage of patient's tumor
    STATUS_INT: binary survival for each patients (1=SURVIVEYES, 0=SURVIVENO)
    STATUS: string survival status for each patient

5) predictionResults.txt
  -This file provides the prediction results from the learner on the test
  samples.
  -Contains the same columns as the phenotype matrix, but in additions:
  SURVIVEYES_SCORE: score given to SURVIVEYES class
  SURVIVENO_SCORE:	score given to SURVIVENO class
  PRED_CLASS: survival prediction made by the learner for this patient (which
  survival class had the higher score)

6) example_queries (folder)
  - Files for a sample query run for SURVIVEYES survival status.  
