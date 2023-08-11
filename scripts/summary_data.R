# Summary data functions

# We created a summary information function to compute useful information
# about our movie platform data sets. When run on our
# movies_ratings_platforms_top1000 dataset, we find that the dataset has
# n_col, the titles of each being col_names. The main columns we will use
# for analysis are weighted_average_vote and Meta_score. The average values for
# each are mean_imdb and mean_meta. For mean_imdb, this is from a range of
# highest_imbd and lowest_imdb. The dataset also consists of n_rows, but as some
# movies are repeats, there are only actually n_movies. Of the available movies,
# the most certificates are (index top_4_certificates).

library("dplyr")

mrp_top1000 <- read.csv("data/movies_ratings_platforms_top1000.csv",
  stringsAsFactors = FALSE
)

summary_info <- function(df) {
  r <- list()
  r$n_col <- ncol(df)
  r$col_names <- colnames(df)
  r$n_rows <- nrow(df)
  r$n_movies <- length(unique(df$Movie))
  r$mean_imdb <- mean(df$weighted_average_vote)
  r$highest_imdb <- max(df$weighted_average_vote)
  r$lowest_imdb <- min(df$weighted_average_vote)
  r$mean_meta <- mean(df$Meta_score)
  # is a table of the top 4 certificates
  # index to get specific values
  r$top_4_certificates <- mrp_top1000 %>%
    count(Certificate) %>%
    arrange(desc(n)) %>%
    slice(1:4)

  return(r)
}

r <- summary_info(mrp_top1000)
n_col <- r$n_col
col_names <- r$col_names
mean_imdb <- r$mean_imdb
mean_meta <- r$mean_meta
highest_imdb <- r$highest_imdb
lowest_imdb <- r$lowest_imdb
n_rows <- r$n_rows
n_movies <- r$n_movies
top_4_certificates <- r$top_4_certificates$Certificate
