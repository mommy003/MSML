# MSML
The MSML package can indentify best performing model using all the available features. This package requires ree sets of data (e.g. training, validation and test dataset) having equal no of columns. In the evaluation process, we employed a modified version of recursive feature elimination (RFE) algorithm to identify best model, a widely adopted feature selection technique in the context of machine learning and data analysis. 

# INSTALLATION
To use MSML:
```
install.packages("devtools")
library(devtools)
devtools::install_github("mommy003/MSML")
library(MSML)
```
# DATA PREPARATION
User needs to provide three sets of data (e.g. training, validation and test dataset) having equal no of columns.
- PGS1  
- PGS2 
- PGS3  
- PGS4  
- PGS5  
- PGS6  
- PGS7  
- target phenotype (target)

# References
1. Olkin, I. and  Finn, J.D. Correlations redux. Psychological Bulletin, 1995. 118(1): p. 155.
2. DeLong, E.R., D.M. DeLong, and D.L. Clarke-Pearson, Comparing the areas under two or more correlated receiver operating characteristic curves: a nonparametric approach. Biometrics, 1988: p. 837-845.
3. Guyon, I., Weston, J., Barnhill, S. & Vapnik, V. Gene selection for cancer classification using support vector machines. Machine learning 46, 389-422 (2002).
4. Momin, M.M., Wray, N.R. and Lee S.H. 2023. R2ROC: An efficient method of comparing two or more correlated AUC from out-of-sample prediction using polygenic scores. BioRxiv. https://www.biorxiv.org/content/10.1101/2023.08.01.551571v1
5. 
# Contact information
Please contact Hong Lee (hong.lee@unisa.edu.au) or Md Moksedul Momin (cvasu.momin@gmail.com) if you have any queries.
