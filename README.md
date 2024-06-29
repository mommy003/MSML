---
Title: "MSML"
Authors: "Md Moksedul Momin and S. Hong Lee"
Last updated: "15-12-2023"
---

# MSML
The MSML package is designed to determine the optimal model(s) by leveraging all available features (e.g. polygenic risk score (PRSs)). To use this package, three sets of data—training, validation, and test datasets—are required, each with an equal number of columns (refer to the inputs instruction below). The package initially generates all possible model configurations. Subsequently, in the evaluation process, we implemented a modified version of the recursive feature elimination (RFE) algorithm. This involves testing all model configurations to obtain optimal weights for each feature using the training dataset. The obtained optimal weights are then applied to the validation dataset to identify the best model configurations. Finally, the test dataset is used to validate the optimal model configurations.

# INSTALLATION
To use MSML:
##### To install the package from GitHub
```
install.packages("devtools")
library(devtools)
devtools::install_github("mommy003/MSML")
library(MSML) 
```
OR
##### To install the package from CRAN
```
install.packages("MSML")
library(MSML)
```

# DATA PREPARATION
Users need to supply two sets of data—specifically, training and validation datasets—with an equal number of columns (but varying numbers of rows depending on sample sizes in those datasets). Examples for clarification are provided below:
### Training Dataset
|     V1    |     V2    |     V3    | ... |     Vn    |    phenotype    |
|-----------|-----------|-----------|-----|-----------|-----------------|
|    ...    |    ...    |    ...    | ... |    ...    |       ...       |

### Validation Dataset
|     V1    |     V2    |     V3    | ... |     Vn    |    phenotype    |
|-----------|-----------|-----------|-----|-----------|-----------------|
|    ...    |    ...    |    ...    | ... |    ...    |       ...       |

Where V1 to Vn represent the features (e.g. PRSs) incorporated in the datasets. The number of columns remains consistent across the datasets, while the number of rows adjusts to accommodate the varying sample sizes in each dataset

# DATA ANALYSIS
## Model configurations 
To get all the possible model configurations  
```
data_train <- data_train #(user should store their own training dataset here)
data_valid  <- data_valid #(user should store their own validation dataset here)
mv=8 #(number of columns in training/validation/test dataset)
out=model_configuration(data_train,data_valid,mv,model="lm")
```
$\color{black}{Note:}$ The syntax model="lm" (default) or "glm" can optionally use a linear model or a logistic regression, respectively. 

This process will produce predicted values for the validation datasets, corresponding to each model configuration trained on the training dataset. The outcome of this function will yield variables named ‘predict_validation’ and ‘total_model_configurations’. 
#### out$predict_validation  
| phenotype | model_1   | model_2   | ... | Model_N   | 
|-----------|-----------|-----------|-----|-----------|
|    ...    |    ...    |    ...    | ... |    ...    |


#### out$total_model_configurations
```
X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 X11 X12 X13 X14 X15 X16 X17 X18 X19 ……
1  2  3  4  5  6  7  1  1   1   1   1   1   2   2   2   2   2   ……
0  0  0  0  0  0  0  2  3   4   5   6   7   3   4   5   6   7   ……
0  0  0  0  0  0  0  0  0   0   0   0   0   0   0   0   0   0   ……
0  0  0  0  0  0  0  0  0   0   0   0   0   0   0   0   0   0   ……
0  0  0  0  0  0  0  0  0   0   0   0   0   0   0   0   0   0   ……
0  0  0  0  0  0  0  0  0   0   0   0   0   0   0   0   0   0   ……
0  0  0  0  0  0  0  0  0   0   0   0   0   0   0   0   0   0   ……
```
which shows which model fits which features. For instance, in the 15th model, the 2nd and 4th features are fitted in the training and validation datasets. To extract features fitted in a specific model (e.g., 15th model):  

```
out$total_model_configurations$X15
```

which will give the following output:
```
[1] 2 4 0 0 0 0 0
```

