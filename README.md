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
mv=8
model_configuration (data_train,data_valid,data_test,mv)
```

This process will produce predicted values for both the validation and test datasets, corresponding to each model configuration trained on the training dataset. The outcome of this function will yield variables named predict_validation_models and predict_test_models. 
| phenotype | model_1   | model_2   | ... | Model_N   | 
|-----------|-----------|-----------|-----|-----------|
|    ...    |    ...    |    ...    | ... |    ...    |

## Identify Best Model
To identify best model
```
dat <- read.table("models_test_all")
mv=8
tn=15 #the number of best model to be chosen
prev=0.047 #prevalance of the disease
model_evaluation(dat,mv,tn,prev)
```
This process will generate three distinct output files in the working directory.

# References
1. Olkin, I. and  Finn, J.D. Correlations redux. Psychological Bulletin, 1995. 118(1): p. 155.
2. DeLong, E.R., D.M. DeLong, and D.L. Clarke-Pearson, Comparing the areas under two or more correlated receiver operating characteristic curves: a nonparametric approach. Biometrics, 1988: p. 837-845.
3. Guyon, I., Weston, J., Barnhill, S. & Vapnik, V. Gene selection for cancer classification using support vector machines. Machine learning 46, 389-422 (2002).
4. Momin, M.M., Wray, N.R. and Lee S.H. 2023. R2ROC: An efficient method of comparing two or more correlated AUC from out-of-sample prediction using polygenic scores. BioRxiv. https://www.biorxiv.org/content/10.1101/2023.08.01.551571v1
   
# Contact information
Please contact Hong Lee (hong.lee@unisa.edu.au) or Md Moksedul Momin (cvasu.momin@gmail.com) if you have any queries.
