library(plotly)
navbarPage(
	"IPEDS Peer Comparison Dashboard",
	tabPanel(
		"Dashboard",
		
		tags$img(
			src = "GitHub-Mark-120px-plus.png",
			width = "20px",
			height = "20px"
		),
		tags$a(href = "https://github.com/jrf1111/IPEDS-peer-comparison-shiny", "Click here for the GitHub repo"),
		hr(),
		
		
		fluidPage(
			tags$head(tags$style(
				HTML(
					".plotly { margin-bottom: 200px; }
					 .dataTables_wrapper { margin-bottom: 100px; }"
				)
			)),
			
			
			fluidRow(
				column(
					width = 3,
					selectInput('x', 'Variable', sort(unique(mdata$Question))),
					#selectInput('plotType', 'Plot type', c("Bar", "Column", "Line") ),
					checkboxInput("showTable", "Show data under plot"),
					sliderInput(
						"size",
						"Text size",
						min = 6,
						max = 50,
						value = 16,
						step = 1,
						round = T
					)
				),
				
				
				column(width = 9,
							 plotlyOutput("plot"))
				
			),
			
			
			
			fluidRow(column(
				width = 9,
				DT::dataTableOutput("plotData"),
				offset = 3
			))
			
		)
		
		
	),
	
	tabPanel(
		"View and download data",
		tags$img(
			src = "GitHub-Mark-120px-plus.png",
			width = "20px",
			height = "20px"
		),
		tags$a(href = "https://github.com/jrf1111/IPEDS-peer-comparison-shiny", "Click here for the GitHub repo"),
		hr(),
		downloadButton('downloadData', 'Download'),
		DT::dataTableOutput("table1")
		
	)
	
)
