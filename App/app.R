# Austin Wilkins
# March 7, 2022

# Libraries
#library(tidyverse)
library(lubridate)
library(shiny)
library(data.table)
library(ggthemes)
library(dplyr)
library(ggplot2)

options(scipen = 10)

df <- fread("df.csv")
yearly <- fread("yearly.csv")

#Functions

#   # basic count plot
termPlot <- function(x){
  df %>% 
    select(Year,x) %>%
    rename('n'= x) %>%
    group_by(Year) %>%
    summarize(n=sum(n)) %>%
    inner_join(yearly)
}

#   # Ratio of words to total words
ratioPlot <- function(x){
  df %>% 
    select(Year,x) %>%
    rename('n'= x) %>%
    group_by(Year) %>%
    summarize(n=sum(n)) %>%
    inner_join(yearly) %>% 
    mutate(n = n/Total)
} 


ui <- fluidPage(


    titlePanel("New York Times Obituaries"),

    
    sidebarLayout(
        sidebarPanel(
          selectInput("textInput", "Select a word", names(df[1,5:(length(df)-2)])),
          selectInput("y", "Y axis", c("rate", "count")),
          tableOutput('table1')
        ),

        mainPanel(
           plotOutput("plot1"),
           plotOutput("plot2")
        )
    )
)



server <- function(input, output, session) {


  plotObj <- reactive({
    if (input$y == "count") {
      termPlot(input$textInput)
    } else {
      ratioPlot(input$textInput)
    }
  })

  output$table1 <- renderTable({
    plotObj()
  }) 
  
  
  
  
  # Reference Plot
  output$plot1 <- renderPlot({
    df %>% 
      ggplot(aes(x=Year))+
      geom_bar()+
      labs(title='NYT Obituaries per Year')+
      theme_fivethirtyeight()
  })
  
  # Changing term plot
  output$plot2 <- renderPlot({
    plotObj() %>% 
      ggplot(aes(x=Year,y=n))+
      geom_col()+
      geom_smooth(se=F,method='lm')+
      theme_fivethirtyeight()
  })

}

# Run the application 
shinyApp(ui = ui, server = server)
