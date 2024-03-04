#' 3 sets of covariates for validation data set
#'
#' A dataset containing N sets of covariates (N=3 as an example here) intended for constant use across all model configurations (refer to the 'model_configuration2' function) when using a validation dataset. Please note that if constant covariates are not required, this file is unnecessary (refer to the 'model_configuration' function).  
#'
#' @format A data frame for validation dataset:
#' \describe{
#'   \item{V1}{covariate 1}
#'   \item{V2}{covariate 2}
#'   \item{V3}{covariate 3}
#'   
#'   
#' }
"cov_valid"