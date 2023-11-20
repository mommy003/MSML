# MSML
The MSML package has the capability to identify the best-performing model using all available features. To utilize this package, three sets of data—training, validation, and test datasets—are required, each having an equal number of columns. During the evaluation process, we applied a modified version of the recursive feature elimination (RFE) algorithm. RFE is a widely adopted feature selection technique in the context of machine learning and data analysis.

# INSTALLATION
To use MSML:
```
install.packages("devtools")
library(devtools)
devtools::install_github("mommy003/MSML")
library(MSML)
```
# DATA PREPARATION
Users are required to provide three sets of data—namely, training, validation, and test datasets—with an equal number of columns. Below are examples for clarification
- Training Dataset
| Feature_1 | Feature_2 | Feature_3 | ... | Feature_N | Target_Variable |
|-----------|-----------|-----------|-----|-----------|-----------------|
|    ...    |    ...    |    ...    | ... |    ...    |       ...       |

- Validation Dataset
| Feature_1 | Feature_2 | Feature_3 | ... | Feature_N | Target_Variable |
|-----------|-----------|-----------|-----|-----------|-----------------|
|    ...    |    ...    |    ...    | ... |    ...    |       ...       |

- Test Dataset
| Feature_1 | Feature_2 | Feature_3 | ... | Feature_N | Target_Variable |
|-----------|-----------|-----------|-----|-----------|-----------------|
|    ...    |    ...    |    ...    | ... |    ...    |       ...       |


# DATA ANALYSIS
## Model Combination
To get all the model combinations 
```
data_train <- data_train
data_valid  <- data_valid
data_test  <- data_test
mv=8
model_combination(data_train,data_valid,data_test,mv)
```
This will generate Polygenic Risk Scores (PRS) based on all possible model combinations for both the validation and test datasets, resulting in variables named models_validation_all and models_test_all.

## Identify Besr Model
To identify best model
```
dat <- read.table("models_test_all")
mv=8
tn=15
prev=0.047
model_evaluation(dat,mv,tn,prev)
```
This process will produce three distinct output files in the working directory.

# References
1. Olkin, I. and  Finn, J.D. Correlations redux. Psychological Bulletin, 1995. 118(1): p. 155.
2. DeLong, E.R., D.M. DeLong, and D.L. Clarke-Pearson, Comparing the areas under two or more correlated receiver operating characteristic curves: a nonparametric approach. Biometrics, 1988: p. 837-845.
3. Guyon, I., Weston, J., Barnhill, S. & Vapnik, V. Gene selection for cancer classification using support vector machines. Machine learning 46, 389-422 (2002).
4. Momin, M.M., Wray, N.R. and Lee S.H. 2023. R2ROC: An efficient method of comparing two or more correlated AUC from out-of-sample prediction using polygenic scores. BioRxiv. https://www.biorxiv.org/content/10.1101/2023.08.01.551571v1
5. 
# Contact information
Please contact Hong Lee (hong.lee@unisa.edu.au) or Md Moksedul Momin (cvasu.momin@gmail.com) if you have any queries.
