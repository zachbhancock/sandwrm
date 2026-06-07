\name{nbhdHistogram}
\alias{nbhdHistogram}
\title{plotting nbhd}
\usage{
nbhdHistogram(out=out)
}
\description{
Plots of histogram of estimated neighborhood sizes (nbhd) across all chains.
}
\examples{
dataBlock <- prepareData(genDist=example_pwp, geoDist=geoDist, L=L, k=k)
sandwrm(dataBlock=dataBlock, nChains=1, nIter=1000, prefix="test")
load("test_out.Robj")
nbhdHistogram(out=out)
}
