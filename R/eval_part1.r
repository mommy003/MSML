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

sink("models.all_127_validation")
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

sink("models.all_127_test")
write.table(dat,quote=F,col.name=F,row.name=F)
sink()

}



