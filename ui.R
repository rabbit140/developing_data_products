library(shiny)

shinyUI(fluidPage(
      
      titlePanel(strong("San Francisco crime analysis")),
      
      sidebarLayout(
            sidebarPanel(
                  selectInput("district", label = h3("Select a district (1, 2, 4)"), 
                              choices = list("Bayview" = "BAYVIEW", "Central" = "CENTRAL", "Ingleside" = "INGLESIDE", 
                                             "Mission" = "MISSION", "Northern" = "NORTHERN", "Park" = "PARK",
                                             "Richmond" = "RICHMOND", "Southern" = "SOUTHERN", 
                                             "Taraval" = "TARAVAL", "Tenderloin" = "TENDERLOIN")),
                  selectInput("year", label = h3("Select a year (1, 2, 3)"),
                              choices = list("2003" = 2003, "2004" = 2004, "2005" = 2005, "2006" = 2006, 
                                             "2007" = 2007, "2008" = 2008, "2009" = 2009, "2010" = 2010,
                                             "2011" = 2011, "2012" = 2012, "2013" = 2013, "2014" = 2014,
                                             "2015" = 2015)),
                  selectInput("weekday", label = h3("Select day of week (3, 4)"),
                              choices = list("Monday" = "Monday", "Tuesday" = "Tuesday", "Wednesday" = "Wednesday",
                                             "Thursday" = "Thursday", "Friday" = "Friday", "Saturday" = "Saturday",
                                             "Sunday" = "Sunday")),
                  actionButton("execute", "Execute"),
                  hr(),
                  h4(strong("INSTRUCTIONS:")),
                  hr(),
                  (strong("Initial loading takes a while, please wait.")),
                  hr(),
                  ("The numbers in brackets indicate tabs where each setting applies"),
                  hr(),
                  ("To apply selection, press 'Execute'")
                  ),
            mainPanel(
                  tabsetPanel(
                        tabPanel("Resolution", plotOutput("resolution_bar", height = 600), icon = icon("bar-chart")),
                        tabPanel("Top categories", plotOutput("top_categories", height = 600), icon = icon("bar-chart")),
                        tabPanel("Hourly reports", plotOutput("hourly_reports", height = 600), icon = icon("bar-chart")),
                        tabPanel("Density", plotOutput("year_density", height = 600), icon = icon("map-o")),
                        tabPanel("The nitty-gritty", htmlOutput("nitty"))
                        )
                        
                  )
            )
      )
)