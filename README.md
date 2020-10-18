# nodeGame-BotClassifier

```{r}
library(tidyverse)
library(DataExplorer)
library(caret)
library(caretEnsemble)
library(pROC)
library(gbm)
library(data.table)
library(superml)
```

```{r}
setwd("/Users/2egaa/Desktop/BotorNot/")
data_base <- read.csv("botornot-1.csv")
```

# Data Cleaning 

Identify relevant variables on theoretical note 

```{r}
data <- data_base %>%  select(c(bot, overallTime, consentTime, readProfileTime, readEssayTime, speeder, superspeeder, quirk, age, birthday, birthmonth, gender, totlanguage, god, grownup_us, samestate, sametown, incomeclass, retake, session, disconnected, treatment, feedback, grownup_us, parentsdivorced, children, pets.0, military, gayfriends, incomebracket, income,  session))
```

Recode NA's in bot column as zeros 

```{r}
data$bot[is.na(data$bot)] <- 0
data$bot[data$bot == 2] <- 1
data$bot[data$bot == 3] <- 1

data$bot <- as.factor(data$bot)

data$bot <- factor(data$bot, levels=c(0,1), labels=c("No", "Yes"))
data$speeder <- as.factor(data$speeder)
data$superspeeder <- as.factor(data$superspeeder)
data$retake <- as.factor(data$retake)
```

Remove NA Rows

```{r}
data <- data %>% na.omit()
```

Count words in quirk variable

```{r}
data <- data %>% mutate(quirk_count = sapply(gregexpr("\\S+", data$quirk), length), feedback_count = sapply(gregexpr("\\S+", data$feedback), length))

```


```{r}
data %>% group_by(bot) %>% 
         summarize(overalltime = mean(overallTime),
                   consenttime = mean(consentTime), 
                   readProfileTime = mean(readProfileTime), 
                   readEssayTime = mean(readEssayTime), 
                   speeder = mean(speeder), 
                   superspeeder = mean(superspeeder), 
                   quirk_count = mean(quirk_count),
                   age = median(age))
```

