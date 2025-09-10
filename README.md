> **Important:** This is a template repository to help you set up your team project.  
>  
> You are free to modify it based on your needs. For example, if your data is downloaded using *multiple* scripts instead of a single one (as shown in `\data\`), structure the code accordingly. The same applies to all other starter files—adapt or remove them as needed.  
>  
> Feel free to delete this text.


# Title of your Project Project Team 2
*Describe the purpose of this project* 

## Research Question

-   To what extent does a movie’s release year influence the average
    user rating? And does this relationship differ between animated and non-animated films?

## Hypothesis

There has been an increasingly critical attitude towards the franchise
and sequel-based strategy that movie corporations have integrated. As
more streaming services entered the market, the competitiveness in this
market rose, which led to a bigger variety in TV shows and movies
offered (Thompson, 2024). This is also shown in the rising number of
movies, series and other content per year in the IMDb dataset. The more
experienced a viewer is in watching movies, the more critical they
become (Moon et al., 2009). Furthermore, it could be reasoned that movie
consumers grew up with evoke a sense of nostalgia, leading to higher
ratings of older films. Authors such as Bollen et al. (2012) refer to
this as a form of “positivity effect”. Additionally, with the rise of
digital platforms and social media, review-bombing has been an
omnipresent effect with the release of new movies. All in all, these
findings suggest that newer films are rated worse than older films,
which the present study tests with the hypothesis:

H1: There is a negative relationship between release year and rating.

By analyzing whether a movie’s release year influences its average user
rating, we can better understand trends in audience perception during
the past decade and a half. The insights generated from this study may
be relevant for filmmakers, distributors, and researchers interested in
how modern industry changes affect audience evaluation.

H2: The negative effect of release year on rating is weaker for animated films compared to non-animated films. 

## Motivation

Since 2010, the film industry has been shaken on its foundations due to
the increasing popularity of streaming platforms (Hennig-Thurau et al.,
2021). This year, Netflix expanded their streaming service
internationally, marking a key point in the growth of on-demand content
(Oberoi, 2024). Distribution patterns changed, and consumer perceptions
of movies have shifted (Kumar, 2023). Most notably, the saturation and
availability of the entertainment market have resulted in more critical
consumers, which seemingly affects how audiences evaluate films (Hadida
et al., 2020). The present study aims to shed light on the temporal
dynamics within the quality perception of movies by answering the
following research question.

## Data

This dataset is constructed using secondary data from IMDb.com. A
dataset is created with all IMDB movies from 2010 until present. The
main objectives derived from this dataset are specifically
title.basics.tsv.gz and title.ratings.tsv.gz. These datasets contain
information about titles (e.g. release year, run time, and genre including
if the movie is anitmation or not) and ratings from all titles (e.g. average 
rate and number of votes). The IMDb ratings come from IMDb users and can be 
professionals or consumers.



## Method

To test the hypothesis, a linear regression was conducted. Release year
was treated as the independent variable, and average user rating as the
dependent variable. Other potential factors that could influence
ratings, such as genre, budget, actors, or directors, were included as
control variables. This study focuses on films released between 2010 and
the present (2025), as selected from the following datasets.

## Preview of Findings 
- Describe the gist of your findings (save the details for the final paper!)
- How are the findings/end product of the project deployed?
- Explain the relevance of these findings/product. 

## Repository Overview 

**Include a tree diagram that illustrates the repository structure*

## Dependencies 

ratings tconst (string): alphanumeric unique identifier of the title
(both datasets) averageRating – weighted average of all the individual
user ratings numVotes - number of votes the title has received

basics tconst (string): alphanumeric unique identifier of the title
(both datasets) startYear (YYYY) – represents the release year of a
title genres - includes the genre of the movie and if it is animated or 
not


## Running Instructions 

    # Load IMDb files with read_tsv()
    library(readr)
    library(dplyr)

    setwd('/Users/brittvanhaaster/Documents/R studio/project_week2')
    # Basics and rating files
    raw_basics <- read_tsv("title.basics.tsv")
    raw_ratings <- read_tsv("title.ratings.tsv")

    # Combine the two datasets into one
    combined_data <- merge(raw_basics, raw_ratings, by = "tconst", all.x = TRUE)

    # Convert character variable to numeric
    combined_data$startYear <- as.numeric(combined_data$startYear)

    # Apply filters to get a more robust and reliable analysis result
    movies_since2010 <- filter(
      combined_data,
      startYear >= 2010,
      titleType == "movie",
      !is.na(averageRating),
      numVotes >= 1000
    )

## About 

This project is set up as part of the Master's course [Data Preparation & Workflow Management](https://dprep.hannesdatta.com/) at the [Department of Marketing](https://www.tilburguniversity.edu/about/schools/economics-and-management/organization/departments/marketing), [Tilburg University](https://www.tilburguniversity.edu/), the Netherlands.

The project is implemented by team < x > members: < insert member details>

Billy Thompson. (2024, May 25). The Rise and Fall of Streaming TV? –
Michigan Journal of Economics. Michigan Journal of Economics.
<https://sites.lsa.umich.edu/mje/2024/05/25/the-rise-and-fall-of-streaming-tv/>

Bollen, D., Graus, M. P., & Willemsen, M. C. (2012). Remembering the
stars?: effect of time on preference retrieval from memory. Proceedings
of the sixth ACM conference on Recommender systems.
<https://doi.org/10.1145/2365952.2365998>

Hadida, A. L., Lampel, J., Walls, W. D., & Joshi, A. (2020). Hollywood
Studio Filmmaking in the Age of Netflix: a Tale of Two Institutional
Logics. Journal of Cultural Economics, 45(2), 213–238.
<https://doi.org/10.1007/s10824-020-09379-z>

Hennig-Thurau, T., Ravid, S. A., & Sorenson, O. (2021). The Economics of
Filmed Entertainment in the Digital Era. Journal of Cultural Economics,
45(2), 157–170. <https://doi.org/10.1007/s10824-021-09407-6>

Kumar, L. (2023, April). A Study On The Impact Of The OTT Platform On
The Cinema With The Special Reference On The Cinema Audience.
ResearchGate; unknown.
<https://www.researchgate.net/publication/376650380_A_Study_On_The_Impact_Of_The_OTT_Platform_On_The_Cinema_With_The_Special_Reference_On_The_Cinema_Audience>

Moon, S., Bergey, P. K., & Iacobucci, D. (2009). Dynamic Effects among
Movie Ratings, Movie Revenues, and Viewer Satisfaction. Journal Of
Marketing, 74(1), 108–121. <https://doi.org/10.1509/jmkg.74.1.108>

Oberoi, S. (2024, December 3). The Evolution of Netflix: from DVD
Rentals to Global Streaming Leader. Seat11a.com.
<https://seat11a.com/blog-the-evolution-of-netflix-from-dvd-rentals-to-global-streaming-leader/>

