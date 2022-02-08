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

vpra(abs = c('A1','A2','B5','DR4'))

abs(cA = c('1','68'), cB = c('8','51'), cDR = c('14','12'),
    cPRA = 85)

library(tictoc)
tic()
abs.df <- candidates.df(n=10, uk=T) %>%
  # filter(cPRA > 0) %>%
  # slice(1:10) %>%
  #as_tribble() %>%
  rowwise() %>%
  mutate(Abs = list(abs(cA = c(A1,A2), cB = c(B1,B2), cDR = c(DR1,DR2),
                   cPRA = cPRA)$Abs))
toc()

abs.df %>%
  filter(cPRA > 0)


library(tictoc)
tic()
candidates <- candidates.df(n=10, uk=T)
toc() # 5.5''

tic()
donors <- donors.df(n=10, uk=T)
toc() # 0.06''

tic()
abs <- abs.df(candidates = candidates)
toc() # 4.65''


abs %>% View()

library(hexSticker)
imgurl <- system.file("figures/kidneys.JPG", package="hexSticker")
s <- sticker(imgurl, package="simK", p_size=20, p_y = 1.65, p_color = 'black',
             s_x=1, s_y=1, s_width=.6,
             h_fill = 'white', h_color = 'red', h_size = 3,
             spotlight = T,
             url = 'https://txor.netlify.app/', u_size = 5,
             white_around_sticker = T,
        filename="images/simk.png")

?simK
