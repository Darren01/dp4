###
### after scraping the data and placing it in a text file it was read in as follows
raw.table2  <- read.csv("table2.txt",stringsAsFactors=FALSE)
raw.c13.exp  <- read.csv("raw.c13.exp.txt",stringsAsFactors=FALSE)

position  <- seq(1,17,1)
calc.15a  <- as.numeric(raw.table2[seq(8,58,3),1])
calc.15b  <- as.numeric(raw.table2[seq(9,59,3),1])
c13.exp  <- as.numeric(raw.c13.exp[,1])
scaled.15a  <- as.numeric(raw.table2[seq(61,76,1),1])
scaled.15a[17]  <- as.numeric(strsplit(raw.table2[77,1]," ")[[1]][1])
scaled.15b  <- as.numeric(rep(NA,17))
scaled.15b[1]  <- as.numeric(strsplit(raw.table2[77,1]," ")[[1]][2])
scaled.15b[2:16]  <- as.numeric(raw.table2[c(78:92),1])
scaled.15b[17]  <- as.numeric(strsplit(raw.table2[93,1], " ")[[1]][1])
corr.15a  <- as.numeric(rep(NA,17))
corr.15a[1]  <- as.numeric(strsplit(raw.table2[93,1]," ")[[1]][2])
corr.15a[2:16]  <- as.numeric(raw.table2[c(94:108),1])
corr.15a[17]  <- as.numeric(strsplit(raw.table2[109,1]," ")[[1]][1])
corr.15b  <- as.numeric(rep(NA,17))
corr.15b[1]  <- as.numeric(strsplit(raw.table2[109,1]," ")[[1]][2])
corr.15b[2:16]  <- as.numeric(raw.table2[c(110:124),1])
corr.15b[17]  <- as.numeric(strsplit(raw.table2[125,1]," ")[[1]][1])
prob.15a  <- as.numeric(rep(NA,17))
prob.15a[1]  <- as.numeric(strsplit(raw.table2[125,1]," ")[[1]][2])
prob.15a[2:17]  <- as.numeric(raw.table2[126:141,1])
prob.15b  <- as.numeric(rep(NA,17))
prob.15b[1]  <- as.numeric(strsplit(raw.table2[143,1]," ")[[1]][2])
prob.15b[2:17]  <- as.numeric(raw.table2[144:159,1])

table2  <- data.frame(position,calc.15a,calc.15b,c13.exp,scaled.15a,scaled.15b,corr.15a,corr.15b,prob.15a,prob.15b)

fit.15a  <- lm(calc.15a ~ c13.exp, data=table2)
fit.15b  <- lm(calc.15b ~ c13.exp, data=table2)

opar  <- par(mfrow=c(1,2))
plot(calc.15a ~ c13.exp, data=table2)
abline(fit.15a,col="red")
plot(calc.15b ~ c13.exp, data=table2)
abline(fit.15b,col="red")
par(opar)

d.calc  <- function(x,y,z) {a  <- (x - y)/z
                 # x = calc; y = intercept; z = slope
                 return(a)}
Scaled.15a  <- d.calc(table2$calc.15a,fit.15a$coefficients[[1]],fit.15a$coefficients[[2]])
Scaled.15b  <- d.calc(table2$calc.15b,fit.15b$coefficients[[1]],fit.15b$coefficients[[2]])

Corr.15a  <- Scaled.15a - calc.15a
Corr.15b  <- Scaled.15b - calc.15b

prob  <- function(x,sigma=2.306,nu=11.38) {
     y  <- 1-pt((abs(x)/sigma),nu)
     return(y)
}

Prob.15a  <- prob(Corr.15a)
Prob.15b  <- prob(Corr.15b)

100*prod(Prob.15a)/(prod(Prob.15a)+prod(Prob.15b))
100*prod(Prob.15b)/(prod(Prob.15a)+prod(Prob.15b))