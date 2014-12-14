

```{r}

##the function takes three vectors
##the calculated chemical shifts of the two suspects
##and the experimental data

dp4  <- function(calc.15a,calc.15b,c13.exp) {
  
  fit.15a  <- lm(calc.15a ~ c13.exp)
  fit.15b  <- lm(calc.15b ~ c13.exp)
  
  opar  <- par(mfrow=c(1,2))
  plot(calc.15a ~ c13.exp)
  abline(fit.15a,col="red")
  plot(calc.15b ~ c13.exp)
  abline(fit.15b,col="red")
  par(opar)
  
  d.calc  <- function(x,y,z) {a  <- (x - y)/z
                              # x = calc; y = intercept; z = slope
                              return(a)}
  Scaled.15a  <- d.calc(calc.15a,fit.15a$coefficients[[1]],fit.15a$coefficients[[2]])
  Scaled.15b  <- d.calc(calc.15b,fit.15b$coefficients[[1]],fit.15b$coefficients[[2]])
  
  Corr.15a  <- Scaled.15a - calc.15a
  Corr.15b  <- Scaled.15b - calc.15b
  
  prob  <- function(x,sigma=2.306,nu=11.38) {
    y  <- 1-pt((abs(x)/sigma),nu)
    return(y)
  }
  
  Prob.15a  <- prob(Corr.15a)
  Prob.15b  <- prob(Corr.15b)
  
  answ  <- 100*prod(Prob.15a)/(prod(Prob.15a)+prod(Prob.15b))
  return(answ)
}
```
