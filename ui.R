
library(shinydashboard)
library(shinythemes)

# Use a fluid Bootstrap layout
fluidPage(theme = shinytheme("spacelab"),
          fluidRow(
  column(11,div(style = "height:50px;width:700px",align= "left",
                width="100%",titlePanel("India Census 2011")
  )),
  
  column(1,div(style = "height:50px;width:40px",align= "right",
               width="100%", img(src = "indiaimg1.png", height = 50, width = 80, align="left")
  ))
),

  navbarPage("", 
             tabPanel("Bar plot", 
  
  # Give the page a title
  titlePanel(""),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("parameters", "Select parameter: ", 
                  choices= c("Crimes reported" = "Crimes.reported",
                             "Population(millions)" = "Population.millions." ,
                             "Area(sq km)" = "Area.sqkm.",
                             "Population density" = "Population.density.per.sq.km.",
                             "Literacy rate(%)" = "Literacy.Rate.in.percent",
                             "Urban population(%)" = "Percentage.of.Urban.Population.to.total.Population",
                             "Sex ratio" = "Sex.Ratio")
                             ),
      hr(), 
      selectInput("states", "Choose states:",choices= state_data$Name,selected = "Kerala",multiple = TRUE),
      h6(strong("Powered by:")),
      tags$img(src="RStudio-Ball.png", height = 50, width =50),
      helpText("Data is from 2011 census")
    ), 
    mainPanel(h4(textOutput("caption", container=span)),
      plotOutput("barchart",height="400px")  
    )
    )),
  tabPanel("Chloropleth", 
           sidebarLayout(
             sidebarPanel(
               radioButtons("feature", "Choose the parameter to be displayed on the map:", choices=c("Crimes reported" = "Crimes.reported",
                                                                                                     "Population(millions)" = "Population.millions." ,
                                                                                                     "Area(sq km)" = "Area.sqkm.",
                                                                                                     "Population density" = "Population.density.per.sq.km.",
                                                                                                     "Literacy rate(%)" = "Literacy.Rate.in.percent",
                                                                                                     "Urban population(%)" = "Percentage.of.Urban.Population.to.total.Population",
                                                                                                     "Sex ratio" = "Sex.Ratio"), selected = "Area.sqkm." )
                 
               ),
             mainPanel(h4(textOutput("caption1", container=span)),
               plotOutput("chloropleth")
             )
               
             )
             
           )
    
  ))