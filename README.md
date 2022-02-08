# simK
[![Project Status: Active – The project has reached a st
able, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

Functions to procedurally generate synthetic data in R for kidney transplant simulations.

![simk](https://github.com/balima78/simK/blob/main/images/simk.png){width=50%}

`simK` allows to generate data with clinical and demographic information for a pool of simulated cadaveric donors and a simulated wait listed candidates for kidney transplantation.

Generated data is particularly useful on [KARS](https://balima.shinyapps.io/kars/).

## Instalation

### Development version 

The development version can be installed from GitHub, if you want all the latest features, together with all the latest bugs and errors. You have been warned!

```
# install from GitHub
devtools::install_packages("balima78/simK")
```

## Main functions

This package has 3 main functions, with them we can generate simulated data for a poll of donors, a set of candidates to kidney transplantation and the respective HLA-antibodies for those patients sensitized.

### Donors

a data frame with information for a pool of simulated donors can be generated with the function `donors.df`:

```
library(simK)

donors.df(n = 10, 
          replace = TRUE, 
          probs = c(0.4658, 0.0343, 0.077, 0.4229), 
          lower=18, upper=75, mean = 55, sd = 15, 
          uk = FALSE, 
          n.seed = 3)
          
# A tibble: 10 x 10
   ID    bg    A1    A2    B1    B2    DR1   DR2     age DRI  
   <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <dbl> <chr>
 1 D1    B     1     29    8     44    11    7        40 D2   
 2 D2    A     2     3     7     57    4     8        54 D4   
 3 D3    O     11    33    14    35    1     13       51 D3   
 4 D4    A     24    30    49    58    11    11       74 D4   
 5 D5    A     2     3     7     51    1     13       72 D4   
 6 D6    O     30    68    15    18    3     4        59 D3   
 7 D7    A     3     26    18    40    11    13       46 D2   
 8 D8    O     1     1     7     8     3     13       71 D4   
 9 D9    A     3     3     7     44    15    8        70 D3   
10 D10   A     11    29    44    57    7     7        69 D4 
```

For a given number of rows `n`, a data frame is generated with columns: 

  + *ID* unique identifier with the prefix 'D'; 
  + *bg* with the blood group generated from the input `probs` a vector with the probabilities for groups A, AB, B and O respectively; 
  + *A1*, *A2*, *B1*, *B2*, *DR1*, *DR2* HLA typing obtained from HLA allelic and haplotipic frequencies previously published by [Lima *et al*, 2013](https://www.slideshare.net/balima78/lima-2013) (with `replace = TRUE` we can generate a data frame without limitations on the number of rows)
  + *age* generated from a Normal distribution with `mean` and `sd` given by the user, values truncated by `lower` and `upper` boundaries
  + *DRI* when option `uk = TRUE` Donor Risk Index is copmputed as described by [transplantr](https://transplantr.txtools.net/articles/kidney_risk_scores.html) 
  
defining `n.seed` allows for reproducibility.

