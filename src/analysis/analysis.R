#Preliminary Regression analysis
regression <- lm(averageRating ~ startYear + runtimeMinutes + numVotes, data = movies)
summary(regression)

#Next; Check assumptions...
