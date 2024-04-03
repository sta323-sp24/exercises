library(shiny)
library(tidyverse)

library(thematic)

thematic::thematic_shiny()

shinyApp(
  ui = fluidPage(
    theme = bslib::bs_theme(version=5, preset="flatly"),
    title = "Beta-binomial simulation",
    titlePanel("Beta-binomial simulation"),
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        h4("Data"),
        sliderInput("x", "# of heads (successes)", min=0, max=100, value=7),
        sliderInput("n", "# of flips (trials)", min=1, max=100, value=10),
        h4("Prior"),
        numericInput("a", "Prior # of heads", min=0, value=5),
        numericInput("b", "Prior # of tails", min=0, value=5),
        h4("Options"),
        checkboxInput("show", "Show options", value = TRUE),
        conditionalPanel(
          "input.show == true",
          checkboxInput("bw", "Use theme_bw", value = FALSE),
          checkboxInput("facet", "Facet density plots", value = FALSE)
        )
      ),
      mainPanel = mainPanel(
        plotOutput("plot"),
        tableOutput("table")
      )
    )
  ),
  server = function(input, output, session) {
    bslib::bs_themer()
    
    observe({
      updateSliderInput(session, "x", max = input$n)
    })
    
    df = reactive({
      req(input$a)
      
      validate(
        need(input$a > 0, "# of prior heads needs to be greater than 0."),
        need(input$b > 0, "# of prior tails needs to be greater than 0."),
        need(input$b, "# of prior tails needs to be defined.")
      )
      
      tibble(
        p = seq(0,1, length.out = 1001)
      ) |>
        mutate(
          prior = dbeta(p, input$a, input$b),
          likelihood = dbinom(input$x, input$n, p) %>%
            {. / (sum(.)/ n())},
          posterior = dbeta(p, input$a + input$x, input$b + input$n - input$x)
        ) |>
        pivot_longer(
          cols = -p, names_to = "distribution", values_to = "density"
        ) |>
        mutate(
          distribution = as_factor(distribution)
        )
    })
    
    output$plot = renderPlot({
      g = ggplot(df(), aes(x=p, y=density, color=distribution)) +
        geom_line(size=1.5) +
        geom_ribbon(aes(ymax=density, fill=distribution), ymin=0, alpha=0.5)
      
      if (input$bw) {
        print("Here!")
        g = g + theme_minimal()
      }
      
      if (input$facet) {
        g = g + facet_wrap(~distribution)
      }
      
      g
    })
    
    output$table = renderTable({
      df() |>
        group_by(distribution) |>
        summarize(
          mean = sum(p*density) / n(),
          median = p[(cumsum(density/n())) >= 0.5][1],
          q025 = p[(cumsum(density/n())) >= 0.025][1],
          q975 = p[(cumsum(density/n())) >= 0.975][1]
        )
      
    })
  }
)

