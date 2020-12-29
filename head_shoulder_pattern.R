# @author: Yi Rong
# update on 12/29/20
# Head-shoulder Pattern Identification


library(xts)
library(quantmod)
library(TTR)

Data <- read.csv(file = "sp500hst-1.csv")
AA <- subset(Data, Ticker == "AA") 
AAts <- data.frame(Price = AA[, "Close"])
AAmv <- runMean(AAts, n = 10)
plot(AAmv, type = "l")
AAmv <- cbind(Time = c(1 : length(AAmv)), AAmv)

E3 <- which.max(AAmv[,2])
AAmv[E3, ]
# Time Price
# 92   92 17.45 This is E3

EtrMin <- function(Series){
  Min <- data.frame(Time = c(NA), Price = c(NA))
  if(Series[1, 2] < Series[2, 2]){
    Min <- rbind(Min, Series[1, ])
  }
  for(i in 2 : (nrow(Series) - 1)){
    if((Series[i, 2] <= Series[i - 1, 2]) & (Series[i, 2] <= Series[i + 1, 2])){
      Min <- rbind(Min, Series[i, ])
    }
  }
  if(Series[nrow(Series), 2] < Series[(nrow(Series) - 1), 2]){
    Min <- rbind(Min, Series[nrow(Series), ])
  }
  return(Min)
}

AAmv1 <- AAmv[10 : 92, ]
Min1 <- EtrMin(AAmv1)
plot(Min1)

Min2 <- EtrMin(Min1[-1, ])
plot(Min2)
Min2
#   Time  Price
# 1   NA     NA
# 2   11 12.131 
# 5   70 12.972 This is E1

AAmv2 <- AAmv[92 : NROW(AAmv), ]
Min1 <- EtrMin(AAmv2)
plot(Min1)

Min2 <- EtrMin(Min1[-1, ])
plot(Min2)
Min2

Min3 <- EtrMin(Min2[-1, ])
plot(Min3)
Min3
#    Time  Price
# 1    NA     NA
# 2   113 13.176 This is E2
# 12  218 10.474

((12.972 + 13.176) / 2) * 1.015
# [1] 13.27011 upper bound
((12.972 + 13.176) / 2) * 0.985
# [1] 12.87789 lower bound
# E2 and E4 are in the 1.5 percentage range of their average

EtrMax <- function(Series){
  Max <- data.frame(Time = c(NA), Price = c(NA))
  if(Series[1, 2] > Series[2, 2]){
    Max <- rbind(Max, Series[1, ])
  }
  for(i in 2 : (nrow(Series) - 1)){
    if((Series[i, 2] >= Series[i - 1, 2]) & (Series[i, 2] >= Series[i + 1, 2])){
      Max <- rbind(Max, Series[i, ])
    }
  }
  if(Series[nrow(Series), 2] > Series[nrow(Series) - 1, 2]){
    Max <- rbind(Max, Series[nrow(Series), ])
  }
  return(Max)
}


Max1 <- EtrMax(AAmv1)
plot(Max1)

Max2 <- EtrMax(Max1[-1, ])
plot(Max2)
Max2
#   Time  Price
# 1   NA     NA
# 4   40 14.183 This is E1
# 6   92 16.538 This is E3

Max1 <- EtrMax(AAmv2)
plot(Max1)

Max2 <- EtrMax(Max1[-1, ])
plot(Max2)

Max3 <- EtrMax(Max2[-1, ])
plot(Max3)
Max3
#   Time  Price
# 1   NA     NA
# 2   92 16.538 This is E3
# 8  154 14.611 This is E5
# 9  157 14.611 This is also E5. They are the same, so take the first one.

((14.183 + 14.611) / 2) * 1.015
# [1] 14.61295 upper bound
((14.183 + 14.611) / 2) * 0.985
# [1] 14.18104 lower bound
# E1 and E5 are in the 1.5 percentage range of their average

# Show the result in a figure:
plot(AAmv[,2], ylim = c(10, 17), type = "l")
points(40, 14.183, col = "red")
text(40, 14.183, pos = 3, "E1")
points(70, 12.972, col = "red")
text(70, 12.972, pos = 1, "E2")
points(92, 16.538, col = "red")
text(92, 16.538, pos = 3, "E3")
points(113, 13.176, col = "red")
text(113, 13.176, pos = 1, "E4")
points(154, 14.611, col = "red")
text(154, 14.611, pos = 3, "E5")


# The neckline can be computed by E2 and E4:
slope <- (12.972 - 13.176) / (70 - 113)
intercept <- 12.972 - 70 * slope
abline(intercept, slope, col = "red")

x <- 1 : 245
NkValue <- slope * x + intercept

# Distance between E3 and neckline
Distance <- 16.538 - NkValue[92] 

which(AAmv[, 2] < NkValue)
# 171 is the first time that price drops below neckine.
AA[171, ]
# 2010-05-05


PriceObj <- NkValue[171] - Distance
# Hence price objective is 9.99





