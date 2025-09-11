
#Load the packages
library(readr) 
library(dplyr)
library(tidyverse)
library(stringr)
library(googledrive)

############################
#PIPELINE STEP: LOADING DATA
############################

#Import the IMDb 'basics' file
file_id <- "1jDPyh6ikp85OIUf6LwSVB693aqK1TTU_"
drive_download(as_id(file_id), path = "raw_basics.csv", overwrite = TRUE)
raw_basics <- read.csv("raw_basics.csv")

#Import the IMDb 'ratings' file
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
                        startYear >= 1995, startYear < 2025)

#Selecting the variables relevant to analysis to keep an overview
#Note: Variables removed are; "tconst", "originalTitle", "isAdult", "endYear"
eligible_data <- eligible_data %>% select(titleType, 
                                          primaryTitle,
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
#there are some extremely long 'movies' in the dataset that are presumably not
#movies but series compilation. This has to be filtered.

eligible_data <- filter(eligible_data,
                 runtimeMinutes >= 40, runtimeMinutes <= 280)

#To ensure reliable analysis, low number of votes should be eliminated as these
#do not result in reliable averageRatings
summary(eligible_data$numVotes)
#The min, 1st quartile and median are both very low. 

#Creating the FINAL dataset named "movies" for further analysis
movies <- filter(eligible_data,
                 numVotes >= 1000)

#Lastly, create dummy for animation since that is the focus of the research
movies$animation_dummy <- ifelse(grepl("Animation", movies$genres), 1, 0)

#Save the definitive dataset as a file
write.csv(movies, file = "movies.csv", row.names = FALSE)