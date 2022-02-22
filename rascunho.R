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

usethis::use_ccby_license()

usethis::use_news_md(open = rlang::is_interactive())

usethis::use_pkgdown()

pkgdown::build_site()
usethis::use_pkgdown_github_pages()

usethis::use_vignette("started", title = "Get started")

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


library(tictoc)
tic()
candidates <- candidates.df(n=10, uk=T)
toc() # 5.5''

tic()
donors <- donors.df(n=10, uk=T)
toc() # 0.06''

tic()
abs <- Abs.df(candidates = candidates)
toc() # 4.65''

Abs.df(candidates = candidates.df(n=10),
       n.seed = 3)

library(hexSticker)
imgurl <- system.file("figures/kidneys.JPG", package="hexSticker")
s <- sticker(imgurl, package="simK", p_size=20, p_y = 1.65, p_color = 'black',
             s_x=1, s_y=1, s_width=.6,
             h_fill = 'white', h_color = 'red', h_size = 8,
             spotlight = T,
             url = 'https://txor.netlify.app/', u_size = 6,
             white_around_sticker = T,
        filename="images/simk.png")

candidates_df(n = 10,
              replace = TRUE,
              probs_abo = c(0.43, 0.03, 0.08, 0.46),
              probs_cpra = c(0.7, 0.1, 0.1, 0.1),
              lower = 18, upper = 75, mean = 45, sd = 15,
              prob_dm = 0.12,
              uk = TRUE,
              n_seed = 3)


Abs_df(candidates = candidates_df(n=10),
       n_seed = 3)


####
freqs <- read_csv2("data/em_freqsNMDPhaplotypes.csv")

MNDPhaps <- freqs %>%
  group_by(A, B, DR) %>%
  summarise(api = sum(API),
            afa = sum(AFA),
            cau = sum(CAU),
            his = sum(HIS)) %>%
  ungroup()


usethis::use_data(agDR_MNDP)

candidates_df(n = 10,
              replace = TRUE,
              origin = 'PT',
              probs_abo = c(0.43, 0.03, 0.08, 0.46),
              probs_cpra = c(0.7, 0.1, 0.1, 0.1),
              lower = 18, upper = 75, mean = 45, sd = 15,
              prob_dm = 0.12,
              uk = TRUE,
              n_seed = 3)

vpra(abs = c('A1','A2','B5','DR4'), donors = D10K_HIS)

antbs(cA = c('2','29'), cB = c('7','15'), cDR = c('4','7'),
      cPRA = 85, origin = 'PT', n_seed = 3)

Abs_df(candidates = candidates_df(n=10), origin = 'PT', n_seed = 3)

D10K
