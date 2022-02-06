usethis::use_package("data.table")

usethis::use_testthat()

library(tidyverse)
library(data.table)

usethis::use_package("transplantr", "Imports")

# Edit one or more files below R/.
# document() (if you’ve made any changes that impact help files or NAMESPACE)
# load_all()
# Run some examples interactively.
# test() (or test_file())
# check()

devtools::document()
devtools::load_all()
devtools::test()

devtools::check()

hla <- read_csv2("~/2.PhD/HEADS/HLA37993.csv", col_types = 'cdddddddd')

usethis::use_data(D10K)

# https://rich-iannone.github.io/pointblank/articles/VALID-III.html

set.seed(3)
donors.df(uk = T)


library(transplantr)

kidney.donors

data(kidney.recipients)

ukkdri(age = 55, height = 180, htn = 1, sex = 'M', cmv = 1, gfr = 30, hdays = 100)
# https://cran.r-project.org/web/packages/transplantr/vignettes/kidney_risk_scores.html
# https://transplantr.txtools.net/articles/kidney_risk_scores.html
# https://cran.r-project.org/web/packages/transplantr/

library(tictoc)
tic()
candidates.df(n = 2000, uk=T)
toc()


# continuar a partir da pasta:
# D:\backup CNH bruno 2020-12-15\_CHN_\Trabalhos\CHN\Allocation 2017-09
# para criar ficheiro de Acs
