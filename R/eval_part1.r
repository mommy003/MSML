#' model_combination function
#' This function will generate PRS based on all possible combianations of model. 
#' The total number of models required to explore the combinations of these 'n' 
#' features can be calculated by summing the combinations for each possible 
#' number of features, ranging from 1 to 'n' (?[C(n,i)]).
#' where C(n,k)  represents the binomial coefficient or "n choose k," 
#' with n denoting the total number of features and k indicating 
#' the number of features to include in each model.
#' @param data_train This is the matrix for training dataset
#' @param data_valid This is the matrix for validation dataset
#' @param data_test This is the matrix for test dataset
#' @param mv The total number of columns in data_train/data_valid/data_test
#' @keywords All possible model combinations
#' @export
#' @importFrom stats D qnorm
#' @return This function will generate all possible model outcomes for validation and test dataset
#' \item{}{}
#' @examples
#' data_train <- data_train
#' data_train  <- data_train
#' data_test  <- data_test
#' mv=8
#' model_combination(data_train,data_valid,data_test,mv)


model_combination = function (data_train,data_valid,data_test,mv) {


cat("\n")
cat("prediction models **************************\n")
dat=cbind(data_valid$target);k=0
for (i in 1:(mv-1)) {  
  com=combn(seq(1,(mv-1)),i)
  #print(com)
  for (j in 1:ncol(com)) {
    k=k+1
    cat("model",k,":",com[,j],"\n")
    mod=lm(as.numeric(data_train$target) ~ as.matrix(data_train[,com[,j]]))
    pred=as.matrix(cbind(1,data_valid[,com[,j]]))%*%as.matrix(mod$coefficients)
    dat=cbind(dat,pred)
  }
}

sink("models_validation_all")
write.table(dat,quote=F,col.name=F,row.name=F)
sink()



cat("\n")
cat("prediction models **************************\n")
dat=cbind(data_test$target);k=0
for (i in 1:(mv-1)) {  
  com=combn(seq(1,(mv-1)),i)
  #print(com)
  for (j in 1:ncol(com)) {
    k=k+1
    cat("model",k,":",com[,j],"\n")
    mod=lm(as.numeric(data_train$target) ~ as.matrix(data_train[,com[,j]]))
    pred=as.matrix(cbind(1,data_test[,com[,j]]))%*%as.matrix(mod$coefficients)
    dat=cbind(dat,pred)
  }
}

sink("models_test_all")
write.table(dat,quote=F,col.name=F,row.name=F)
sink()

}



