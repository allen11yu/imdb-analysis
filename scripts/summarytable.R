library("dplyr")

movie_data <- read.csv("./data/movies_ratings_platforms_top1000.csv",
  stringsAsFactors = FALSE
)

summary_table <- function(movie_data) {
  movie_summary <- movie_data[!duplicated(movie_data$Movie), ] %>%
    select(Movie,
      Genre = genre,
      weighted_average_vote,
      Metascore = Meta_score,
      duration,
      Netflix,
      Hulu,
      Prime.Video,
      Disney.
    ) %>%
    arrange(-weighted_average_vote)

  class(movie_summary$Netflix)
  movie_summary$Netflix[movie_summary$Netflix == (0)] <- "No"
  movie_summary$Netflix[movie_summary$Netflix == (1)] <- "Yes"

  movie_summary$Hulu[movie_summary$Hulu == (0)] <- "No"
  movie_summary$Hulu[movie_summary$Hulu == (1)] <- "Yes"

  movie_summary$Prime.Video[movie_summary$Prime.Video == (0)] <- "No"
  movie_summary$Prime.Video[movie_summary$Prime.Video == (1)] <- "Yes"

  movie_summary$Disney.[movie_summary$Disney. == (0)] <- "No"
  movie_summary$Disney.[movie_summary$Disney. == (1)] <- "Yes"

  return(movie_summary)
}
