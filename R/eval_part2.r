#' model_evaluation function
#'
#' This function will identify the best model in the validation and test dataset. 
#' @param dat This is the matrix for all the combinations of the model
#' @param mv The total number of columns in data_train/data_valid
#' @param tn The total no of best models to be identified
#' @param prev The prevalence of disease in the data
#' @param pthreshold The P value threshold for the significance level
#' @param method The methods to be used to evaluate models
#' @keywords Identify best models
#' @export
#' @importFrom stats D lm pf 
#' @import r2redux
#' @import R2ROC
#' @return This function will generate all possible model outcomes for validation and test dataset
#' @examples \donttest{
#' dat <- predict_validation
#' mv=8
#' tn=15
#' prev=0.047
#' out=model_evaluation(dat,mv,tn,prev)
#' #This process will generate three output files.
#' #out$out_all, contains AUC, R2, and P-values for all models.
#' #out$out_start, contains AUC, R2, and P-values for top tn models.
#' #out$out_selected, contains AUC, R2, and P-values for best models.
#' #For details (see https://github.com/mommy003/MSML).
#' }

model_evaluation = function (dat,mv,tn,prev,pthreshold=0.05,method="R2ROC") {

os_name <- Sys.info()["sysname"]
   if (startsWith(os_name, "Win")) {
     slash <- paste0("\\")
   } else {
     slash <- paste0("/")
   }

dat=as.matrix(dat)
k=ncol(dat)-1

sink(paste0(tempdir(), slash, "evaluation1.out"))
#cat("model#    AUC    p-value      R^2          p-value\n")
best=matrix(0,k,4)
for (i in 1:k) {
  out=summary(lm(dat[,1]~dat[,(1+i)]))
  best[i,3]=out$r.squared
best[i,4]=pf(out$fstatistic[1],out$fstatistic[2],out$fstatistic[3],lower.tail=F)
out=auc_var(dat[,c(1,1+i)],1, nrow(dat),prev)
best[i,1]=out$auc
best[i,2]=out$p

  cat(i,best[i,],"\n")
}
sink()

#sout=sort(best[,2])
sout=sort(best[,1],decreasing=T)
sv1=seq(1,length(best[,1]))
optm=sv1[best[,1] >= sout[tn]]
yi=length(optm)

sink(paste0(tempdir(), slash, "evaluation2.out"))
#cat("top",tn," best models **********************\n")
#cat("model#   AUC    p-value    R^2          p-value\n")
for (i in 1:yi) {
  cat(optm[i],best[optm[i],],"\n")
}
sink()

sv1=seq(1,length(best[,1]))
#optm=sv1[best[,2] <= sout[tn]]
optm=sv1[best[,1] >= sout[tn]]
optm2=array(0,length(optm));yi=1
cat("\n")
#cat("backward selection  **********************\n")
while (yi != 0) {
  cat("\n")
  yi=0;optm2=0
  #cat("best model:",optm,"\n")
  for (i in 1:length(optm)) {
    for (j in 1:length(optm)) {
      if (method=="R2ROC") {
        out=auc_diff(dat[,c(1,(1+optm[i]),(1+optm[j]))],1,2,nrow(dat),prev)
      }
      else if (method=="r2redux") {
        out=r2_diff(dat[,c(1,(1+optm[i]),(1+optm[j]))],1,2,nrow(dat))
        out$p=out$r2_based_p
      }
      else {
        cat("Error: method should be R2ROC or r2redux","\n")
      }

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


sink(paste0(tempdir(), slash, "evaluation3.out"))
#cat("selected models **********************\n")
#cat("model#    AUC    p-value   R^2          p-value         Configurations\n")
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


df1 = as.matrix(read.table(paste0(tempdir(), slash, "evaluation1.out"), header = F, sep=","))
df2 = as.matrix(read.table(paste0(tempdir(), slash, "evaluation2.out"), header = F, sep=","))
df3 = as.matrix(read.table(paste0(tempdir(), slash, "evaluation3.out"), header = F, sep=","))
                 
z = list(
"out_all" = df1,
"out_start" = df2,
"out_selected" = df3
)

}