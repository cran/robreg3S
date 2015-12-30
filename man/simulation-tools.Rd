\name{simulation-tools}
\alias{generate.randbeta}
\alias{generate.cellcontam.regress}
\alias{generate.casecontam.regress}
\alias{generate.cellcontam.regress.dummies}
\alias{generate.casecontam.regress.dummies}
\title{Data generator for simulation study on cell- and case-wise contamination}
\description{
	Includes the data generator for the simulation study on cell- and case-wise contamination that appears on Leung et al. (2015). 
}
\usage{
generate.randbeta(p) 

generate.cellcontam.regress(n, p, A, sigma, b, k, cp)

generate.casecontam.regress(n, p, A, sigma, b, l, k, cp)

generate.cellcontam.regress.dummies(n, p, pd, probd, A, sigma, b, k, cp)

generate.casecontam.regress.dummies(n, p, pd, probd, A, sigma, b, l, k, cp)
}
\arguments{
  \item{n}{integer indicating the number of observations to be generated.}
  \item{p}{integer indicating the number of continuous variables to be generated.}
  \item{pd}{integer indicating the number of dummy variables to be generated.}  
  \item{probd}{vector of quantiles of length \code{pd}. To generate dummy variables 
      \code{pd} continuous variables are first generated. Then, the variables are dichotomize
	  at normal quantiles of \code{probd}.}  
  \item{A}{a correlation matrix. See also \code{\link{generate.randcorr}}.} 
  \item{sigma}{residual standard deviation.}
  \item{b}{vector of regression coefficients.}
  \item{k}{size of cellwise outliers and vertical outliers. See Leung et al. for details.}
  \item{l}{size of leverage outliers. See Leung et al. for details.}
  \item{cp}{proportion of cell- or case-wise contamination. Maximum of 10\% for cellwise and 50\% for casewise.}
}
\value{
A list with components:

	\item{x}{multivariate normal sample with cell- or case-wise contamination.}
	\item{y}{vector of responses.}
	\item{dummies}{vector of dummies.}

}
\references{
	Leung, A. , Zamar, R.H., and Zhang, H. Robust regression estimation and inference in the presence of cellwise and casewise contamination. arXiv:1509.02564.
}
\author{Andy Leung \email{andy.leung@stat.ubc.ca}, Hongyang Zhang, Ruben H. Zamar}
\seealso{
  \code{\link{generate.randcorr}}
}
\examples{
##################################################
## Cellwise contaminated data simulation 
## (continuous covariates only)
set.seed(10)
b <- 10*generate.randbeta(p=15)
A <- generate.randcorr(cond=100, p=15)
dat <- generate.cellcontam.regress(n=300, p=15, A=A, sigma=0.5, b=b, k=10, cp=0.05)

## LS
fit.LS <- lm( y ~ x, dat)
mean((coef(fit.LS)[-1] - b)^2)

## MM regression
fit.MM <- robustbase::lmrob( y ~ x, dat)
mean((coef(fit.MM)[-1] - b)^2)

## 3S regression
fit.3S <- robreg3S( y=dat$y, x=dat$x, init="imputed")
mean((coef(fit.3S)[-1] - b)^2)



##################################################
## Casewise contaminated data simulation
## (continuous covariates only)
set.seed(10)
b <- 10*generate.randbeta(p=10)
A <- generate.randcorr(cond=100, p=10)
dat <- generate.casecontam.regress(n=200, p=10, A=A, sigma=0.5, b=b, l=8, k=10, cp=0.10)

## LS
fit.LS <- lm( y ~ x, dat)
mean((coef(fit.LS)[-1] - b)^2)

## MM regression
fit.MM <- robustbase::lmrob( y ~ x, dat)
mean((coef(fit.MM)[-1] - b)^2)

## 3S regression
fit.3S <- robreg3S( y=dat$y, x=dat$x, init="imputed")
mean((coef(fit.3S)[-1] - b)^2)


\dontrun{
##################################################
## Cellwise contaminated data simulation 
## (continuous and dummies covariates)
set.seed(10)
b <- 10*generate.randbeta(p=15)
A <- generate.randcorr(cond=100, p=15)
dat <- generate.cellcontam.regress.dummies(n=300, p=12, pd=3, 
   probd=c(1/2,1/3,1/4), A=A, sigma=0.5, b=b, k=10, cp=0.05)

## LS
fit.LS <- lm( dat$y ~ dat$x + dat$dummies)
mean((coef(fit.LS)[-1] - b)^2)

## MM regression
fit.MM <- robustbase::lmrob( dat$y ~ dat$x + dat$dummies)
mean((coef(fit.MM)[-1] - b)^2)

## 3S regression
fit.3S <- robreg3S( y=dat$y, x=dat$x, dummies=dat$dummies, init="imputed")
mean((coef(fit.3S)[-1] - b)^2)


##################################################
## Casewise contaminated data simulation 
## (continuous and dummies covariates)
set.seed(10)
b <- 10*generate.randbeta(p=15)
A <- generate.randcorr(cond=100, p=15)
dat <- generate.casecontam.regress.dummies(n=300, p=12, pd=3, 
   probd=c(1/2,1/3,1/4), A=A, sigma=0.5, b=b, l=7, k=10, cp=0.10)

## LS
fit.LS <- lm( dat$y ~ dat$x + dat$dummies)
mean((coef(fit.LS)[-1] - b)^2)

## MM regression
fit.MM <- robustbase::lmrob( dat$y ~ dat$x + dat$dummies)
mean((coef(fit.MM)[-1] - b)^2)

## 3S regression
fit.3S <- robreg3S( y=dat$y, x=dat$x, dummies=dat$dummies, init="imputed")
mean((coef(fit.3S)[-1] - b)^2)

}
}


