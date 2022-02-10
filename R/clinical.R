#' A data frame with HLA typing
#'
#' @description Returns a data frame with HLA-A, -B, -C and -DRB1 typing
#' @param n An integer to define the number of rows
#' @param replace A logical value for sampling with replacement
#' @return A data frame
#' @examples
#' hla_sample(n = 1000, replace = TRUE)
#' @export
hla_sample <- function(n, replace){

  if(!is.numeric(n)){stop("`n` must be a single number!")}
  if(!is.logical(replace)){stop("`replace` must be logical (TRUE or FALSE)")}

  df <- dplyr::slice_sample(hla, n = n, replace = replace)

  return(df)
}

#' Builds a vector with ABO blood group
#'
#' @description Returns a vector with ABO blood groups according to user defined frequencies
#' @param n An integer to define the length of the returned vector
#' @param probs A vector with the probabilities for blood group A, AB, B and O (in this order). The sum of the probabilities must be equal to one.
#' @return A vector length `n` with ABO blood groups
#' @examples
#' abo(n = 100, probs = c(0.4658, 0.0343, 0.077, 0.4229))
#' @export
abo <- function(n = 100, probs = c(0.4658, 0.0343, 0.077, 0.4229)){

  if(!is.numeric(n) | n < 1){stop("`n` must be a single number!")}
  if(round(sum(probs)) != 1){stop("`probs` do not sum 1!")}

  abo <- c('A','AB','B','O')
  sample(x=abo, size = n, replace = TRUE, prob = probs)

}

#' Gives a eGFR by age
#'
#' @description Returns a value for the Estimated Glomerular Filtration Rate (eGFR) by age as described by https://www.kidney.org/atoz/content/gfr.
#' @param age An integer for age (values between 1 and 99).
#' @return A value from a normal distribution.
#' @examples
#' aGFR(age = 43)
#' @export
aGFR <- function(age = 43){
  if(!is.numeric(age) | age < 1 | age > 99){stop("`age` must be between 1 and 99!")}

  res <- ifelse(age < 30, truncnorm::rtruncnorm(n = 1, a=106, b=122, mean = 116, sd = 10),
                ifelse(age < 40, truncnorm::rtruncnorm(n = 1, a=97, b=117, mean = 107, sd = 10),
                       ifelse(age < 50, truncnorm::rtruncnorm(n = 1, a=89, b=109, mean = 99, sd = 10),
                              ifelse(age < 60, truncnorm::rtruncnorm(n = 1, a=83, b=103, mean = 93, sd = 10),
                                     ifelse(age < 70, truncnorm::rtruncnorm(n = 1, a=75, b=95, mean = 85, sd = 10),
                                            truncnorm::rtruncnorm(n = 1, a=65, b=85, mean = 75, sd = 10))))))

  return(res)

}

#' Builds a vector with cPRA (percentage)
#'
#' @description Returns a vector with cPRA percentages according to user defined frequencies
#' @param n An integer to define the length of the returned vector
#' @param probs A vector with the probabilities for cPRA groups 0%, 1%-50%, 51%-84%, 85%-100% (in this order). The sum of the probabilities must be equal to one.
#' @return A vector length `n` with cPRA percentages
#' @examples
#' cpra(n = 100, probs = c(0.7, 0.1, 0.1, 0.1))
#' @export
cpra <- function(n = 100, probs = c(0.7, 0.1, 0.1, 0.1)){

  if(!is.numeric(n) | n < 1){stop("`n` must be a single number!")}
  if(round(sum(probs)) != 1){stop("`probs` do not sum 1!")}
  if(length(probs) != 4){stop("`probs` must be a vector with length 4!")}

  n4 <- round(n*probs[4])
  n3 <- round(n*probs[3])
  n2 <- round(n*probs[2])
  n1 <- n - (n2+n3+n4)

  v1 <- rep(0,n1)
  v2 <- extraDistr::rtpois(n = n2, lambda = 30, a = 1, b = 50)
  v3 <- extraDistr::rtpois(n = n3, lambda = 70, a = 51, b = 85)
  v4 <- extraDistr::rtpois(n = n4, lambda = 90, a = 86, b = 100)

  v <- c(v1,v2,v3,v4)

  return(sample(v))
}

#' Gives time on dialysis in months
#'
#' @description Returns a value for time on dialysis in months by blood group and cPRA.
#' @param hiper A logical value for hipersensitized patients (cPRA > 85%).
#' @param bg A character value for blood group.
#' @return A value from a normal distribution.
#' @examples
#' dial(hiper = TRUE, bg = 'O')
#' @export
dial <- function(hiper = TRUE, bg = 'O'){
  if(!bg %in% c('A','AB','B','O')){stop("`bg` is not valid! valid blood group: 'A','AB','B','O'")}
  if(!is.logical(hiper)){stop("`hiper` must be a logical value!")}

  dial1 <- round(rnorm(1, 35,20))

  res <- ifelse(hiper == TRUE & bg == 'O', round(rnorm(1, 85,20)),
                ifelse(hiper == TRUE | bg == 'O', round(rnorm(1, 70,20)),
                       ifelse(dial1 < 0, 0, dial1)
                       ))

  return(res)

}



