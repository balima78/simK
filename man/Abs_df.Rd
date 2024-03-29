% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sim_df.R
\name{Abs_df}
\alias{Abs_df}
\title{A data frame with candidates' HLA antibodies}
\usage{
Abs_df(candidates = candidates_df(n = 10), origin = "PT", n_seed = 3)
}
\arguments{
\item{candidates}{A dataframe with \code{ID}, HLA typing (column names: \code{A1}, \code{A2}, \code{B1}, \code{B2}, \code{DR1}, \code{DR2}) and cPRA value (column name: \code{cPRA}), for a group of transplant candidates.}

\item{origin}{A character value from options: 'API', 'AFA', 'CAU' and 'HIS'}

\item{n_seed}{a numeric seed that will be used for random number generation.}
}
\value{
A data frame with \code{ID} and HLA antibodies \code{Abs}.
}
\description{
Returns a data frame with transplant candidates' HLA antibodies
obtained according to theirs cPRA values and HLA typing.
}
\examples{
Abs_df(candidates = candidates_df(n=10), origin = 'PT', n_seed = 3)
}
\concept{generate_data}
