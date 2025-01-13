\name{sandwrm}
\alias{sandwrm}
\title{run the Wright-Malecot model}
\usage{
sandwrm(dataBlock=dataBlock, nChains=nChains, nIter=nIter, prefix="prefix")
}
\description{
Bayesian estimation of parameters of the Wright-Malecot model. dataBlock is prepared as below, nChains is the number of independent MCMC chains to run, nIter is how many steps per chain, and prefix is the name that will be affixed to the output files.
}
\examples{
data("example_locs", "example_pwp")
coords <- example_locs[,c("x","y")]
geoDist <- fields::rdist(coords)
pwp <- data.matrix(example_pwp)
hom <- 1-pwp
# add inbreeding, this standardizes the diagonal to 1
diag(hom) <- 1
dataBlock <- list("N"=nrow(pwp),
                  "L" = 1e4,
                  "hom"=hom,
                  "k" = 0.25,
                  "geoDist"=geoDist)

sandwrm(dataBlock=dataBlock, nChains=1, nIter=1000, prefix="test")
}
