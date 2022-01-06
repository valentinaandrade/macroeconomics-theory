library(boot)
library(plotrix)
n <- 1e3

## if p_hat is estimated with 0 variance (in the limit of infinite bootstraps), then the best estimate we can come up with is biased by exactly this much:
approx <- 1/((1-1/n)^n)

dat <- c("A", rep("B", n-1))
indicator <- function(x, ndx)   xor("A"%in%x[ndx], TRUE) ## Because we want to count when "A" is *not* in the bootstrap sample

p_hat <- function(dat, m=1e3){
    foo <- boot(data=dat, statistic=indicator, R=m) 
    1/mean(foo$t)
} 

reps <- replicate(100, p_hat(dat))

boxplot(reps)
abline(h=exp(1),col="red")

p_mean <- NULL
p_var <- NULL
for(i in 1:10){
    reps <- replicate(2^i, p_hat(dat))
    p_mean[i] <- mean(reps)
    p_var[i] <- sd(reps)
}
plotCI(2^(1:10), p_mean, uiw=qnorm(0.975)*p_var/sqrt(2^(1:10)),xlab="m", log="x", ylab=expression(hat(p)), main=expression(paste("Monte Carlo Estimates of ", tilde(e))))
abline(h=approx, col='red')