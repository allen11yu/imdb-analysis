library(dplyr)
library(ggplot2)
library(leaflet)
library(plotly)
library(stringr)

# load data
movie_platform <- read.csv("./data/MoviesOnStreamingPlatforms_updated.csv",
  stringsAsFactors = FALSE
)
movie_top <- read.csv("./data/imdb_top_1000.csv", stringsAsFactors = FALSE)

pie_chart <- function(movie_platform, movie_top) {
  # combined data
  combined_data <- movie_platform %>%
    inner_join(movie_top, by = "Movie") %>%
    arrange(-IMDb)

  # movies that have rating >= 8.0 IMDb
  genre_chart <- combined_data %>%
    filter(IMDb >= 7.0) %>%
    select("Genre.x")

  genre1_action <- genre_chart %>%
    filter(str_detect(Genre.x, "Action"))


  genre2_drama <- genre_chart %>%
    filter(str_detect(Genre.x, "Drama"))

  genre3_romance <- genre_chart %>%
    filter(str_detect(Genre.x, "Romance"))

  genre4_comedy <- genre_chart %>%
    filter(str_detect(Genre.x, "Comedy"))

  genre5_horror <- genre_chart %>%
    filter(str_detect(Genre.x, "Horror"))

  # new data frame with numbers of each genre occurred
  genre <- c("Action", "Drama", "Romance", "Comedy", "Horror")
  number <- c(44, 113, 35, 65, 4)

  genre_dataframe <- data.frame(genre, number)

  # PIE CHART
  genre <- genre_dataframe$genre
  number <- genre_dataframe$number

  pie <- ggplot() +
    theme_bw() +
    geom_bar(aes(x = "", y = number, fill = genre),
      stat = "identity",
      color = "white"
    ) +
    coord_polar("y", start = 0) +
    ggtitle("Popularity of Genres") +
    theme(plot.title = element_text(hjust = 0.5, size = 12))

  return(pie)
}
