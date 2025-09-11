################################
#PIPELINE STEP: DATA EXPLORATION
################################

#Note, loading the datasets should be put here, how?

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


graph <- movies %>% 
  group_by(startYear, animation_dummy) %>% 
  summarize(meanRating = mean(averageRating, na.rm = TRUE), .groups = 'drop')

ggplot(graph, aes(x = startYear, y = meanRating, color = as.factor(animation_dummy))) +
  geom_line() +
  labs(
    title = "Average Rating by Year: Animation vs. Non-Animation",
    x = "Release Year",
    y = "Average Rating",
    color = "Is Animation"
  ) +
  scale_color_manual(values = c("0" = "blue", "1" = "orange"),
                     labels = c("0" = "Non-Animation", "1" = "Animation")) +
  theme_minimal()


#A PRELIMINARY and NON-DEFINITIVE but EXPLORATORY analysis
#Just to get a feeling with it

#T-test
t.test(averageRating ~ animation_dummy, data = movies)

#Regression
regression <- lm(averageRating ~ startYear*animation_dummy + runtimeMinutes + numVotes, data = movies)
summary(regression)

#Next sections to be worked out are related to the ASSUMPTIONS
#That is for later