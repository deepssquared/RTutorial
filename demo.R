install.packages("tidyverse")
install.packages("ggplot2")

getwd()

library(tidyverse)
library(ggplot2)

data_nhanes = read.delim("NHANES.txt", na.strings = NA)
head(data_nhanes)
class(data_nhanes)

str(data_nhanes) # structure, what variable = what type 

# Vector Example
example.vec <- c(0, "Taylor", "Tiger")
example.vec = c(0, "Taylor", "Tiger")

# List
example.list= list(example.vec, data_nhanes)
example.list[[1]]
example.list[[2]]


# Explorating Data Frame
names(data_nhanes) # All Column Names
dim(data_nhanes)
nrow(data_nhanes) # number of rows
ncol(data_nhanes) #number of columns

# Weights of Smokers
tobacco_users_weights <- filter(data_nhanes, SmokeNow=="Yes") # Get ppl who smoke
tobacco_users_weights <- select(tobacco_users_weights, Weight)  # Select weights
tobacco_users_weights <- unlist(tobacco_users_weights) # Convert into number

tobacco_users_weights <- data_nhanes %>% 
  filter(SmokeNow=="Yes") %>%
  select(Weight) %>%
  unlist

non_tobacco_users_weights <- data_nhanes %>%
  filter(SmokeNow=="No") %>%
  select(Weight) %>%
  unlist

t.test(tobacco_users_weights, non_tobacco_users_weights)
summary(tobacco_users_weights)


mean(tobacco_users_weights)
mean(tobacco_users_weights, na.rm = TRUE)

### Histograms
hist(data_nhanes$Weight)
hist(tobacco_users_weights)

median(tobacco_users_weights, na.rm = T)

#### GGPLOT2 Scary Stuff ######

ggplot(aes(x = Weight, fill = factor(SmokeNow)), data = filter(data_nhanes, !is.na(SmokeNow))) + 
  geom_histogram(color = "white", position = "identity", alpha = 0.5, binwidth = 30) +
  labs(title = "Histogram", x = "Weight", y = "Frequency", fill = "Smoking Status")

ggplot(aes(x = Weight, fill = factor(SmokeNow)), data = filter(data_nhanes, !is.na(SmokeNow))) +
  geom_histogram(color = "white", alpha=0.5, position="identity") + 
  labs(title = "Weight Distribution based on Smoking Status", x = "Weight", y = "Frequency", fill = "Currently Smokes") + 
  scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9"))


### Plots ###

plot(data_nhanes$Age, data_nhanes$Weight)

ggplot(aes(x = Age, y = Weight), data = data_nhanes) + geom_point() + labs(title = "Something") + geom_smooth(method = "lm")

### Linear Regression

model <- lm(Weight ~ Age, data = data_nhanes)
summary(model)

### Logistic Regression

# First option: convert gender to factor

table(data_nhanes$Gender, useNA = "always")

data_nhanes <- data_nhanes %>% 
  mutate(gender_factor = as.factor(Gender)) # Mutate creates new variable

data_nhanes <- data_nhanes %>% 
  mutate(country = "USA")

logistic.model = glm(gender_factor ~ BMI, data = data_nhanes, family = "binomial")
summary(logistic.model)

# Second option: just specify in command

logistic.model = glm(factor(Gender) ~ BMI, data = data_nhanes, family = "binomial")
summary(logistic.model)
logistic.model %>% broom::tidy() # Summary Table

variables = colnames(data_nhanes)

data_nhanes %>%
  group_by(Gender) %>%
  summarise(n = n()) %>%
  mutate(percent = percent(n/nrow(data_nhanes)))

library(gtsummary)
tbl_summary(select(data_nhanes, Gender, AgeDecade, Race1))
