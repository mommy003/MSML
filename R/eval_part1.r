#' model_configuration function
#'
#' This function generates predicted values for the validation dataset by applying 
#' optimal weights to features, which were estimated in the training dataset for each 
#' model configuration. The total number of model configurations is determined by 
#' summing the combinations for each possible number of features, 
#' ranging from 1 to 'n' (C(n, k)), where 'n choose k' (C(n, k)) represents the binomial 
#' coefficient. Here, 'n' denotes the total number of features, and 'k' indicates 
#' the number of features included in each model. For example, with n=7, 
#' the total number of model configurations is 127.
#' @param data_train This includes the dataframe of the training dataset in a matrix format
#' @param data_valid This includes the dataframe of the validation dataset in a matrix format
#' @param mv The total number of columns in data_train/data_valid
#' @param model This is the type of model (e.g. lm (default) or glm)
#' @keywords All possible model combinations
#' @export
#' @importFrom stats D lm pf
#' @import utils
#' @return This function will generate all possible model outcomes for validation and test dataset
#' @examples \donttest{
#' data_train <- data_train
#' data_valid  <- data_valid
#' mv=8
#' out=model_configuration(data_train,data_valid,mv,model = "lm")
#' #This process will produce predicted values for the validation datasets,
#' #corresponding to each model configuration trained on the training dataset.
#' #The outcome of this function will yield variables named 'predict_validation'
#' #and 'total_model_configurations.
#' #To print the outcomes run out$predict_validation and out$total_model_configurations.
#' #For details (see https://github.com/mommy003/MSML). 
#' }


model_configuration = function (data_train,data_valid, mv, model = "lm") {

cat("\n")
#cat("prediction models **************************\n")
df1=cbind(data_valid$phenotype);k=0
for (i in 1:(mv-1)) {  
  com=combn(seq(1,(mv-1)),i)
  #print(com)
  for (j in 1:ncol(com)) {
    k=k+1
    #cat("model",k,":",com[,j],"\n")
    #mod=lm(as.numeric(data_train$phenotype) ~ as.matrix(data_train[,com[,j]]))

    if (model == "lm") {
        mod=lm(as.numeric(data_train$phenotype) ~ as.matrix(data_train[,com[,j]]))
      } else if (model == "glm") {
        mod <- glm(as.numeric(data_train$phenotype) ~ as.matrix(data_train[,com[,j]]), family = binomial(link="logit"))
      } else {
        stop("Invalid model type. Use 'lm' or 'glm'.")
      }

    pred=as.matrix(cbind(1,data_valid[,com[,j]]))%*%as.matrix(mod$coefficients)
    df1=cbind(df1,pred)
  }
}

df1=data.frame(df1)


cat("\n")

num_row=k
#cat("prediction models **************************\n")
df3=matrix(0,num_row,(mv-1));k=0
for (i in 1:(mv-1)) {
  com=combn(seq(1,(mv-1)),i)
  #print(com)
  for (j in 1:ncol(com)) {
    k=k+1
    #cat("model",k,":",com[,j],"\n")
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
