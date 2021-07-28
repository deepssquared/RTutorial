install.packages("tidyverse")
install.packages("ggplot2")

getwd()

library(tidyverse)
library(ggplot2)

data_nhanes = read.delim("NHANES.txt", na.strings = NA)
head(data_nhanes)
class(data_nhanes)

# Vector Example
example.vec <- c(0, "Taylor", "Tiger")
example.vec = c(0, "Taylor", "Tiger")

# List
example.list= list(example.vec, data_nhanes)
example.list[[1]]
example.list[[2]]

