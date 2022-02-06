#' Builds a vector with truncated ages
#'
#' @description Returns a vector with ages with a normal distribution truncated by upper anf upper limits.
#' @param n An integer to define the length of the returned vector.
#' @param lower An integer for ages' lower limit.
#' @param upper An integer for ages' upper limit.
#' @param mean A value for mean's distribution.
#' @param sd A value for standar deviation's distribution.
#' @return A vector length `n` with normal distributed truncated ages.
#' @examples
#' ages(n = 100, lower=18, upper=75, mean = 55, sd = 15)
#' @export
ages <- function(n = 100, lower=18, upper=75, mean = 55, sd = 15){

  if(!is.numeric(n) | n < 1){stop("`n` must be a positive single number!\n")}
  if(!is.numeric(mean) | n < 1){stop("`mean` must be a positive single number!\n")}
  if(!is.numeric(sd) | n < 1){stop("`sd` must be a positive single number!\n")}
  if(!is.numeric(lower) | n < 1){stop("`lower` must be a positive single number!\n")}
  if(!is.numeric(upper) | n < 1){stop("`upper` must be a positive single number!\n")}

  round(
    truncnorm::rtruncnorm(n = n, a=lower, b=upper, mean = mean, sd = sd)
  )

}


#' number of HLA mismatchs
#'
#' @description Computes the number of HLA mismatchs between one donor and one candidate
#' @param dA donor's HLA-A typing
#' @param dB donor's HLA-B typing
#' @param dDR donor's HLA-DR typing
#' @param cA candidate's HLA-A typing
#' @param cB candidate's HLA-B typing
#' @param cDR candidate's HLA-DR typing
#' @return mmA number of HLA-A mismatchs between \code{dA} and \code{cA};
#' mmB number of HLA-B mismatchs between \code{dB} and \code{cB};
#' mmDR number of HLA-DR mismatchs between \code{dA}DRand \code{cDR};
#' and mmHLA as the sum of mmA + mmB + mmDR
#' @examples
#' mmHLA(dA = c('1','2'), dB = c('5','7'), dDR = c('1','4'), cA = c('1','2'), cB = c('03','15'), cDR = c('04','07'))
#' @export
mmHLA <- function(dA = c('1','2'), dB = c('5','7'), dDR = c('1','4'),
                  cA = c('1','2'), cB = c('3','15'), cDR = c('4','7')){

  mmA = NULL
  mmB = NULL
  mmDR = NULL

  # verify function parameters
  if(!is.character(dA)){stop("donor's HLA-A typing is not valid!\n")}
  if(!is.character(dB)){stop("donor's HLA-B typing is not valid!\n")}
  if(!is.character(dDR)){stop("donor's HLA-DR typing is not valid!\n")}
  if(!is.character(cA)){stop("candidate's HLA-A typing is not valid!\n")}
  if(!is.character(cB)){stop("candidate's HLA-B typing is not valid!\n")}
  if(!is.character(cDR)){stop("candidate's HLA-DR typing is not valid!\n")}

  # compute missmatches
  mmA<-ifelse((dA[1] %in% cA & dA[2] %in% cA) | (dA[1] %in% cA & (is.na(dA[2]) | dA[2] == "")), 0,
               ifelse(dA[1] %in% cA | dA[2] %in% cA, 1,
                       ifelse(!dA[1] %in% cA & (is.na(dA[2]) | dA[2] == ""), 1,
                               ifelse(dA[1] == dA[2], 1,2))))

  mmB<-ifelse((dB[1] %in% cB & dB[2] %in% cB) | (dB[1] %in% cB & (is.na(dB[2]) | dB[2] == "")), 0,
               ifelse(dB[1] %in% cB | dB[2] %in% cB, 1,
                       ifelse(!dB[1] %in% cB & (is.na(dB[2]) | dB[2] == ""), 1,
                               ifelse(dB[1] == dB[2], 1,2))))

  mmDR<-ifelse((dDR[1] %in% cDR & dDR[2] %in% cDR) | (dDR[1] %in% cDR & (is.na(dDR[2]) | dDR[2] == "")), 0,
                ifelse(dDR[1] %in% cDR | dDR[2] %in% cDR, 1,
                        ifelse(!dDR[1] %in% cDR & (is.na(dDR[2]) | dDR[2] == ""), 1,
                                ifelse(dDR[1] == dDR[2],1,2))))

  # resume results
  mmHLA = mmA + mmB + mmDR
  mm = c(mmA,mmB,mmDR,mmHLA)
  names(mm) <- c("mmA","mmB","mmDR","mmHLA")

  return(mm)
}

#' Matchability from D10K
#'
#' @description Computes the number donors on dataset D10K that are a match to a given transplant candidate. A sample of D10K is selected according to cPRA value, and donors ABO identical and HLA mismatch level 1 or 2 (0 DR or (1 DR and 0 B)) are filtered.
#' @param cABO A character from 'A', 'B', 'AB', 'O'
#' @param cPRA candidate's cPRA value
#' @param cA candidate's HLA-A typing
#' @param cB candidate's HLA-B typing
#' @param cDR candidate's HLA-DR typing
#' @param n.seed a numeric seed that will be used for random number generation.
#' @return mmA number of HLA-A mismatchs
#' @examples
#' matchability(dA = c('1','2'), dB = c('5','7'), dDR = c('1','4'), cA = c('1','2'), cB = c('03','15'), cDR = c('04','07'))
#' @export
matchability <- function(cABO = 'A', cPRA = 85,
                         cA = c('2','29'), cB = c('7','15'), cDR = c('4','7'),
                         n.seed = 3){
  if(!cABO %in% c('A','AB','B','O')){stop("Blood group is not valid! Valid options: 'A','AB','B','O'")}

  set.seed(n.seed)

  n1 <- (100-cPRA)*100

  n.donors <- sample_n(D10K, size = n1) %>%
    filter(bg == cABO) %>%
    mutate_if(is.numeric, as.character) %>%
    rowwise() %>%
    mutate(mmB = mmHLA(dA = c(A1,A2), dB = c(B1,B2), dDR = c(DR1,DR2),
                       cA = cA, cB = cB, cDR = cDR)['mmB'],
           mmDR = mmHLA(dA = c(A1,A2), dB = c(B1,B2), dDR = c(DR1,DR2),
                        cA = cA, cB = cB, cDR = cDR)['mmDR'],
           level12 = mmDR == 0 | (mmB == 0 & mmDR == 1)) %>%
    ungroup() %>%
    filter(level12) %>% nrow()

  return(n.donors)

}
