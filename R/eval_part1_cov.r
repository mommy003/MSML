#' model_configuration2 function
#'
#' This function is similar to the model_configuration function, 
#' with the added capability to maintain constant variables across models 
#' during training and prediction (see cov_train and cov_valid in page 2). 
#' Additionally, users have the option to select between linear or logistic regression models.
#' @param data_train This includes the dataframe of the training dataset in a matrix format
#' @param data_valid This includes the dataframe of the validation dataset in a matrix format
#' @param mv The total number of columns in data_train/data_valid
#' @param cov_train This includes dataframe of covariates for training dataset in a matrix format
#' @param cov_valid This includes dataframe of covariates for validation dataset in a matrix format
#' @param model This is the type of model (e.g. lm (default) or glm (logistic regression))
#' @keywords All possible model combinations
#' @export
#' @importFrom stats D lm pf glm as.formula binomial
#' @import utils
#' @return This function will generate all possible model outcomes for validation and test dataset
#' @examples \donttest{
#' data_train <- data_train
#' data_valid  <- data_valid
#' mv=8
#' cov_train <- cov_train
#' cov_valid  <- cov_valid
#' out=model_configuration2(data_train,data_valid,mv,cov_train, cov_valid, model = "lm")
#' #This process will produce predicted values for the validation datasets,
#' #corresponding to each model configuration trained on the training dataset.
#' #The outcome of this function will yield variables named 'predict_validation'
#' #and 'total_model_configurations.
#' #To print the outcomes run out$predict_validation and out$total_model_configurations.
#' #For details (see https://github.com/mommy003/MSML). 
#' }
#' #If a user intends to employ logistic regression without constant covariates, 
#' #we advise preparing a covariate file where all values are set to 1.


model_configuration2 = function (data_train,data_valid, mv, cov_train, cov_valid, model = "lm") {
  cat("\n")
  df1=cbind(data_valid$phenotype);k=0
  for (i in 1:(mv-1)) {  
    com=combn(seq(1,(mv-1)),i)
    for (j in 1:ncol(com)) {
      k = k + 1
      if (model == "lm") {
        formula <- as.formula(paste("as.numeric(data_train$phenotype) ~ ", paste("data_train$",colnames(data_train)[com[, j]], collapse = "+",sep=""), "+", paste("cov_train$", colnames(cov_train), collapse = "+")))
        mod <- lm(formula, data = data_train)
      } else if (model == "glm") {
        formula <- as.formula(paste("as.numeric(data_train$phenotype) ~ ", paste("data_train$",colnames(data_train)[com[, j]], collapse = "+",sep=""), "+", paste("cov_train$", colnames(cov_train), collapse = "+")))
        mod <- glm(formula, data = data_train, family = binomial(link="logit"))
      } else {
        stop("Invalid model type. Use 'lm' or 'glm'.")
      }
      newdata <- cbind(1,data_valid[, colnames(data_valid)[com[, j]]], cov_valid)
      pred=as.matrix(newdata)%*%as.matrix(mod$coefficients)
      df1 <- cbind(df1, pred)    
    }
  }
  df1=data.frame(df1)
  cat("\n")
  num_row=k
  df3=matrix(0,num_row,(mv-1));k=0
  for (i in 1:(mv-1)) {
    com=combn(seq(1,(mv-1)),i)
    for (j in 1:ncol(com)) {
      k=k+1
      df3[k,1:length(com[,j])]=com[,j]
    }
  }
  df3=data.frame(t(df3))
  z = list(
    "predict_validation" = df1,
    "total_model_configurations" = df3
  )
  return(z)
}
