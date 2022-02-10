# simK
[![Project Status: Active – The project has reached a st
able, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

**License**: Creative Commons Attribution [CC-BY](https://creativecommons.org/licenses/by/2.0/). Feel free to share and adapt, but don't forget to credit the author. :sunglasses:

<img src="images/simk.png" height="150" align="right"/>

:dart: Functions to procedurally generate synthetic data in R for kidney transplant simulations.

`simK` allows to generate data with clinical and demographic information for a pool of simulated cadaveric donors and simulated wait listed candidates for kidney transplantation.

Data generated with `simK` are particularly useful on [KARS](https://balima.shinyapps.io/kars/).

> :warning: This package is not a medical device and <ins>should not be used for making clinical decisions</ins>. :warning: 

## Instalation

### Development version 

The development version can be installed from GitHub, if you want all the latest features, together with all the latest bugs and errors. You have been warned :exclamation:

```
# install from GitHub
devtools::install_github("balima78/simK")
```

## Main functions

This package has 3 main functions, with them we can generate simulated data for a pool of donors, a set of kidney transplant candidates and the respective HLA-antibodies for those patients HLA sensitized.

### Donors

A data frame with information for a pool of simulated donors can be generated with the function `donors.df()`:

```
library(simK)
# you must run also tidyverse
library(tidyverse)

donors.df(n = 10, 
          replace = TRUE, 
          probs = c(0.4658, 0.0343, 0.077, 0.4229), 
          lower = 18, upper = 75, mean = 55, sd = 15, 
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
  + *bg* with the blood group generated from the parameter `probs` a vector with the probabilities for groups A, AB, B and O, respectively; 
  + *A1*, *A2*, *B1*, *B2*, *DR1*, *DR2* HLA typing obtained from HLA allelic and haplotipic frequencies previously published by [Lima *et al*, 2013](https://www.slideshare.net/balima78/lima-2013) (with `replace = TRUE` we can generate a data frame without limitations on the number of rows);
  + *age* generated from a Normal distribution with `mean` and `sd` given by the user, values truncated by `lower` and `upper` boundaries;
  + *DRI* when option `uk = TRUE`, Donor Risk Index is copmputed as described by [transplantr](https://transplantr.txtools.net/articles/kidney_risk_scores.html) 
  
defining `n.seed` allows for reproducibility.

:information_source: to compute *DRI* as decribed on `{transplantr}`, we generated variables: *height* (N(165,20)); *hypertension* (with probability 0.43); *sex* (with probability 0.55 for man); *CMV+* (with probability 0.9); hospital stay (P(ld = 4)); and *GFR* by *age* (<30 N(116,10); 30-39 N(107,10); 40-49 N(99,10); 50-59 N(93,10); 60-69 N(85, 10); >=70  N(75, 10)) 

### Candidates

A simulated waiting list for kidney transplant candidates, can be generated with `candidates.df()`:

```
candidates.df(n = 10, 
              replace = TRUE,
              probs.abo = c(0.43, 0.03, 0.08, 0.46),
              probs.cpra = c(0.7, 0.1, 0.1, 0.1),
              lower=18, upper=75, mean = 45, sd = 15,
              prob.dm = 0.12,
              uk = TRUE,
              n.seed = 3)
              
# A tibble: 10 x 14
   ID    bg    A1    A2    B1    B2    DR1   DR2     age dialysis  cPRA Tier     MS RRI  
   <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <dbl>    <dbl> <dbl> <chr> <int> <chr>
 1 K1    A     1     29    8     44    11    7        58       49     0 B         1 R3   
 2 K2    O     2     3     7     57    4     8        33       72     0 B         7 R2   
 3 K3    A     11    33    14    35    1     13       65       15     0 B         2 R3   
 4 K4    O     24    30    49    58    11    11       34       78     0 B         8 R2   
 5 K5    O     2     3     7     51    1     13       36       90     0 A         3 R2   
 6 K6    A     30    68    15    18    3     4        21       35     0 B         4 R4   
 7 K7    O     3     26    18    40    11    13       26       58     0 B         5 R1   
 8 K8    A     1     1     7     8     3     13       37       54    21 B         6 R2   
 9 K9    O     3     3     7     44    15    8        47       60    60 B         9 R3   
10 K10   O     11    29    44    57    7     7        25       94    90 A        10 R4   
              
```

For a given number of `n` rows, a data frame is generated with columns: 

  + *ID* unique identifier with the prefix 'K'; 
  + *bg* with the blood group generated from the parameter `probs.abo` a vector with the probabilities for groups A, AB, B and O, respectively (here by default, we assumed group O patients are more frequent); 
  + *A1*, *A2*, *B1*, *B2*, *DR1*, *DR2* HLA typing obtained from HLA allelic and haplotipic frequencies previously published by [Lima *et al*, 2013](https://www.slideshare.net/balima78/lima-2013) (with `replace = TRUE` we can generate a data frame without limitations on the number of rows);
  + *age* generated from a Normal distribution with `mean` and `sd` given by the user, values truncated by `lower` and `upper` boundaries;
  + *dialysis* time on dialysis **in months**, values computed according to patients' blood group and hypersensitation status (cPRA > 85%): for patients with blood group O **and** Hypersinsitized time on dialysis obtained from N(85, 20); for those patients blood O **or** Hypersinsitized N(70,20); remaing patients have time on dialysis obtained from N(35,20);
  + *cPRA* patients are classified in groups with probabilities given by `probs.cpra` for 0%, 1%-50%, 51%-85% and 86%-100%, respectively. Within the groups > 0%, cPRA are computed as random values from distributions P(ld = 30), P(ld = 70) and P(lb = 90);
  + *Tier* patients are classified in two Tiers as described on [POL186/11 – Kidney Transplantation: Deceased Donor Organ Allocation](https://nhsbtdbe.blob.core.windows.net/umbraco-assets-corp/22127/pol186.pdf) from UK transplant. In Tier A are patients with MS = 10 or cPRA = 100% or time on dialysis > 7 years, all remaing patients are classified as Tier B;
  + *MS* matchabilily score are the deciles obtained from the number of donors on dataset `D10K` that are a match to each transplant candidate. [This score takes into account a patient’s blood type, HLA type and cPRA value. A patient with a MS = 1 is defined as easy to match and a MS = 10 as difficult to match.](https://www.odt.nhs.uk/odt-structures-and-standards/odt-hub-programme/kidney-offering-scheme/#:~:text=blood%20group%20match-,Key%20terms,10%20as%20difficult%20to%20match)
  + *RRI* when option `uk = TRUE`, Recipient Risk Index is copmputed as described by [transplantr](https://transplantr.txtools.net/articles/kidney_risk_scores.html). To compute RRI, variables age, time on dialysis (in days) and the probability of being diabetic (obtained from `prob.dm`) are used. Also, we assumed all patients were on dialysis at time of listing.
  
defining `n.seed` allows for reproducibility.

### HLA antibodies

the function `abs.df()` allows to generate a data frame with HLA antibodies from a candidates waiting list:

```
abs.df(candidates = candidates.df(n=10), 
       n.seed = 3)
       
# A tibble: 41 x 2
   ID    abs  
   <chr> <chr>
 1 K8    A25  
 2 K8    DR16 
 3 K8    A33  
 4 K8    B51  
 5 K9    A24  
 6 K9    DR16 
 7 K9    A33  
 8 K9    B52  
 9 K9    B49  
10 K9    DR16 
# ... with 31 more rows
```

as inputs, this function requires a data set with an *ID* and patients HLA information (HLA typing and cPRA value) with the same format as provided  by `candidates.df()`. Defining `n.seed` allows for reproducibility.

:warning: 
All this functions rely on HLA typing at intermediate resolution as described at  [Lima *et al*, 2013](https://www.slideshare.net/balima78/lima-2013).
:warning:
