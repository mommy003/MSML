---
Title: "MSML"
Authors: "Md Moksedul Momin and S. Hong Lee"
Last updated: "23-11-2023"
---

# MSML
The MSML package is designed to determine the optimal model(s) by leveraging all available features. To use this package, three sets of data—training, validation, and test datasets—are required, each with an equal number of columns (refer to the inputs instruction below). The package initially generates all possible model configurations. Subsequently, in the evaluation process, we implemented a modified version of the recursive feature elimination (RFE) algorithm. This involves testing all model configurations to obtain optimal weights for each feature using the training dataset. The obtained optimal weights are then applied to the validation dataset to identify the best model configurations. Finally, the test dataset is used to validate the optimal model configurations.

# INSTALLATION
To use MSML:
```
install.packages("devtools")
library(devtools)
devtools::install_github("mommy003/MSML")
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
out=model_configuration(data_train,data_valid,mv)
```

This process will produce predicted values for both the validation and test datasets, corresponding to each model configuration trained on the training dataset. The outcome of this function will yield variables named ‘predict_validation’ and ‘total_model_configurations’. 
#### out$predict_validation  
| phenotype | model_1   | model_2   | ... | Model_N   | 
|-----------|-----------|-----------|-----|-----------|
|    ...    |    ...    |    ...    | ... |    ...    |


#### out$total_model_configurations
```
X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 X11 X12 X13 X14 X15 X16 X17 X18 ……
1  1  2  3  4  5  6  7  1  1   1   1   1   1   2   2   2   2   2   ……
2  0  0  0  0  0  0  0  2  3   4   5   6   7   3   4   5   6   7   ……
3  0  0  0  0  0  0  0  0  0   0   0   0   0   0   0   0   0   0   ……
4  0  0  0  0  0  0  0  0  0   0   0   0   0   0   0   0   0   0   ……
5  0  0  0  0  0  0  0  0  0   0   0   0   0   0   0   0   0   0   ……
6  0  0  0  0  0  0  0  0  0   0   0   0   0   0   0   0   0   0   ……
7  0  0  0  0  0  0  0  0  0   0   0   0   0   0   0   0   0   0   ……
```
which shows which model fits which features. For instance, in the 15th model, the 2nd and 4th features are fitted in the training and validation datasets. To extract features fitted in a specific model (e.g., 15th model):  

```
out$total_model_configurations$X15
```

which will give the following output:
```
[1] 2 4 0 0 0 0 0
```

