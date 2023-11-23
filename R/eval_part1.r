#' model_configuration function
#' This function will generate PRS based on all possible combianations of model. 
#' The total number of models required to explore the combinations of these 'n' 
#' features can be calculated by summing the combinations for each possible 
#' number of features, ranging from 1 to 'n' (C(n,i)).
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
#' data_valid  <- data_valid
#' data_test  <- data_test
#' mv=8
#' out=model_configuration(data_train,data_valid,data_test,mv)


model_configuration = function (data_train,data_valid,data_test,mv) {


cat("\n")
cat("prediction models **************************\n")
df1=cbind(data_valid$target);k=0
for (i in 1:(mv-1)) {  
  com=combn(seq(1,(mv-1)),i)
  #print(com)
  for (j in 1:ncol(com)) {
    k=k+1
    cat("model",k,":",com[,j],"\n")
    mod=lm(as.numeric(data_train$target) ~ as.matrix(data_train[,com[,j]]))
    pred=as.matrix(cbind(1,data_valid[,com[,j]]))%*%as.matrix(mod$coefficients)
    df1=cbind(df1,pred)
  }
}

df1=data.frame(df1)


cat("\n")
cat("prediction models **************************\n")
df2=cbind(data_test$target);k=0
for (i in 1:(mv-1)) {  
  com=combn(seq(1,(mv-1)),i)
  #print(com)
  for (j in 1:ncol(com)) {
    k=k+1
    cat("model",k,":",com[,j],"\n")
    mod=lm(as.numeric(data_train$target) ~ as.matrix(data_train[,com[,j]]))
    pred=as.matrix(cbind(1,data_test[,com[,j]]))%*%as.matrix(mod$coefficients)
    df2=cbind(df2,pred)
  }
}

df2=data.frame(df2)




num_row=k
#cat("prediction models **************************\n")
df3=matrix(0,num_row,7);k=0
for (i in 1:(mv-1)) {
  com=combn(seq(1,(mv-1)),i)
  #print(com)
  for (j in 1:ncol(com)) {
    k=k+1
    cat("model",k,":",com[,j],"\n")
    df3[k,1:length(com[,j])]=com[,j]
   }
}

df3=data.frame(t(df3))

z = list(
  "predict_validation" = df1,
  "predict_test" = df2,
  "total_model_configurations" = df3
  )

return(z)


}



