#' 3 sets of covariates for training data set
#'
#' A dataset containing N sets of covariates (N=3 as an example here) intended for constant use across all model configurations (refer to the 'model_configuration2' function) when using a training dataset. Please note that if constant covariates are not required, this file is unnecessary (refer to the 'model_configuration' function).  
#'
#' @format A data frame for training dataset:
#' \describe{
#'   \item{V1}{covariate 1}
#'   \item{V2}{covariate 2}
#'   \item{V3}{covariate 3}
#'   
#'   
#' }
"cov_train"