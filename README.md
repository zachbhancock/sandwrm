## sandwrm

Welcome! This repo is where the `sandwrm` lives - proceed with caution. 

`sandwrm` is a statistical tool for inferring Wright's neighborhood size and species-level diversity from pairwise geographic and genetic distances. For theoretical background, check out our [paper](https://academic.oup.com/genetics/article/227/4/iyae094/7691213). The method paper is in development, Hancock Z.B. & Bradburd G.S. (in prep). 

`sandwrm` stands for "**S**patial **A**nalysis of **N**eighborhood size and **D**iversity with the **WR**ight **M**alecot model." Below, we provide a brief description of how to use the package. 

## Installing the sandwrm 

To install:

```r
library(devtools)
install_github("zachbhancock/sandwrm", build_vignettes = TRUE)
library(sandwrm)
```

And that's it!

## Calling the sandwrm

The beauty of the `sandwrm` is it needs only two functions. You will need to supply two matrices: a genetic and a geographic distance. If you have coordinates for each individual, you can create a geographic distance matrix like this:

```r
library(fields)
sampled <- read.table("your_locations_file.txt", header=TRUE)
coords <- sampled[,c("x","y")]
geoDist <- rdist(coords)
```

Next, you can use the function `prepareData` to get your data into the format for a typical `sandwrm` run. 

```r
genDist <- read.table("your_genetic_distance_file.txt", header=TRUE)
L <- 1e4
k <- 0.25
dataBlock <- prepareData(genDist=genDist, geoDist=geoDist, L=L, k=k)
```

Wait, what're these _L_ and _k_ variables? _L_ can typically be thought of as the number of independent loci in your dataset. The _real_ definition is a little trickier, check out our paper for more details. In general, _L_ is typically some number less than the number of loci retained after trimming for LD. Theoretically, _k_ is the distance below which mating can reasonably be considered random. In pratice, this might be difficult to know; fortunately, the model is not sensitive to small values of _k_, so you can test a range of values and set a lowerbound as seems appropriate for your system. Note that arbitrarily high values of _k_ can decrease the model's ability to infer isolation-by-distance over short distances, which might inflate your estimates. 

With the data now formatted, you're now ready to ride the `sandwrm`! To do that, simply call it like so:

```r
sandwrm(dataBlock=dataBlock, nChain=nChain, nIter=nIter, prefix="prefix")
```

In the above, "nChain" is how many independent MCMC chains you'd like to run, "nIter" is how many steps you'd like them to take, and "prefix" is whatever you'd like your output files to be named. `sandwrm` produces four output files: initPars.Robj, pars.Robj, out.Robj, and plots.pdf. The first two are the parameter files. The out.Robj file can be used for extracting specific variables (I'll show you how in a moment), and the last is a pdf of three plot types. The first plot shows the MCMC performance, the second is for visualizing any inferred parameters that might be correlated, and the last is the fit of the model. 

The dashed line on the third plot is for set value of "k". 

Okay, last thing - dealing with those pesky R objects! Often, we want to extract just one or a couple of variables to plot. Here's how you can get just neighborhood size from the out.Robj file:

```r
load("out.Robj")
nbhd <- rstan::extract(out$fit, "nbhd", inc_warmup=TRUE, permute=FALSE)
#make long
nbhd_long <- plyr::adply(nbhd, c(1, 2, 3)) %>% 
  dplyr::rename("iteration"="iterations", "chain"="chains", "nbhd"="V1") %>%
  mutate(chain = gsub("chain:", "", chain)) %>% dplyr::select(-parameters)
#plot nbhd
hist(nbhd_long$nbhd)
```

The same thing can be done for species-level diversity. This parameter is "s", which is "species-level homozygosity," to convert it, simply do 1 - s!

The `sandwrm` package includes the following vignettes, which includes this tutorial and some suggestions for possible ways to get your hands on a pairwise genetic distance matrix:

```r
#how to run the package
vignette(topic = "run-sandwrm", package = "sandwrm")
#data formatting
vignette(topic = "format-data", package = "sandwrm")
```

## Conclusion

And that's it! If you had any troubles calling the `sandwrm`, feel free to post in the repo or contact me by email at hancockz (at) umich.edu. 
