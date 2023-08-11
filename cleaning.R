# Load "dplyr" package
library("dplyr")

# Load in the datasets
imdb_movies <- read.csv("data/IMDb movies.csv", stringsAsFactors = FALSE)
imdb_ratings <- read.csv("data/IMDb ratings.csv", stringsAsFactors = FALSE)

movies_platforms <- read.csv(
  "data/MoviesOnStreamingPlatforms_updated.csv",
  stringsAsFactors = FALSE
)

imdb_top_1000 <- read.csv("data/imdb_top_1000.csv", stringsAsFactors = FALSE)

# Filter out unnecessary columns from data sets
## We want:
## imdb_movies: imdb_title_id, original_title, date_published, genre,
##              duration, description

imdb_movies <- imdb_movies %>%
  select(
    "imdb_title_id",
    "original_title",
    "date_published",
    "genre",
    "duration",
    "description"
  )

## imdb_ratings: imdb_title_id, weighted_average_vote, total_votes, mean_vote,
##               allgenders_0age_avg_vote, allgenders_0age_votes,
##               allgenders_18age_avg_vote, allgenders_18age_votes,
##               allgenders_30age_avg_vote, allgenders_30age_votes,
##               allgenders_45age_avg_vote, allgenders_45age_votes
imdb_ratings <- imdb_ratings %>%
  select(
    "imdb_title_id",
    "weighted_average_vote",
    "total_votes",
    "mean_vote",
    "allgenders_0age_avg_vote",
    "allgenders_0age_votes",
    "allgenders_18age_avg_vote",
    "allgenders_18age_votes",
    "allgenders_30age_avg_vote",
    "allgenders_30age_votes",
    "allgenders_45age_avg_vote",
    "allgenders_45age_votes"
  )

## movies_platforms: Movie, Netflix, Hulu, Prime.Video, Disney.
movies_platforms <- movies_platforms %>%
  select(
    "Movie",
    "Netflix",
    "Hulu",
    "Prime.Video",
    "Disney."
  )

## imdb_top_1000: Movie, Certificate, Genre, Meta_score, Poster_Link
imdb_top_1000 <- imdb_top_1000 %>%
  select(
    "Movie",
    "Certificate",
    "Genre",
    "Meta_score",
    "Poster_Link"
  )

# Join imdb_movies and imdb_ratings on "imdb_title_id"
imdb_movies_ratings <- merge(imdb_movies, imdb_ratings, by = "imdb_title_id")

# Join movies_platform and imdb_movies_ratings on "Movie"(x)
# and "original title"(y)
movies_ratings_platforms <- merge(movies_platforms,
  imdb_movies_ratings,
  by.x = "Movie",
  by.y = "original_title"
)

# Join movies_ratings_platforms and imdb_top_1000 on "Movie"
merged_df <- merge(movies_ratings_platforms,
  imdb_top_1000,
  by = "Movie"
)

# Remove na values
movies_ratings_platforms <- na.omit(movies_ratings_platforms)
merged_df <- na.omit(merged_df)

# Save the dataframes into .csv files
write.csv(movies_ratings_platforms,
  "data/movies_ratings_platforms.csv",
  row.names = FALSE
)

write.csv(merged_df,
  "data/movies_ratings_platforms_top1000.csv",
  row.names = FALSE
)
