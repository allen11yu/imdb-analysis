# scatter plot, highest ranking movies on each platform
library(dplyr)
library(plotly)

# Why?
# This plot chart attempts to express the most popular movies available on every
# streaming platform. This expresses the types of streaming service data that
# we have access to, and demonstrates the capability of sorting the overall
# dataframe for specific values as well as combining them afterwords.
# Scatter plots were used for this display because of the many data points
# specific numerical values, and multiple categories (platforms).

# What
# The scatter plot displays the top 5 movies from every streaming service.
# The points contain the name and rating of the movie (when hovered), and are
# color coded by streaming service. The y values are the movie ratings.



mrp_top1000 <- read.csv("data/movies_ratings_platforms_top1000.csv",
  stringsAsFactors = FALSE
)

popular_movies <- function(df) {
  netflix_top <- df %>%
    filter(Netflix == 1) %>%
    arrange(desc(weighted_average_vote)) %>%
    slice(1:5) %>%
    select(Movie, Netflix, weighted_average_vote)

  hulu_top <- df %>%
    filter(Hulu == 1) %>%
    arrange(desc(weighted_average_vote)) %>%
    slice(1:5) %>%
    select(Movie, Hulu, weighted_average_vote)

  prime_top <- df %>%
    filter(Prime.Video == 1) %>%
    arrange(desc(weighted_average_vote)) %>%
    slice(1:5) %>%
    select(Movie, Prime.Video, weighted_average_vote)

  disney_top <- df %>%
    filter(Disney. == 1) %>%
    arrange(desc(weighted_average_vote)) %>%
    slice(1:5) %>%
    select(Movie, Disney., weighted_average_vote)

  all_top <- full_join(netflix_top, hulu_top, by = c("Movie"), all = TRUE) %>%
    full_join(prime_top, by = c("Movie"), all = TRUE) %>%
    full_join(disney_top, by = c("Movie"), all = TRUE)

  all_plot <- plot_ly(all_top, x = ~Movie) %>%
    add_markers(
      y = ~weighted_average_vote.x, type = "scatter",
      name = "Netflix"
    ) %>%
    add_markers(
      y = ~weighted_average_vote.y, type = "scatter",
      name = "Hulu"
    ) %>%
    add_markers(
      y = ~weighted_average_vote.x.x, type = "scatter",
      name = "Prime"
    ) %>%
    add_markers(
      y = ~weighted_average_vote.y.y, type = "scatter",
      name = "Disney"
    ) %>%
    layout(
      title = "Top Rated 5 Movies on Streaming Platforms",
      yaxis = list(title = "Ratings")
    )

  return(all_plot)
}
