\name{prepareData}
\alias{prepareData}
\title{Data preparation}
\usage{
prepareData(genDist=genDist, geoDist=geoDist, L=L, k=k)
}
\description{
Function to prepare data for a `sandwrm` analysis. User provides a genetic distance matrix (genDist), geographic distance matrix (geoDist), the number of loci (L), and the kappa parameter (k). See the usage vignettes for additional discussion of these parameters. 
}
\examples{
data("example_locs", "example_pwp")
coords <- example_locs[,c("x","y")]
geoDist <- fields::rdist(coords)
dataBlock <- prepareData(genDist=example_pwp, geoDist=geoDist, L=1e4, k=0.25)
print(dataBlock)
}
