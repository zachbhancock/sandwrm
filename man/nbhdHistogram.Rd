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
data("example_locs", "example_pwp")
coords <- example_locs[,c("x","y")]
geoDist <- fields::rdist(coords)
genDist <- as.matrix(example_pwp)
dataBlock <- prepareData(genDist=genDist, geoDist=geoDist, L=1e4, k=0.25)
sandwrm(dataBlock=dataBlock, nChains=1, nIter=1000, prefix="test")
load("test_out.Robj")
nbhdHistogram(out=out)

}
