\name{robreg3S}
\alias{robreg3S}
\alias{coef.robreg3S}
\alias{print.robreg3S}
\alias{summary.robreg3S}
\alias{confint.robreg3S}
\title{Robust regression estimation and inference in the presence of cellwise and casewise contamination}
\description{
  Finds 3S-robust regression estimator using the adaptive consistent filter. 
}
\usage{
	robreg3S(y, x, dummies=NULL, filter=TRUE, alpha=0.20, K=5, ...)
}
\arguments{
  \item{y}{vector of responses.}
  \item{x}{matrix of the numerical variables.}
  \item{dummies}{matrix of the dummy covariates, i.e., where each column are 0--1 vectors.}
  \item{filter}{logical, whether the filtering is used. Default value is TRUE.}
  \item{alpha}{1-alpha upper quantile (and alpha lower quantile) of the covariate distribution used in tail comparison in the first step. An exponential tail is used as the reference distribution. Default value is 0.20.}
  \item{K}{number of alternating M-S iterations in the estimation of the coefficients of the dummy covariates. Default value is 5. See Leung et al. for more details.}
  \item{...}{optional arguments to be used in the computation of GSE in the second step. See \code{\link{GSE}}}
}
\details{
   This function computes 3S-robust regression as described in Leung et al. (2015).  
   
  If the model contains dummy variables (i.e., \code{dummies != NULL}),
  3S-regression is computed using an iterative algorithm as described in Leung et al. (2015).
  Briefly, the algorithm first estimates the coefficients of the dummies using
  an M-estimator of regression and the coefficients of the continuous
  covariates using the original 3S-regression. See Leung et al. (2015) for more
  details.
}
\value{
A list with components:

	\item{Summary.Table}{Matrix of information available about the
    estimator. It contains regression coefficients, and for \code{dummies != NULL}, columns
    for the standard error, t-statistic, and p-value.}
	\item{coef}{vector of regression coefficients.}
	\item{acov}{matrix of the asymptotic covariate matrix, only for \code{dummies != NULL}.}
	\item{resid}{vector of residuals, that is the response minus the fitted values.}
	\item{sigma.hat}{the estimated residual standard error.}
	\item{MD}{the squared Mahalanobis distances of each observation based on the continuous covariates to the
    generalized location S-estimator with respect to the generalized scatter S-estimator.} 
	\item{xfilter}{filtered matrix of the numerical variables from Step 1 of the estimator.}
	\item{ximpute}{matrix of the numerical variables with filtered cells imputed from Step 2 of the estimator.}
	\item{weight}{vector of the weights used in the estimation of the location generalized S-estimator. Not meant to be accessed.}
	\item{Syx}{estimated generalized S-scatter from Step 2. Not meant to be accessed.}
	\item{myx}{estimated generalized S-location from Step 2. Not meant to be accessed.}

}
\references{
	Leung, A. , Zamar, R.H., and Zhang, H. Robust regression estimation and inference in the presence of cellwise and casewise contamination. arXiv:1509.02564.
}
\author{Andy Leung \email{andy.leung@stat.ubc.ca}, Hongyang Zhang, Ruben H. Zamar}
\seealso{
  \code{\link{GSE}}, \code{\link{generate.cellcontam.regress}}, \code{\link{generate.casecontam.regress}},
  \code{\link{generate.casecontam.regress.dummies}}, \code{\link{generate.casecontam.regress.dummies}}
}
\examples{
## Boston housing data
data(Boston, package="MASS")
boston <- Boston; rm(Boston)
boston$crim <- log(boston$crim)
boston$nox <- boston$nox^2
boston$rm <- boston$rm^2
boston$dis <- log(boston$dis)
boston$lstat <- log(boston$lstat)
boston$medv <- log(boston$medv)
boston$black <- boston$black/1000
boston$age <- boston$age/100
boston$tax <- boston$tax/100
boston$indus <- boston$indus/100
boston <- subset( boston, select=c(medv, crim, nox, rm, age, dis, tax, ptratio, black, lstat) )

## LS, MM, 3S
set.seed(100)
fit.LS <- lm(medv ~  ., data=boston)
fit.MM <- robustbase::lmrob(medv ~  ., data=boston)
fit.2S <- robreg3S( y=boston$medv, x=as.matrix(subset(boston,select=-medv)), filter = FALSE )
fit.3S <- robreg3S( y=boston$medv, x=as.matrix(subset(boston,select=-medv)) )

## Compare estimated coefficients
nrow(boston) *sum(( coef(fit.LS)[-1] - coef(fit.3S)[-1])^2* apply(boston[,-1], 2, mad)^2)
nrow(boston) *sum(( coef(fit.MM)[-1] - coef(fit.3S)[-1])^2* apply(boston[,-1], 2, mad)^2)
nrow(boston) *sum(( coef(fit.2S)[-1] - coef(fit.3S)[-1])^2* apply(boston[,-1], 2, mad)^2)

## Summary table
summary(fit.3S)

}


