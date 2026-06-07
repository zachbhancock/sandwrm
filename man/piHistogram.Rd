\name{piHistogram}
\alias{piHistogram}
\title{plotting species diversity}
\usage{
piHistogram(out=out)
}
\description{
Plots of histogram of estimated species diversity (1 - s) across all chains.
}
\examples{
dataBlock <- prepareData(genDist=example_pwp, geoDist=geoDist, L=L, k=k)
sandwrm(dataBlock=dataBlock, nChains=1, nIter=1000, prefix="test")
load("test_out.Robj")
piHistogram(out=out)
}
