# simK
Functions to procedurally generate synthetic data in R for kidney transplant simulations.

![simk](https://github.com/balima78/simK/blob/main/images/simk.png)

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
