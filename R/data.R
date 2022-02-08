#' HLA typing.
#'
#' A dataset containing HLA typing from 37993 unrelated voluntary bone marrow donors from Nothern Portugal, recruited between 2010 and 2011.
#'
#' @format A data frame with 37993 rows and 9 variables:
#' \describe{
#'   \item{ID}{Identifier}
#'   \item{A1}{HLA-A allele 1}
#'   \item{A2}{HLA-A allele 2}
#'   \item{B1}{HLA-B allele 1}
#'   \item{B2}{HLA-B allele 2}
#'   \item{C1}{HLA-C allele 1}
#'   \item{C2}{HLA-C allele 2}
#'   \item{DRB11}{HLA-DRB1 allele 1}
#'   \item{DRB12}{HLA-DRB1 allele 2}
#'   ...
#' }
#' @source \url{https://www.slideshare.net/balima78/lima-2013}
"hla"


#' A pool of 10.0000 donors.
#'
#' A synthetic dataset with information for 10.000 donors, generated with `donors.df()` and `set.seed(3)` .
#'
#' @format A data frame with 37993 rows and 9 variables:
#' \describe{
#'   \item{ID}{Identifier}
#'   \item{bg}{ABO blood group}
#'   \item{A1}{HLA-A allele 1}
#'   \item{A2}{HLA-A allele 2}
#'   \item{B1}{HLA-B allele 1}
#'   \item{B2}{HLA-B allele 2}
#'   \item{DR1}{HLA-DRB1 allele 1}
#'   \item{DR2}{HLA-DRB1 allele 2}
#'   \item{age}{age in years}
#'   ...
#' }
#' @source \url{https://www.slideshare.net/balima78/lima-2013}
"D10K"


#' A vector with HLA-A.
#'
#' A character vector with antigens for HLA-A locus obtained from \code{hla} dataset.
#'
#' @format A character vector with length 20.
"agA"

#' A vector with HLA-B.
#'
#' A character vector with antigens for HLA-B locus obtained from \code{hla} dataset.
#'
#' @format A character vector with length 34.
"agB"

#' A vector with HLA-DR.
#'
#' A character vector with antigens for HLA-DR locus obtained from \code{hla} dataset.
#'
#' @format A character vector with length 13.
"agDR"