#### If users intend to utilize constant covariates, we suggest utilizing the "model_configuration2" function. 
To get all the possible model configurations  
```
data_train <- data_train
data_valid  <- data_valid
mv=8
cov_train <- cov_train
cov_valid  <- cov_valid
out=model_configuration2(data_train,data_valid,mv,cov_train, cov_valid, model = "lm")
```
$\color{black}{Note:}$ Similar to the model_configuration function above, this process will generate predicted values for the validation datasets, corresponding to each model configuration trained on the training dataset. The output of this function will result in variables named 'predict_validation' and 'total_model_configurations'.

## Identifying Best Model
Please note that users are required to load the R2ROC or r2redux  library to identify the best models. R2ROC or r2redux can be installed from CRAN or GitHub (https://github.com/mommy003/R2ROC and https://github.com/mommy003/r2redux). To identify best model
```
install.packages("R2ROC")
install.packages("r2redux")
library(R2ROC)
library(r2redux)
dat <- out$predict_validation
mv=8 
tn=15 # top 15 best models will be considered for the next step (evaluation), but it is recommended to use 127.
prev=0.047 #population prevalence of the disease

out=model_evaluation(dat,mv,tn,prev)
```
$\color{black}{Note:}$  tn can be any number between 1 and the total number of model configurations. It is recommended to set tn equal to the total number of model configurations to search the entire space. When reducing tn, it can speed up the process but may miss some areas of the search space. This process will generate three distinct output files in the working directory named evaluation1.out, evaluation2.out and evaluation3.out.

$\color{black}{Note:}$ pthreshold=0.05 and method="R2ROC" are defaults for optional arguments. When the user wants to change the significance level or method when comparing models, additional arguments can be added, e.g. model_evaluation(dat,mv,tn,prev,pthreshold=0.5,method="r2redux"), where pthreshold=0.5 results in a more conservative selection of best models (i.e., fewer models to be selected), and r2redux is based on the R2 metric rather than AUC.  It's important to note that using method="r2redux" will not utilize population prevalence information.

-	out$out_all is the output file which contains AUC, R2, and P-values for all models.
```
row# model#  AUC   p-value      R^2          p-value
[1,] "1 0.5324357 0.2229025 0.000592623 0.223694 "
[2,] "2 0.545646 0.08576013 0.001174532 0.0866723 "
[3,] "3 0.5222886 0.4027182 0.0002797196 0.4032217 "
[4,] "4 0.5279203 0.2943169 0.0004390236 0.294991 "
[5,] "5 0.5595865 0.02454698 0.002003651 0.02521387 "
[6,] "6 0.5937453 0.0003581904 0.004978719 0.0004145577 "
[7,] "7 0.5720028 0.006440316 0.002929198 0.006794875 "
[8,] "8 0.5510913 0.05424664 0.001472042 0.05509745 "
[9,] "9 0.5331448 0.2129157 0.000618838 0.213723 "
[10,] "10 0.5406711 0.1260559 0.0009321708 0.1269686 "

.....
.....
```
-	out$out_start is the output file which contains AUC, R2 and P-values for the top ‘tn’ models according to the AUC or R^2 (see definition of ‘tn’ above).
```
row# model#  AUC   p-value      R^2          p-value
[1,] "51 0.6127805 1.536486e-05 0.00722743 2.078418e-05 "
[2,] "71 0.6134653 1.356228e-05 0.007316329 1.848149e-05 "
[3,] "83 0.6118782 1.80883e-05 0.007111139 2.423688e-05 "
[4,] "90 0.6123521 1.660565e-05 0.007172091 2.236086e-05 "
[5,] "93 0.6166943 7.445744e-06 0.007743088 1.052536e-05 "
[6,] "105 0.6133035 1.396901e-05 0.007295281 1.900241e-05 "
[7,] "108 0.6180561 5.749691e-06 0.007926819 8.262617e-06 "
[8,] "113 0.6128037 1.530023e-05 0.007230433 2.070188e-05 "
[9,] "117 0.6144772 1.126111e-05 0.007448734 1.551767e-05 "
[10,] "118 0.6174846 6.41108e-06 0.007849448 9.149019e-06 "
[11,] "123 0.6156061 9.132044e-06 0.007597883 1.274599e-05 "
[12,] "124 0.6187217 5.06109e-06 0.008017432 7.333389e-06 "
[13,] "125 0.6103531 2.375613e-05 0.006916789 3.134108e-05 "
[14,] "126 0.6152355 9.784879e-06 0.00754875 1.359931e-05 "
[15,] "127 0.61625 8.095044e-06 0.007683629 1.138343e-05 "

```
-	out$out_selected is the output file which contains R2 and P-values for the best models, which are not significantly different from the top-performing model.

$\color{black}{Note:}$  If a user aims to identify the best model, they can make a selection based on the highest AUC estimates, such as choosing model 124, or opt for Parsimony models, for instance, selecting model 51.
```
row# model#  AUC   p-value      R^2          p-value
[1,] "51 0.6127805 1.536486e-05 0.00722743 2.078418e-05    2 5 6 "
[2,] "71 0.6134653 1.356228e-05 0.007316329 1.848149e-05    1 2 5 6 "
[3,] "83 0.6118782 1.80883e-05 0.007111139 2.423688e-05    1 5 6 7 "
[4,] "90 0.6123521 1.660565e-05 0.007172091 2.236086e-05    2 4 5 6 "
[5,] "93 0.6166943 7.445744e-06 0.007743088 1.052536e-05    2 5 6 7 "
[6,] "105 0.6133035 1.396901e-05 0.007295281 1.900241e-05    1 2 4 5 6 "
[7,] "108 0.6180561 5.749691e-06 0.007926819 8.262617e-06    1 2 5 6 7 "
[8,] "113 0.6128037 1.530023e-05 0.007230433 2.070188e-05    1 4 5 6 7 "
[9,] "117 0.6144772 1.126111e-05 0.007448734 1.551767e-05    2 3 5 6 7 "
[10,] "118 0.6174846 6.41108e-06 0.007849448 9.149019e-06    2 4 5 6 7 "
[11,] "123 0.6156061 9.132044e-06 0.007597883 1.274599e-05    1 2 3 5 6 7 "
[12,] "124 0.6187217 5.06109e-06 0.008017432 7.333389e-06    1 2 4 5 6 7 "
[13,] "125 0.6103531 2.375613e-05 0.006916789 3.134108e-05    1 3 4 5 6 7 "
[14,] "126 0.6152355 9.784879e-06 0.00754875 1.359931e-05    2 3 4 5 6 7 "
[15,] "127 0.61625 8.095044e-06 0.007683629 1.138343e-05    1 2 3 4 5 6 7 "
```

### Validation of this procedure using an independent test dataset
Repeat the same procedure with an independent test dataset (e.g. data_test in this example)
```
data_train <- data_train #(user should store the same training dataset here)
data_valid  <- data_test #(user should store the independent test dataset here)
mv=8 #(number of columns in training/validation/test dataset)
out=model_configuration(data_train,data_valid,mv)

dat <- out$predict_validation
prev=0.047 
tn=15
out2=model_evaluation(dat,mv,tn,prev,pthreshold=0.05)
```
Then, the output files with the independent test dataset can be compared with the previous results.  

# References
1. Olkin, I. and  Finn, J.D. Correlations redux. Psychological Bulletin, 1995. 118(1): p. 155.
2. DeLong, E.R., D.M. DeLong, and D.L. Clarke-Pearson, Comparing the areas under two or more correlated receiver operating characteristic curves: a nonparametric approach. Biometrics, 1988: p. 837-845.
3. Guyon, I., Weston, J., Barnhill, S. & Vapnik, V. Gene selection for cancer classification using support vector machines. Machine learning 46, 389-422 (2002).
4. Momin M.M., Lee S., Wray N.R., Lee S.H. 2023. Significance tests for R2 of out-of-sample prediction using polygenic scores. The American Journal of Human Genetics.  110: p. 349-358. https://doi.org/10.1016/j.ajhg.2023.01.004
5. Momin, M.M., Wray, N.R. and Lee S.H. 2023. R2ROC: An efficient method of comparing two or more correlated AUC from out-of-sample prediction using polygenic scores.  Human Genetics. 2024 Jun 20. doi: 10.1007/s00439-024-02682-1. PMID: 38902498
   
# Contact information
Please contact Md Moksedul Momin (cvasu.momin@gmail.com) or Hong Lee (hong.lee@unisa.edu.au) if you have any queries.
