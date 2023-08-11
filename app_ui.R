library("shiny")
library("tidyr")
library("stringr")
library("lubridate")
library("dplyr")
library("plotly")

movies <- read.csv("data/movies_ratings_platforms_top1000.csv",
  stringsAsFactors = FALSE
)
popular_platform <- read.csv("data/MoviesOnStreamingPlatforms_updated.csv",
  stringsAsFactors = FALSE
)

# Code for the overview page
intro_page <- tabPanel(
  title = "Introduction",
  mainPanel(
    h4("Purpose"),
    p("Recommendation systems are a relatively new occurrence that have become
      a necessity when using modern day media platforms. One of the most famous
      examples of this is movie recommendations, present on a variety of video
      streaming services such as Netflix, Hulu and HBO. As students interested
      in data science and the applications thereof, as well as being avid
      consumers of movies ourselves, we would like to see how we would develop
      our own movie recommendation program."),
    imageOutput("first_image"),
    h4("Data"),
    p("Our main datasets were from the Internet Movie Database (IMDb):
      IMDb movies.csv, and IMDb ratings.csv. These datasets were found on
      Kaggle."),
    h4("List of Data"),
    p(
      "#1: This dataset is a collection scraped from the Internet Movie
      Database (IMDb). It contains movie titles, year of production, overview,
      IMDb/rotten tomatoes ratings, and availability on various streaming
      services. We use this data to find which streaming platform
      (e.g. Netflix, Prime Video, Disney+) a movie can be found.",
      a(
        href = paste0(
          "https://www.kaggle.com/ruchi798/",
          "movies-on-netflix-prime-video-hulu-and-disney"
        ),
        "Data hosted by Ruchi Bhatia"
      )
    ),
    p(
      "#2: The data was scraped from a popular movie dataset called IMDb. It
       consists of movie names, their ratings and background information.
       Joining this movies dataset with streaming services could show us
       the availability of movies on different platforms.",
      a(
        href = paste0(
          "https://www.kaggle.com/stefanoleone992/",
          "imdb-extensive-dataset"
        ),
        "Data hosted by Stefano Leone"
      )
    ),
    p(
      "#3: The data was found from the IMDb database. It consists of movie
       titles, release dates, genres, ratings, and background information. This
       dataset contains basic information about each movie, such as IMDb
       ratings, genres, and runtimes. All of these factors are helpful in movie
       recommendation when providing basic information about the movie to the
       users. Moreover, by knowing the genre and rating, we can create
      averages to find which genres are more popular.",
      a(
        href = paste0(
          "https://www.kaggle.com/harshitshankhdhar/",
          "imdb-dataset-of-top-1000-movies-and-tv-shows"
        ),
        "Data hosted by Harshit Shankhdhar"
      )
    ),
    p("We cleaned and joined these files
      together to create the two datasets used in the project. Our datasets
      contained various movie information used for the interactive pages
      (e.x movie name, genre, rating) and whether or not the movie was available
      on streaming platforms."),
    imageOutput("my_image")
  )
)


# Code for the "Find by Genre" interactive page

# Vector of Genres
sep_genre <- movies %>%
  mutate(all_gen = strsplit(as.character(genre), ",")) %>%
  unnest(all_gen)

sep_genre$all_gen <- str_trim(sep_genre$all_gen)
all_genres <- unique(sep_genre$all_gen)

# Range of times (in minutes)
movie_lengths <- range(movies$duration)

# Genre input options for sidebar
genre_input <- selectInput(
  inputId = "genre_choice",
  label = "Choose a Movie Genre",
  choices = all_genres,
  selected = "Drama"
)

# Slider option for length on sidebar
length_input <- sliderInput(
  inputId = "length_choice",
  label = "Length (in minutes)",
  min = movie_lengths[1],
  max = movie_lengths[2],
  value = movie_lengths
)

# Code for the "Most popular genres by year" interactive page"

movies_large <- read.csv("data/movies_ratings_platforms.csv",
  stringsAsFactors = FALSE
)
movies_large$years <- str_sub(movies_large$date_published, 1, 4)

# Range of years of movies used for scatter plot on second page
all_years <- as.integer(range(movies_large$years))

year_input <- sliderInput(
  inputId = "year_choice",
  label = "Adjust to change year range",
  min = all_years[1],
  max = all_years[2],
  value = all_years
)

# Code for "Platform Checker" interactive page

# Input the movie name
mname_input <- selectInput(
  inputId = "mname_choice",
  label = "Choose or enter a Movie Name",
  choices = movies$Movie
)

# UI Code

# Side bar allows user to select genre and movie length
page_one <- tabPanel(
  "Find by Genre",
  sidebarLayout(
    sidebarPanel(
      genre_input,
      length_input
    ),
    # return images of movies and names
    mainPanel(
      uiOutput("movies"),
      h3("Description"),
      p("This side bar allows users to filter by a genre and movie
                duration. The main page then updates the top 5 reccomendations
                based on the inputed data, showing poster images and names
                of the movies. Users can also click on these images to be
                taken to a summary page. This page chooses genre as the best
                input to use when recommending a movie")
    )
  )
)

# Side bar allows user to select year range
page_two <- tabPanel(
  title = "Most popular genres by year",
  sidebarLayout(
    sidebarPanel(
      year_input
    ),
    # return graph of most popular genre over year
    mainPanel(
      plotlyOutput("years"),
      h3("Description"),
      p("This scatterplot displays the most popular genre of each year
                from 1914 to 2020. When hovering, users can see the genre and
                year of popularity. The side bar also allows users to filter
                down to a specific year range. This graph helps us understand
                how the popularity of certain genres, and therefore how a movie
                reccomendation system would have changed over time.")
    )
  )
)

# User can enter movie names and also click images from
# first page for summary info on the movie
page_three <- tabPanel(
  title = "Platform Checker",
  value = "checker",
  sidebarLayout(
    sidebarPanel(
      mname_input
    ),
    mainPanel(
      plotOutput("platform"),
      uiOutput("summary"),
      h3("Description"),
      p("This is a page displaying summary information about a movie, as well
        as what platforms the movie is available on. This data helps users more
        specifically choose a movie after filtering from a genre, and provides
        what streaming service a user needs to access it.")
    )
  )
)

# Used to display example of multiple genre groupings
genre_example <- movies %>%
  select(genre) %>%
  slice(33:37)

# Summary page
page_four <- tabPanel(
  title = "Summary",
  mainPanel(
    h4(" #1 Determining the best sorting for a Movie Recommendation System"),
    p("For user selections, we chose to mainly use a genre dropdown selection.
      In the modern era, because there are so many movies to choose from,
      specifying a genre is important. It's also important to
      note that genres, as can be seen in our raw data, often overlap when
      dealing with actual movie statistics - especially with newer releases.

      (example of multiple genre groupings)"),
    dataTableOutput("genre_example"),
    p("Because many of the movies hadoverlapping genre categories,
      a genre indicator was even more useful
      because it could cover a wider base than if movies only had one specific
      genre paired with the movie. This gives users a more inclusive selection
      of movies to choose form.
      However, this also causes some oddity in
      results as just because a movie includes a type of genre, doesn't mean
      that it's the primary genre or focus of the movie. This could leave users
      disastisfied when receiving reccomendations based on genre, if the overall
      feel of the movie is not what they expected."),
    h4("#2 How Popularity of Genre Could could Effect Films over time"),
    plotlyOutput("years_60_90"),
    p(
      "Since the movie genre is what we analyze in our platform, we created a
      graph that shows the most popular genre in the movie industry over each
      year from 1914 to 2020, which is the range of our dataset. Popularity was
      measured by the amount of times a movie with a specific genre was created
      rather then by rating. This is in part due to the fact that earlier years
      lacked a high number or quality of movies, so the overall theme and want
      for reproduction was more impactful. You can make many notable insights
      from this data such as how the popularity of", strong("Horror"), "and",
      strong("Comedy"), "genres has grown from the year 1960 to 1990. By looking
      at the change of popularity of genres at different times, filmmakers can
      gain insight into the history of popular films, and can see what types of
      movies have been or will be successful. For example, if the number of
      Horror movies increases in 1960, a user (if they had access to this
      program) could infer that people are very into horror movies
      and consider making movies within the horror genre as a result."
    ),
    h4("#3 What to Include in Movie Recommendations"),
    p("In our 'Platform Checker'page, we provide basic information about each
      movie. Users can select or type in a movie,
      and they get movie information, such as duration, genre, release date,
      average vote, and a description of that movie. This helps users specify
      even more what movie to choose, by letting them view summary and ratings.
      Other than this basic information about the movie, we have also analyzed
      and provided details for our users on where to watch the movie they search
      for. We provide four popular platforms: Netflix, Hulu, Prime Video, and
      Disney. The bar chart shows whether a certain movie is on the platform or
      not. You can view the overall distribution of available movies here"),
    dataTableOutput("most_least_platform"),
    p(
      "The table above concludes that", strong("Prime Video"), "offers the most
      movies, whereas", strong("Disney"), "offers least movies. By having this
      table, users know which platform has more movies, and they can create an
      account on that platform rather than other platforms that have fewer
      movies. Addtionally by using our movie summary page, they would know
      specifically what streaming service a movie is available on further
      enabling their choice"
    )
  )
)

ui <- fluidPage(
  useShinyjs(),
  # styles included in separate file
  includeCSS("styles.css"),
  navbarPage(
    title = "Movie Recs",
    id = "navbar",
    intro_page,
    page_one,
    page_two,
    page_three,
    page_four
  )
)
