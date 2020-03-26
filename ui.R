library(plotly)
navbarPage("IPEDS Peer Comparison Dashboard",
					 tabPanel("All Data",
					 				 downloadButton('downloadData', 'Download'),
					 				 DT::dataTableOutput("table1")), 
					 
					 tabPanel("Dashboard",
					 				 sidebarLayout(sidebarPanel(
					 				 	selectInput('x', 'Variable', sort(unique(mdata$Question))),
					 				 	sliderInput("size", "Text size", min = 6, max = 50, value = 16, step = 1, round = T)
					 				 ),
					 				 mainPanel(
					 				 	plotlyOutput("plot"))
					 				 ))
)
