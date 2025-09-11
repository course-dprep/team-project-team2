
#Load the packages
library(readr) 
library(dplyr)
library(tidyverse)
library(stringr)
library(googledrive)

############################
#PIPELINE STEP: LOADING DATA
############################

#Since the IMDb-datasets update daily, the downloaded datasets have been stored
#in Google Drive and can be imported to ensure the same data from the 
#consideration of reproducing the results.
#Note: the data of IMDb was downloaded on September 3rd 2025.

#As the basics file is quite substantial in size, import it via;
file_id <- "1jDPyh6ikp85OIUf6LwSVB693aqK1TTU_"
drive_download(as_id(file_id), path = "raw_basics.csv", overwrite = TRUE)
raw_basics <- read.csv("raw_basics.csv")

#As the ratings file is not large in size, it can be imported via;
raw_ratings <- read.csv("https://drive.google.com/uc?export=download&id=1tvvAQKNL6OTTiHc9xwzxkydWupzKMXJs")

###################################################
#PIPELINE STEP: FROM RAW TO DEFINITIVE DATASET DATA
###################################################

#Combine the two datasets into one
raw_combined <- merge(raw_basics, raw_ratings, by = "tconst", all.x = TRUE)

#Set variables right; convert character variable to numeric
raw_combined$startYear <- as.numeric(raw_combined$startYear)
raw_combined$runtimeMinutes <- as.numeric(raw_combined$runtimeMinutes)

#Save the raw_combined file
write.csv(raw_combined, file = "raw_combined.csv", row.names = FALSE)

#Checking the different types of content
sort(table(raw_combined$titleType), decreasing = TRUE)
#The study is interested in movies released in cinema, so filter titleType to 
#"movie". Note: "tvMovie" is thus NOT included

#Checking the different types of genres
sort(table(raw_combined$genres), decreasing = TRUE)
#The study is interested in animated movies, so filter to "Animation"
#Note, because there are a lot of combinations of genres, use a string detect 

#Checking the years there is data of
min(raw_combined$startYear, na.rm = TRUE)
max(raw_combined$startYear, na.rm = TRUE)
#The study is interested from the period since the first computer animation 
#released. Therefore, 1995 is taken as the starting point given the release of
#Toy Story. Movies should have been released to ensure consistency across data,
#whereby 2024 is set as the other end for the filter

#Applying the eligibility conditions in a filter to the raw dataset
eligible_data <- filter(raw_combined, 
                        titleType == "movie",
                        str_detect(genres, "Animation"),
                        startYear >= 1995, startYear < 2025)

#Selecting the variables relevant to analysis to keep an overview
#Note: Variables removed are; "tconst", "originalTitle", "endYear"
eligible_data <- eligible_data %>% select(titleType, 
                                          primaryTitle,
                                          isAdult, 
                                          startYear, 
                                          runtimeMinutes, 
                                          genres, 
                                          averageRating, 
                                          numVotes)

#Check whether there are missing values in the dataset
colSums(is.na(eligible_data))

#There are, so remove movies that have missing values in (one of the) variables
eligible_data <- eligible_data %>%
  filter(!is.na(averageRating),
         !is.na(numVotes),
         !is.na(runtimeMinutes))

#Now the eligible dataset is with complete values, inspection can take place

#Check the variable runtimeMinutes
summary(eligible_data$runtimeMinutes)
#Oscars define a feature film has a length that exceeds 40. Additionally, 
#IMDb states the longest animated film is 162 minutes. Therefore filter runtime

#To ensure reliable analysis, low number of votes should be eliminated as these
#do not result in reliable averageRatings
summary(eligible_data$numVotes)
#The 3rd quartile range is taken as the filter

#Creating the FINAL dataset named "movies" for further analysis
movies <- filter(eligible_data,
                 runtimeMinutes >= 40, runtimeMinutes <= 162,
                 numVotes >= 1293)

#Save the definitive dataset as a file
write.csv(movies, file = "movies.csv", row.names = FALSE)




################################
#PIPELINE STEP: DATA EXPLORATION
################################

#Overview of definitive dataset
summary(movies)

#Frequencies: histogram of ratings
ggplot(movies, aes(x=averageRating)) + geom_histogram()

#Frequencies: average rating per year
graph <- movies %>% 
  group_by(startYear) %>% 
  summarize(meanRating = mean(averageRating, na.rm = TRUE))
ggplot(graph, aes(x=startYear, y=meanRating)) + geom_line()

#Frequencies: boxplot of runtime in minutes
ggplot(movies, aes(y = runtimeMinutes)) + geom_boxplot()

