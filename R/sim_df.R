#' A data frame with donors caracheristics
#'
#' @description Returns a data frame for simulated donors clinical and demographic caracheristics.
#' @param n An integer to define the number of rows
#' @param replace A logical value for sampling with replacement
#' @param probs A vector with the probabilities for blood group A, AB, B and O (in this order). The sum of the probabilities must be equal to one.
#' @param lower An integer for ages' lower limit.
#' @param upper An integer for ages' upper limit.
#' @param mean A value for mean's distribution.
#' @param sd A value for standar deviation's distribution.
#' @param uk A logical value, if TRUE is also computed the Donor Risk Index (DRI)
#' @param n.seed a numeric seed that will be used for random number generation.
#' @return A data frame with HLA typing, blood group and truncated ages for a simulated group of transplant donors.
#' @examples
#' donors.df(n = 1000, replace = TRUE, probs = c(0.4658, 0.0343, 0.077, 0.4229), lower=18, upper=75, mean = 55, sd = 15, uk = FALSE, n.seed = 3)
#' @export
donors.df <- function(n = 1000, replace = TRUE,
                      probs = c(0.4658, 0.0343, 0.077, 0.4229),
                      lower=18, upper=75,
                      mean = 60, sd = 12,
                      uk = FALSE,
                      n.seed = 3){

  set.seed(n.seed)

  df <- hla_sample(n = n, replace = replace)
  df$bg <- abo(n = n, probs = probs)
  df$age <- ages(n = n, lower=lower, upper=upper, mean = mean, sd = sd)
  df$ID <- paste0('D', 1:n)

  df <- df %>%
    dplyr::rename(DR1 = DRB11, DR2 = DRB12) %>%
    dplyr::select(ID, bg, A1, A2, B1, B2, DR1, DR2, age)

  if(uk == TRUE){
    # a column for height with N(165,20)
    df$height <- truncnorm::rtruncnorm(n = n, a=150, b=200, mean = 165, sd = 20)
    # # a column for hypertension with a mean frequency of 43%
    df$hypertension <- sample(c(1,0), size = n, replace = TRUE, prob = c(0.4, 0.6))
    # # a column for sex with a mean frequency of men (0) = 55%
    df$sex <- sample(c(0,1), size = n, replace = TRUE, prob = c(0.55,0.45))
    # # a column for CMV+ with a mean frequency of 90%
    df$cmv <- sample(c(1,0), size = n, replace = TRUE, prob = c(0.9, 0.1))
    # # a column for nº of days stayed on Hospital with P(4)
    df$hospital_stay <- rpois(n = n, lambda = 4)

    df<-df %>%
      dplyr::mutate(GFR = purrr::map_dbl(age,
                                         ~aGFR(age = .x)),
             UKKDRI = transplantr::ukkdri(age = age, height = height,
                                          htn = hypertension, sex = sex,
                                          cmv = cmv, gfr = GFR,
                                          hdays = hospital_stay),
             DRI = transplantr::ukkdri_q(UKKDRI, prefix = TRUE)
             ) %>%
      select(ID, bg, A1, A2, B1, B2, DR1, DR2, age, DRI)
  }

  return(df)
}

#' A data frame with donors characteristics
#'
#' @description Returns a data frame for simulated donors clinical and demographic characteristics.
#' @param n An integer to define the number of rows
#' @param replace A logical value for sampling with replacement
#' @param probs.abo A vector with the probabilities for blood group A, AB, B and O (in this order). The sum of the probabilities must be equal to one.
#' @param probs.cpra A vector with the probabilities for cPRA groups 0%, 1%-50%, 51%-84%, 85%-100% (in this order). The sum of the probabilities must be equal to one.
#' @param lower An integer for ages' lower limit.
#' @param upper An integer for ages' upper limit.
#' @param mean A value for mean age's distribution.
#' @param sd A value for standard deviation age's distribution.
#' @param prob.dm A value for the probability of having Diabetes Mellitus
#' @param uk A logical value, if TRUE is also computed the Donor Risk Index (DRI)
#' @param n.seed a numeric seed that will be used for random number generation.
#' @return A data frame with HLA typing, blood group and truncated ages for a simulated group of transplant donors.
#' @examples
#' candidates.df(n = 1000, replace = TRUE, probs = c(0.4658, 0.0343, 0.077, 0.4229), lower=18, upper=75, mean = 55, sd = 15, prob.dm = 0.12, uk = FALSE, n.seed = 3)
#' @export
candidates.df <- function(n = 1000, replace = TRUE,
                          probs.abo = c(0.43, 0.03, 0.08, 0.46),
                          probs.cpra = c(0.7, 0.1, 0.1, 0.1),
                          lower=18, upper=75,
                          mean = 45, sd = 15,
                          prob.dm = 0.12,
                          uk = FALSE,
                          n.seed = 3){

  set.seed(n.seed)

  df <- hla_sample(n = n, replace = replace)
  df$bg <- abo(n = n, probs = probs.abo)
  df$cPRA <- cpra(n = n, probs = probs.cpra)
  df$age <- ages(n = n, lower=lower, upper=upper, mean = mean, sd = sd)
  df$ID <- paste0('K', 1:n)

  df <- df %>%
    dplyr::rename(DR1 = DRB11, DR2 = DRB12) %>%
    dplyr::select(ID, bg, A1, A2, B1, B2, DR1, DR2, age, cPRA) %>%
    dplyr::mutate(hiper = cPRA > 85,
                  dialysis = purrr::map2_dbl(.x = bg,
                                      .y = hiper,
                                      ~dial(hiper = .y, bg = .x)))
  if(uk == TRUE){
    dm1 <- prob.dm
    dm0 <- 1-prob.dm
    df$dm <- sample(c(0,1), size = n, replace = TRUE, prob = c(dm0,dm1))
    df<-df %>%
      dplyr::mutate(UKKRRI = transplantr::ukkrri(age = age,
                                                 dx = 1,
                                                 wait = dialysis * 30,
                                                 dm = dm),
                    RRI = transplantr::ukkrri_q(UKKRRI, prefix = T)
                    ) %>%
      mutate_at(vars(ends_with('1'),ends_with('2')), as.character) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(ms = matchability(cABO = bg, cPRA = cPRA,
                                      cA = c(A1,A2), cB = c(B1,B2), cDR = c(DR1,DR2),
                                      n.seed = n.seed)
             ) %>%
      ungroup()
    df$MS <- dplyr::ntile(desc(df$ms), 10)
    df <- df %>%
      dplyr::mutate(TIER = ifelse(MS == 10 | cPRA == 100 | dialysis > 7*12, 'A', 'B'))


    }

  return(df)
  }
