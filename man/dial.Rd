% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clinical.R
\name{dial}
\alias{dial}
\title{Gives time on dialysis in months}
\usage{
dial(hiper = TRUE, bg = "O")
}
\arguments{
\item{hiper}{A logical value for hipersensitized patients (cPRA > 85\%).}

\item{bg}{A character value for blood group.}
}
\value{
A value from a normal distribution.
}
\description{
Returns a value for time on dialysis in months by blood group and cPRA.
}
\examples{
dial(hiper = TRUE, bg = 'O')
}
\concept{clinical_parameters}
