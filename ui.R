library(plotly)
navbarPage("IPEDS Peer Comparison Dashboard",
					 tabPanel("Dashboard",
					 				 sidebarLayout(sidebarPanel(
					 				 	selectInput('x', 'Variable', sort(unique(mdata$Question))),
					 				 	sliderInput("size", "Text size", min = 6, max = 50, value = 16, step = 1, round = T)
					 				 ),
					 				 mainPanel(
					 				 	plotlyOutput("plot"))
					 				 ),
					 				 
					 				 hr(),
					 				 tags$img(src = "GitHub-Mark-120px-plus.png", width = "20px", height = "20px"),
					 				 tags$a(href="https://github.com/jrf1111/IPEDS-peer-comparison-shiny", "Click here for the GitHub repo")
					 				 
					 				 ),
					 
					 tabPanel("View and download data",
					 				 downloadButton('downloadData', 'Download'),
					 				 DT::dataTableOutput("table1"),
					 				 
					 				 hr(),
					 				 tags$img(src = "GitHub-Mark-120px-plus.png", width = "20px", height = "20px"),
					 				 tags$a(href="https://github.com/jrf1111/IPEDS-peer-comparison-shiny", "Click here for the GitHub repo")
					 				 
					 )
)
