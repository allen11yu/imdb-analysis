# Load the packages
library("dplyr")
library("ggplot2")

# Load in the data sets
movies_ratings_platforms <- read.csv("data/movies_ratings_platforms.csv",
  stringsAsFactors = FALSE
)

# Function called "platform_check" that takes in a specific movie
# name and the data frame. Creates a visualization to see which platform
# is that movie on.
platform_check <- function(movie_name, df) {
  movie_info <- df %>%
    filter(Movie == movie_name) %>%
    select(Netflix, Hulu, Prime.Video, Disney.)

  # Add a new column with NA values
  plot_df <- filter_platform(movie_info)
  plot_df <- plot_df[-1, ]

  ggplot(data = plot_df) +
    geom_bar(
      mapping = aes(x = platform, y = availability),
      width = 0.5,
      stat = "identity",
      fill = "steelblue"
    ) +
    ggtitle(paste("Which platform supports the movie:", movie_name)) +
    xlab("Platforms") +
    ylab("Status") +
    theme(plot.title = element_text(hjust = 0.5))
}

# Helper function. Creates and returns a data frame that shows whether
# the movie is on certain platform
filter_platform <- function(df) {
  plot_df <- data.frame(
    availability = NA,
    platform = NA
  )

  col_names <- colnames(df)

  for (name in col_names) {
    if (df[name] == 1) {
      plot_df <- rbind(plot_df, c("On", name))
    } else {
      plot_df <- rbind(plot_df, c("Not On", name))
    }
  }
  return(plot_df)
}
