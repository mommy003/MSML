#' model_evaluation function
#'
#' This function will identify best model in validation and test dataset. 
#' @param dat This is the matrix for all the combinations of model
#' @param mv The total number of columns in data_train/data_valid/data_test
#' @param tn The total no of best models to be identified
#' @param prev The prevalance of disease in the data
#' @keywords Identify best models
#' @export
#' @importFrom stats D qnorm
#' @return This function will generate all possible model outcomes for validation and test dataset
#' \item{}{}
#' @examples
#' dat <- read.table("models_test_all")
#' mv=8
#' tn=15
#' prev=0.047
#' model_evaluation(dat,mv,tn,prev)



model_evaluation = function (dat,mv,tn,prev) {
library(R2ROC)

dat=as.matrix(dat)
k=ncol(dat)-1

sink("eval.out1")
cat("model#    R^2          p-value\n")
best=matrix(0,k,2)
for (i in 1:k) {
  out=summary(lm(dat[,1]~dat[,(1+i)]))
  best[i,1]=out$r.squared
  best[i,2]=pf(out$fstatistic[1],out$fstatistic[2],out$fstatistic[3],lower.tail=F)
  cat(i,best[i,],"\n")
}
sink()

#sout=sort(best[,2])
sout=sort(best[,1],decreasing=T)
sv1=seq(1,length(best[,1]))
optm=sv1[best[,1] >= sout[tn]]
yi=length(optm)
pthreshold=0.05

sink("eval.out2")
cat("top",tn," best models **********************\n")
cat("model#    R^2          p-value\n")
for (i in 1:yi) {
  cat(optm[i],best[optm[i],],"\n")
}
sink()

sv1=seq(1,length(best[,1]))
#optm=sv1[best[,2] <= sout[tn]]
optm=sv1[best[,1] >= sout[tn]]
optm2=array(0,length(optm));yi=1
cat("\n")
cat("backward selection  **********************\n")
while (yi != 0) {
  cat("\n")
  yi=0;optm2=0
  cat("best model:",optm,"\n")
  for (i in 1:length(optm)) {
    for (j in 1:length(optm)) {
      out=auc_diff(dat[,c(1,(1+optm[i]),(1+optm[j]))],1,2,nrow(dat),prev)
      if (out$mean_diff>0 & out$p<pthreshold) {
        cat(optm[i],optm[j],"\n")
        if (!is.element(j,optm2)) {
          yi=yi+1
          optm2[yi]=j
        }
      }
    }
  }
  if (yi!=0) {
    optm=optm[-optm2[1:yi]]
  }
}


sink("eval.out3")
cat("selected models **********************\n")
cat("model#    R^2          p-value         Configurations\n")
k=0
for (i in 1:(mv-1)) {
  com=combn(seq(1,(mv-1)),i)
  #print(com)
  for (j in 1:ncol(com)) {
    k=k+1
    if (is.element(k,optm)) {
      cat(k,best[k,],"  ",com[,j],"\n")
    }
  }
}
sink()

}



