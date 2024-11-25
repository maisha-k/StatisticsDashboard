library(shiny)
library(ggplot2)
library(shinythemes)

# Define UI for the statistical distributions teaching app
ui <- fluidPage(
  theme = shinytheme("darkly"), #My favorite because the tab turns green when you click on it 
  titlePanel("Probability Distributions Dashboard"), 
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    sidebarPanel(
      radioButtons("dist", "Distribution Type:",
                   choices = c("Normal" = "norm",
                               "Uniform" = "unif",
                               "Exponential" = "exp",
                               "Poisson" = "pois",
                               "Binomial" = "binom",
                               "Geometric" = "geom", 
                               "Hypergeometric" = "hypergeom")),
      uiOutput("param_ui"),  # Dynamic UI for parameters
      br(),
      actionButton("view_code", "View Source Code"),
      downloadButton("download_code", "Download Source Code")
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Help",
                           h3("How to Use This Dashboard"),
                           p("Select a distribution from the list and adjust the parameters to see its effects on the distribution plot."),
                           p("Each distribution has different characteristics; use the 'Distribution Details' tab to learn more about each one."),
                           p("The 'Summary Statistics' tab provides statistical details about the sampled data."),
                           h3("Why Learn About Probability Distributions"),
                           p("Probability distributions give us a way to describe and understand random processes, like rolling a die, measuring people's heights, or counting customers arriving at a store."),
                           p("Each distribution has its own formula that tells us the likelihood of different outcomes. If we know that a random process follows one of these distributions, we can use that formula to make predictions and analyze the data."),
                           p("This is a big deal for statisticians because it means we can model real-world situations more easily, helping us make informed decisions, spot patterns, and understand the world around us.")),
                  
                  tabPanel("Plot", plotOutput("distPlot")),
                  tabPanel("Distribution Details", verbatimTextOutput("details")),
                  tabPanel("Summary Statistics", verbatimTextOutput("summary"))
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Define UI for distribution-specific parameters
  output$param_ui <- renderUI({
    switch(input$dist,
           norm = list(
             sliderInput("mean", "Mean:", min = -10, max = 10, value = 0),
             sliderInput("sd", "Standard Deviation:", min = 0.1, max = 10, value = 1)
           ),
           unif = list(
             sliderInput("min", "Minimum:", min = -10, max = 0, value = 0),
             sliderInput("max", "Maximum:", min = 0, max = 10, value = 1)
           ),
           binom = list(
             sliderInput("size", "Number of Trials:", min = 1, max = 100, value = 10),
             sliderInput("prob", "Probability of Success:", min = 0, max = 1, value = 0.5)
           ),
           pois = sliderInput("lambda", "Lambda:", min = 0, max = 10, value = 1),
           exp = sliderInput("rate", "Rate:", min = 0.1, max = 10, value = 1),
           hypergeom = list(
             sliderInput("m", "Number of Success States:", min = 0, max = 100, value = 1),
             sliderInput("k", "Number of Trials:", min = 0, max = 100, value = 1),
             sliderInput("N", "Population Size:", min = 0, max = 100, value = 1)
           ),
           geom = sliderInput("prob_geom", "Probability of Success:", min = 0.01, max = 1, value = 0.5) 
    )
  })
  
  # Reactive function for generating data based on selected distribution
  data <- reactive({
    switch(input$dist,
           norm = rnorm(500, mean = input$mean, sd = input$sd),
           unif = runif(500, min = input$min, max = input$max),
           binom = rbinom(500, size = input$size, prob = input$prob),
           pois = rpois(500, lambda = input$lambda),
           exp = rexp(500, rate = input$rate),
           hypergeom = rhyper( nn = 500, m = input$m, n = input$N , k = input$k),
           geom = rgeom(500, prob = input$prob_geom)) 
    
  })
  
  # Plot distribution
  output$distPlot <- renderPlot({
    ggplot(data.frame(x = data()), aes(x)) +
      geom_histogram(aes(y = ..density..), bins = 100, fill = "#89c4ff", color = "#004589", alpha = 0.9) +
      labs(title = paste(switch(input$dist,
                                norm = "Normal",
                                unif = "Uniform",
                                binom = "Binomial",
                                pois = "Poisson",
                                exp = "Exponential",
                                hypergeom = "Hypergeometric", 
                                geom = "Geometric"), 
                         "Distribution"),
           x = "", 
           y = "") +
      theme_minimal(base_size = 15) +
      theme(
        plot.background = element_rect(fill = "#3e3e46", color = NA),
        panel.background = element_rect(fill = "#3e3e46", color = NA),
        panel.grid.major = element_line(color = "#71696c"),
        panel.grid.minor = element_line(color = "#71696c"),
        plot.title = element_text(color = "white", face = "bold", size = 18, hjust = 0.5),
        axis.title.x = element_text(color = "white", size = 14),
        axis.title.y = element_text(color = "white", size = 14),
        axis.text = element_text(color = "white")
      )
    
  })
  
  # Display distribution details 
  output$details <- renderPrint({
    dist_info <- switch(input$dist,
                        norm = list(
                          "The normal distribution is also known as the Gaussian distribution",
                          " It is a continuous probability distribution characterized by its symmetric bell-shaped curve.",
                          "It is defined by two parameters: the mean (μ) and the standard deviation (σ).",
                          "The mean tells us the center of the distribution and the standard deviation tells us the spread.",
                          "The probability density function (PDF) is given by: f(x) = (1 / (σ√(2π))) *e^(((x - μ) / σ)^2).",
                          "For more information, visit: https://www.probabilitycourse.com/chapter4/4_2_3_normal.php " 
                        ),
                        unif = list(
                          "The uniform distribution is a continuous probability distribution.", 
                          " It it characterized by all outcomes being equally likely within a specified range.",
                          "It is defined by two parameters: the minimum (a) and maximum (b) values.",
                          "The probability density function (PDF) is: f(x) = 1 / (b - a) for a ≤ x ≤ b.",
                          "For more information, visit: https://www.probabilitycourse.com/chapter4/4_2_1_uniform.php"
                        ),
                        exp = list(
                          "The exponential distribution is a continuous probability distribution.",
                          " Itis often used to model time elapsed between events.",
                          "It is defined by the rate parameter (λ), which is the inverse of the mean.",
                          "The probability density function (PDF) is: f(x) = λ * exp(-λx) for x ≥ 0.",
                          "For more information, visit:https://www.probabilitycourse.com/chapter4/4_2_2_exponential.php"
                        ),
                        pois = list(
                          "The Poisson distribution is a discrete probability distribution.",
                          " It is often used to count occurences in a fixed interval of time or space.",
                          "It is defined by the rate parameter (λ), which is the expected number of events in the interval.",
                          "The probability mass function (PMF) is: P(X = k) = (λ^k * exp(-λ)) / k! for k = 0, 1, 2, ....",
                          "For more information, visit: https://www.probabilitycourse.com/chapter3/3_1_5_special_discrete_distr.php"
                        ),
                        binom = list(
                          "The binomial distribution is a discrete probability distribution.",
                          "It models the number of successes in a fixed number of independent Bernoulli trials, each with the same probability of success.",
                          "It is defined by two parameters: the number of trials (n) and the probability of success (p).",
                          "The probability mass function (PMF) is: P(X = k) = (n choose k) * p^k * (1 - p)^(n - k) for k = 0, 1, 2, ..., n.",
                          "For more information, visit: https://www.probabilitycourse.com/chapter3/3_1_5_special_discrete_distr.php"
                        ),
                        geom = list(
                          "The geometric distribution is a discrete probability distribution.",
                          " It models the number of trials needed to get the first success in a series of independent Bernoulli trials.",
                          "It is defined by the probability of success (p) in each trial.",
                          "The probability mass function (PMF) is: P(X = k) = (1 - p)^(k - 1) * p for k = 1, 2, 3, ....",
                          "This distribution is used in reliability analysis and modeling the number of attempts required for a success.",
                          "For more information, visit: https://www.probabilitycourse.com/chapter3/3_1_5_special_discrete_distr.php"
                        ),
                        hypergeom = list(
                          "The hypergeometric distribution is a discrete probability distribution.", 
                          "It describes the probability of k successes in n draws from a finite population of size N containing K successes, without replacement.",
                          "It is defined by three parameters: population size (N), number of successes in the population (K), and number of draws (n).",
                          "The probability mass function (PMF) is: P(X = k) = [ (K choose k) * (N - K choose n - k) ] / (N choose n) for max(0, n + K - N) ≤ k ≤ min(K, n).",
                          "For more information, visit: https://www.probabilitycourse.com/chapter3/3_1_5_special_discrete_distr.php"
                        )
    )
    
    
    dist_info
  })
  
  # Display summary statistics
  output$summary <- renderPrint({
    summary(data())
  })
  
  # Display the source code in a modal
  observeEvent(input$view_code, {
    showModal(modalDialog(
      title = "Source Code for app.R",
      verbatimTextOutput("code_content"),
      easyClose = TRUE,
      size = "l", 
      footer = modalButton("Close"),
      style = "max-height: 600px; overflow-y: auto;" 
    ))
  })
  
  output$code_content <- renderText({
    paste(readLines("app.R"), collapse = "\n") 
  })
  
  # Download handler for source code
  output$download_code <- downloadHandler(
    filename = "app.R",
    content = function(file) {
      file.copy("app.R", file)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
