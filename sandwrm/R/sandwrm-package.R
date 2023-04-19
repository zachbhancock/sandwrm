#' The 'sandwrm' package.
#'
#' @description The package sandwrm (Spatial Analysis of Neighborhood size and Diversity using WRight-Malecot model) uses pairwise geographic and genetic distance matrices to jointly estimate Wright's neighbhorhood size and long-term effective population size using a Bayesian approach implemented in Rstan.
#'
#' @docType package
#' @name sandwrm-package
#' @aliases sandwrm
#' @useDynLib sandwrm, .registration = TRUE
#' @import methods
#' @import Rcpp
#' @importFrom rstan sampling
#'
#' @references
#' Stan Development Team (2023). RStan: the R interface to Stan. R package version 2.21.8. https://mc-stan.org
#' Hancock ZB, Toczydlowski RH, Bradburd GS (2023) A spatial approach to jointly estimate Wright's neighborhood size and long-term effective population size. https://doi.org/10.1101/2023.03.10.532094
#'
NULL
