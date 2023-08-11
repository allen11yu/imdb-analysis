library("shiny")
library("shinyjs")
library("dplyr")
library("ggplot2")
library("plotly")
library("stringr")

server <- function(input, output, session) {
  # Output the first image for the overview page
  output$first_image <- renderImage({
    return(
      list(
        src = "images/movies_netflix.jpeg",
        filetype = "image/jpeg",
        alt = "Example of Netflix movies page",
        height = "88%",
        width = "88%"
      )
    )
  })

  # Output the second image for the overview page
  output$my_image <- renderImage({
    return(list(
      src = "images/Kaggle_logo.png",
      filetype = "image/png",
      alt = "This is the kaggle logo"
    ))
  })

  # Output the recommended movies for "Find by Genre" interactive page
  output$movies <- renderUI({

    # Find top 5 movies based on the user selected genre
    rec_df <- movies %>%
      filter(
        duration > input$length_choice[1],
        duration < input$length_choice[2]
      ) %>%
      filter(grepl(input$genre_choice, genre)) %>%
      arrange(-weighted_average_vote) %>%
      top_n(5) %>%
      select(Movie, Poster_Link)

    rec_list <- rec_df %>%
      pull(Movie)

    poster_list <- rec_df %>%
      pull(Poster_Link)

    ## Create 5 movies containers (div)
    div_1 <- tags$div(
      id = "movie1",
      class = "movie",
      tags$img(
        class = "center",
        src = poster_list[1]
      ),
      tags$p(rec_list[1])
    )

    div_2 <- tags$div(
      id = "movie2",
      class = "movie",
      tags$img(
        class = "center",
        src = poster_list[2]
      ),
      tags$p(rec_list[2])
    )

    div_3 <- tags$div(
      id = "movie3",
      class = "movie",
      tags$img(
        class = "center",
        src = poster_list[3]
      ),
      tags$p(rec_list[3])
    )

    div_4 <- tags$div(
      id = "movie4",
      class = "movie",
      tags$img(
        class = "center",
        src = poster_list[4]
      ),
      tags$p(rec_list[4])
    )

    div_5 <- tags$div(
      id = "movie5",
      class = "movie",
      tags$img(
        class = "center",
        src = poster_list[5]
      ),
      tags$p(rec_list[5])
    )

    tagList(div_1, div_2, div_3, div_4, div_5)
  })

  # A function that navigate to "Platform Checker" page when user clicked
  # on a movie and checks if that movie is on any of the platform
  check <- function(index) {
    updateNavbarPage(session, "navbar", selected = "checker")

    rec_list <- movies %>%
      filter(
        duration > input$length_choice[1],
        duration < input$length_choice[2]
      ) %>%
      filter(grepl(input$genre_choice, genre)) %>%
      arrange(-weighted_average_vote) %>%
      top_n(5) %>%
      pull(Movie)

    mname <- rec_list[index]
    updateSelectInput(session,
      "mname_choice",
      label = "Choose or enter a Movie Name",
      choices = movies$Movie,
      selected = mname
    )
  }

  # Event listener when user clicks on one of the movies
  observe({
    onclick("movie1", check(1))
    onclick("movie2", check(2))
    onclick("movie3", check(3))
    onclick("movie4", check(4))
    onclick("movie5", check(5))
  })

  # Output the bar chart for the "Platform Checker" interactive page
  output$platform <- renderPlot({
    movie_info <- movies %>%
      filter(Movie == input$mname_choice) %>%
      select(Netflix, Hulu, Prime.Video, Disney.)

    plot_df <- data.frame(
      availability = NA,
      platform = NA
    )

    col_names <- colnames(movie_info)

    for (name in col_names) {
      if (movie_info[name] == 1) {
        plot_df <- rbind(plot_df, c("On", name))
      } else {
        plot_df <- rbind(plot_df, c("Not On", name))
      }
    }
    plot_df <- plot_df[-1, ]

    barchart <- ggplot(data = plot_df) +
      geom_bar(
        mapping = aes(x = platform, y = availability),
        width = 0.5,
        stat = "identity",
        fill = "steelblue"
      ) +
      ggtitle(paste("Which platform supports the movie:", input$mname_choice)) +
      xlab("Platforms") +
      ylab("Status") +
      theme(plot.title = element_text(hjust = 0.5))

    return(barchart)
  })

  # Helper function to return pop genre/year plot that finds the
  # most popular genre of every year
  plot_pop_genres <- function(year1, year2) {
    most_pop_year <- movies_large %>%
      group_by(years) %>%
      mutate(all_gen = strsplit(as.character(genre), ",")) %>%
      unnest(all_gen) %>%
      mutate(all_gen = str_trim(all_gen)) %>%
      count(all_gen) %>%
      # filter by year option
      filter(years <= year2, years >= year1) %>%
      top_n(1)

    f <- list(
      family = "Courier New, monospace",
      size = 18,
      color = "#7f7f7f"
    )
    x <- list(
      title = "Year",
      titlefont = f
    )
    y <- list(
      title = "Genres",
      titlefont = f
    )

    fig <- plot_ly(
      data = most_pop_year,
      type = "scatter",
      mode = "markers",
      x = ~years, y = ~all_gen,
      hoverinfo = "text",
      text = ~ paste(
        "</br> Year:", years,
        "</br> Most popular movie genre:", all_gen
      )
    )

    fig <- fig %>% layout(
      title = paste("Most popular genres from", year1, "to", year2),
      xaxis = x,
      yaxis = y
    )

    return(fig)
  }

  # Output the plot for the "Most popular genres by year" interactive page
  output$years <- renderPlotly({
    plot_pop_genres(input$year_choice[1], input$year_choice[2])
  })

  # Output the second plot on the summary page
  output$years_60_90 <- renderPlotly({
    # find most popular genre of every year
    plot_pop_genres(1960, 1990)
  })

  # Output the movie information for the "Platform Checker" interactive page
  output$summary <- renderUI({
    movie_info <- movies %>%
      filter(Movie == input$mname_choice) %>%
      filter(row_number() == 1) %>%
      select(
        Movie, date_published, genre, duration,
        description, weighted_average_vote
      )

    name_div <- tags$div(
      id = "mname",
      tags$h2(input$mname_choice)
    )

    des_div <- tags$div(
      id = "des",
      tags$h3("Description:"),
      tags$p(movie_info$description)
    )

    dur_div <- tags$div(
      id = "dur",
      tags$h3("Duration (minutes):"),
      tags$p(movie_info$duration)
    )

    genre_div <- tags$div(
      id = "gen",
      tags$h3("Genre:"),
      tags$p(movie_info$genre)
    )

    release_div <- tags$div(
      id = "release",
      tags$h3("Release Date:"),
      tags$p(movie_info$date_published)
    )

    vote_div <- tags$div(
      id = "vote",
      tags$h3("Average Vote:"),
      tags$p(movie_info$weighted_average_vote)
    )

    misc_div <- tags$div(
      id = "misc",
      dur_div,
      genre_div,
      release_div,
      vote_div
    )

    whole_div <- tags$div(
      id = "sumdiv",
      name_div,
      des_div,
      misc_div
    )
    whole_div
  })

  # Output the third graph for the summary page
  output$most_least_platform <- renderDataTable({
    # data for movie platform
    netflix_count <- sum(popular_platform$Netflix == 1)
    hulu_count <- sum(popular_platform$Hulu == 1)
    primevideo <- sum(popular_platform$Prime.Video == 1)
    disney_count <- sum(popular_platform$Disney. == 1)

    platform <- c("Netflix", "Hulu", "Prime Video", "Disney")
    numberofmovie <- c(
      netflix_count,
      hulu_count,
      primevideo,
      disney_count
    )
    platform_rating <- data.frame(platform, numberofmovie)
    top_platform <- platform_rating %>%
      arrange(-numberofmovie)

    top_platform
  })

  # Output the first graph for the summary page
  output$genre_example <- renderDataTable({
    genre_example <- movies %>%
      select(genre) %>%
      slice(33:37)
    genre_example
  })
}
