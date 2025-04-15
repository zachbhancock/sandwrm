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

The beauty of the `sandwrm` is it needs but a single function, though it does require a tiny bit of data preparation on your part. You will need to supply two matrices: a genetic and a geographic distance. If you have coordinates for each individual, you can create a geographic distance matrix like this:

```r
library(fields)
sampled <- read.table("your_locations_file.txt", header=TRUE)
coords <- sampled[,c("x","y")]
geoDist <- rdist(coords)
```

Next, you want to convert your genetic distances, which are normally expressed as expected heterozygosity, to expected homozygosity. This is easy, just do:

```r
pwp <- data.matrix(read.table("your_genetic_distance_file.csv", header=TRUE))  
hom <- 1-pwp
diag(hom) <- 1 #add inbreeding
```

Almost there! Now, all you need to do is create a data block. Do that by modifying the following:

```r
dataBlock <- list("N"=nrow(pwp),
                  "L" = 1e4,
                  "hom"=hom,
                  "k" = 0.25,
                  "geoDist"=geoDist)
```

Okay, let's explain some of that. The "N" is the number of individuals, the "L" is the number of loci you have, "hom" is the pairwise homozygosity matrix you created, "k" is for kappa (I'll explain that in a moment), and "geoDist" is your geographic distance matrix. With the data block made, you're now ready to ride the `sandwrm`! To do that, simply call it like so:

```r
sandwrm(dataBlock=dataBlock, nChain=nChain, nIter=nIter, prefix="prefix")
```

In the above, "nChain" is how many independent MCMC chains you'd like to run, "nIter" is how many steps you'd like them to take, and "prefix" is whatever you'd like your output files to be named. `sandwrm` produces four output files: initPars.Robj, pars.Robj, out.Robj, and plots.pdf. The first two are the parameter files. The out.Robj file can be used for extracting specific variables (I'll show you how in a moment), and the last is a pdf of three plot types. The first plot shows the MCMC performance, the second is for visualizing any inferred parameters that might be correlated, and the last is the fit of the model. 

The dashed line on the third plot is for set value of "k". Theoretically, "k" is the distance below which mating can reasonably be considered random. In pratice, this might be difficult to know; fortunately, the model is not sensitive to small values of "k", so you can test a range of values and set a lowerbound as seems appropriate for your system. Note that arbitrarily high values of "k" can decrease the model's ability to infer isolation-by-distance over short distances, which might inflate your estimates. 

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
