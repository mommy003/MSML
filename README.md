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
Users need to supply three sets of data—specifically, training, validation, and test datasets—with an equal number of columns (but varying numbers of rows). Examples for clarification are provided below:
### Training Dataset
|     V1    |     V2    |     V3    | ... |     Vn    |    phenotype    |
|-----------|-----------|-----------|-----|-----------|-----------------|
|    ...    |    ...    |    ...    | ... |    ...    |       ...       |

### Validation Dataset
|     V1    |     V2    |     V3    | ... |     Vn    |    phenotype    |
|-----------|-----------|-----------|-----|-----------|-----------------|
|    ...    |    ...    |    ...    | ... |    ...    |       ...       |

### Test Dataset
|     V1    |     V2    |     V3    | ... |     Vn    |    phenotype    |
|-----------|-----------|-----------|-----|-----------|-----------------|
|    ...    |    ...    |    ...    | ... |    ...    |       ...       |


# DATA ANALYSIS
## Model configurations 
To get all the possible model configurations  
```
data_train <- data_train
data_valid  <- data_valid
data_test  <- data_test
mv=8 #number of columns in training/validation/test dataset
model_configuration(data_train,data_valid,data_test,mv)
```

This process will produce predicted values for both the validation and test datasets, corresponding to each model configuration trained on the training dataset. The outcome of this function will yield variables named predict_validation_models and predict_test_models. 
| phenotype | model_1   | model_2   | ... | Model_N   | 
|-----------|-----------|-----------|-----|-----------|
|    ...    |    ...    |    ...    | ... |    ...    |

## Identify Best Model
Please note that users are required to load the R2ROC library to identify best models. R2ROC can be installed from CRAN or GitHub (https://github.com/mommy003/R2ROC).
To identify best model
```
library(R2ROC)
dat <- models_test
mv=8 
tn=15 #the number of best model to be chosen
prev=0.047 #prevalance of the disease
model_evaluation(dat,mv,tn,prev)
```
This process will generate three distinct output files in the working directory named evaluation1.out, evaluation2.out and evaluation3.out.
-	evaluation1. out is the output file which contains R2 and P-values for all models.
```
model#    R^2          p-value
1 0.001011416 0.005101934
2 0.002261588 2.801031e-05
3 0.002112157 5.162217e-05
4 0.001127184 0.003111058
5 0.001302455 0.001481681
6 0.002058831 6.423818e-05
7 0.006715322 4.95513e-13
8 0.002635836 6.101739e-06
9 0.002677091 5.160931e-06

```
-	evaluation2. out is the output file which contains R2 and P-values for teen models.
```
top 15  best models **********************
model#    R^2          p-value
104 0.01095557 2.46233e-20
108 0.01094464 2.571386e-20
112 0.01090806 2.97247e-20
115 0.01095044 2.512925e-20
116 0.011124 1.263165e-20
117 0.01139046 4.393853e-21
118 0.01105642 1.651135e-20
119 0.01091779 2.860054e-20
121 0.01121284 8.882822e-21
122 0.01140319 4.17769e-21
123 0.0116742 1.427173e-21
124 0.01145476 3.405484e-21
125 0.01139483 4.318406e-21
126 0.01181463 8.180162e-22
127 0.01207579 2.905659e-22
```
-	evaluation3. out is the output file which contains R2 and P-values for the best models, which are not significantly different from the top-performing model.
```
selected models **********************
model#    R^2          p-value         Configurations
104 0.01095557 2.46233e-20    1 2 3 6 7
108 0.01094464 2.571386e-20    1 2 5 6 7
115 0.01095044 2.512925e-20    2 3 4 5 7
116 0.011124 1.263165e-20    2 3 4 6 7
117 0.01139046 4.393853e-21    2 3 5 6 7
118 0.01105642 1.651135e-20    2 4 5 6 7
121 0.01121284 8.882822e-21    1 2 3 4 5 7
122 0.01140319 4.17769e-21    1 2 3 4 6 7
123 0.0116742 1.427173e-21    1 2 3 5 6 7
124 0.01145476 3.405484e-21    1 2 4 5 6 7
126 0.01181463 8.180162e-22    2 3 4 5 6 7
127 0.01207579 2.905659e-22    1 2 3 4 5 6 7
```

# References
1. Olkin, I. and  Finn, J.D. Correlations redux. Psychological Bulletin, 1995. 118(1): p. 155.
2. DeLong, E.R., D.M. DeLong, and D.L. Clarke-Pearson, Comparing the areas under two or more correlated receiver operating characteristic curves: a nonparametric approach. Biometrics, 1988: p. 837-845.
3. Guyon, I., Weston, J., Barnhill, S. & Vapnik, V. Gene selection for cancer classification using support vector machines. Machine learning 46, 389-422 (2002).
4. Momin, M.M., Wray, N.R. and Lee S.H. 2023. R2ROC: An efficient method of comparing two or more correlated AUC from out-of-sample prediction using polygenic scores. BioRxiv. https://www.biorxiv.org/content/10.1101/2023.08.01.551571v1
   
# Contact information
Please contact Md Moksedul Momin (cvasu.momin@gmail.com) or Hong Lee (hong.lee@unisa.edu.au) if you have any queries.