## Identifying Best Model
Please note that users are required to load the R2ROC or r2redux  library to identify the best models. R2ROC or r2redux can be installed from CRAN or GitHub (https://github.com/mommy003/R2ROC and https://github.com/mommy003/r2redux). To identify best model
```
install.packages("R2ROC")
install.packages("r2redux")
library(R2ROC)
library(r2redux)
dat <- out$predict_validation
mv=8 
tn=15 # top 15 best models will be considered for the next step (evaluation) 
prev=0.047 #population prevalence of the disease

model_evaluation(dat,mv,tn,prev)
```
Note: tn can be any number between 1 and the total number of model configurations. It is recommended to set tn equal to the total number of model configurations to search the entire space. When reducing tn, it can speed up the process but may miss some areas of the search space. This process will generate three distinct output files in the working directory named evaluation1.out, evaluation2.out and evaluation3.out.

Note: pthreshold=0.05 and method="R2ROC" are defaults for optional arguments. When the user wants to change the significance level or method when comparing models, additional arguments can be added, e.g. model_evaluation(dat,mv,tn,prev,pthreshold=0.5,method="r2redux")
where pthreshold=0.5 results in a more conservative selection of best models (i.e., fewer models to be selected), and r2redux is based on the R2 metric rather than AUC.

-	evaluation1.out is the output file which contains AUC, R2, and P-values for all models.
```
model#    AUC    p-value      R^2          p-value
1 0.5548291 0.0001298861 0.001695803 0.0001373806
2 0.5652651 5.003691e-06 0.002405 5.586665e-06
3 0.5362302 0.01168655 0.0007395297 0.0118259
4 0.5309354 0.03142044 0.0005390315 0.03163222
5 0.5461618 0.001295179 0.001201266 0.001333459
6 0.5577214 5.560366e-05 0.001879878 5.953925e-05
7 0.5850072 2.294702e-09 0.004089039 3.137693e-09
8 0.5778185 4.782846e-08 0.003423704 5.960963e-08
9 0.5516611 0.0003139173 0.001505126 0.0003282536
10 0.5578709 5.31586e-05 0.001889652 5.696024e-05
.....
.....
```
-	evaluation2.out is the output file which contains AUC, R2 and P-values for the top ‘tn’ models according to the AUC or R^2 (see definition of ‘tn’ above).
```
top 15  best models **********************
model#    AUC    p-value      R^2          p-value
72 0.6155114 2.275321e-16 0.007585311 6.699796e-16
73 0.6180771 4.549389e-17 0.007929662 1.483071e-16
83 0.6143858 4.551259e-16 0.007436716 1.284474e-15
93 0.6182428 4.094289e-17 0.007952177 1.343846e-16
106 0.6165244 1.211071e-16 0.007720325 3.709076e-16
107 0.6188339 2.807267e-17 0.008032755 9.443425e-17
108 0.6235233 1.29969e-18 0.008686869 5.390295e-18
113 0.6160049 1.674847e-16 0.007650929 5.02636e-16
117 0.6144868 4.278172e-16 0.007449985 1.211942e-15
118 0.6192558 2.141596e-17 0.008090514 7.333407e-17
123 0.6186142 3.230712e-17 0.008002764 1.076855e-16
124 0.6241692 8.418176e-19 0.008779042 3.600962e-18
125 0.6139163 6.063309e-16 0.007375183 1.681849e-15
126 0.615619 2.128613e-16 0.007599588 6.293702e-16
127 0.6194564 1.882152e-17 0.008118063 6.500205e-17
```
-	evaluation3.out is the output file which contains R2 and P-values for the best models, which are not significantly different from the top-performing model.
```
selected models **********************
model#    AUC    p-value     R^2          p-value         Configurations
72 0.6155114 2.275321e-16 0.007585311 6.699796e-16    1 2 5 7
73 0.6180771 4.549389e-17 0.007929662 1.483071e-16    1 2 6 7
93 0.6182428 4.094289e-17 0.007952177 1.343846e-16    2 5 6 7
106 0.6165244 1.211071e-16 0.007720325 3.709076e-16    1 2 4 5 7
107 0.6188339 2.807267e-17 0.008032755 9.443425e-17    1 2 4 6 7
108 0.6235233 1.29969e-18 0.008686869 5.390295e-18    1 2 5 6 7
117 0.6144868 4.278172e-16 0.007449985 1.211942e-15    2 3 5 6 7
118 0.6192558 2.141596e-17 0.008090514 7.333407e-17    2 4 5 6 7
123 0.6186142 3.230712e-17 0.008002764 1.076855e-16    1 2 3 5 6 7
124 0.6241692 8.418176e-19 0.008779042 3.600962e-18    1 2 4 5 6 7
126 0.615619 2.128613e-16 0.007599588 6.293702e-16    2 3 4 5 6 7
127 0.6194564 1.882152e-17 0.008118063 6.500205e-17    1 2 3 4 5 6 7
```
For backup, make a copy of the result files, e.g.
```
cp evaluation1.out evaluation1.out_v
cp evaluation2.out evaluation2.out_v
cp evaluation3.out evaluation3.out_v
```

### Validation of this procedure using an independent test dataset
Repeat the same procedure with an independent test dataset (e.g. data_test in this example)
```
data_train <- data_train #(user should store the same training dataset here)
data_valid  <- data_test #(user should store the independent test dataset here)
mv=8 #(number of columns in training/validation/test dataset)
out=model_configuration(data_train,data_valid,mv)
dat <- out$predict_validation
model_evaluation(dat,mv,tn,prev,pthreshold=0.5)
```
Then, the output files with the independent test dataset can be compared with the previous results (evaluation1.out_v, evaluation2.out_v, and evaluation3.out_v).  

# References
1. Olkin, I. and  Finn, J.D. Correlations redux. Psychological Bulletin, 1995. 118(1): p. 155.
2. DeLong, E.R., D.M. DeLong, and D.L. Clarke-Pearson, Comparing the areas under two or more correlated receiver operating characteristic curves: a nonparametric approach. Biometrics, 1988: p. 837-845.
3. Guyon, I., Weston, J., Barnhill, S. & Vapnik, V. Gene selection for cancer classification using support vector machines. Machine learning 46, 389-422 (2002).
4. Momin, M.M., Wray, N.R. and Lee S.H. 2023. R2ROC: An efficient method of comparing two or more correlated AUC from out-of-sample prediction using polygenic scores. BioRxiv. https://www.biorxiv.org/content/10.1101/2023.08.01.551571v1
   
# Contact information
Please contact Md Moksedul Momin (cvasu.momin@gmail.com) or Hong Lee (hong.lee@unisa.edu.au) if you have any queries.
