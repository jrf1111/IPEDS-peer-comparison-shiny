library(plotly)
navbarPage("IPEDS Peer Comparison Dashboard",
					 tabPanel("All Data",
					 				 downloadButton('downloadData', 'Download'),
					 				 DT::dataTableOutput("table1")), 
					 tabPanel("Approvals vs Declines",
					 				 sidebarLayout(sidebarPanel(
					 				 	helpText("The total number of approvals and denials in the following graph, we realize that since 2015, approvals are dwindling.", 
					 				 					 "On the other hand, denials are surging.")),
					 				 	mainPanel(plotlyOutput("plot1"))
					 				 )),
					 tabPanel("Geographic",
					 				 sidebarLayout(sidebarPanel(
					 				 	selectInput('x', 'Variable', sort(unique(mdata$Question))),
					 				 	sliderInput("size", "Text size", min = 6, max = 50, value = 16, step = 1, round = T)
					 				 ),
					 				 mainPanel(
					 				 	plotlyOutput("plot"))
					 				 ))
)
