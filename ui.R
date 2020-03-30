library(plotly)
navbarPage(
	"IPEDS Peer Comparison Dashboard",
	tabPanel(
		"Dashboard",
		
		tags$img(
			src = "GitHub-Mark-120px-plus.png",
			width = "20px",
			height = "20px"),
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
					selectInput('plotType', 'Plot type', c("Bar", "Column", "Line") ),
					
					
					selectInput('colorScheme', 
											list('Color scheme', 
												
													 tipify(img(src = "tooltip_icon.png", width = "12px", height = "12px"),
													 			 'These color schemes provide color maps that are perceptually uniform in both color and black-and-white. They are also designed to be perceived by viewers with common forms of color blindness. Learn more <a href="https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html#introduction">here</a>.',
													 			 trigger = "click", placement = "right"
													 			 )),
											
											c("Cividis", "Inferno", "Magma", "Plasma", "Viridis") ),
					
					# selectInput('colorScheme', 'Color scheme', c("Cividis", "Inferno", "Magma", "Plasma", "Viridis") ),
					# tags$img(
					# 	src = "tooltip_icon.png",
					# 	width = "10px",
					# 	height = "10px"),
					# bsTooltip("colorScheme", "These color schemes provide color maps that are perceptually uniform in both color and black-and-white. They are also designed to be perceived by viewers with common forms of color blindness.",
					# 					"right", options = list(container = "body")),
					
					
					checkboxInput("showTable", "Show data under plot"),
					sliderInput("size", "Text size", min = 6, max = 50, value = 16, step = 1,round = T)
				),
				
				
				column(width = 9,
							 plotlyOutput("plot"))
				
			),
			
			
			
			fluidRow(column(
				width = 9,
				downloadButton('downloadChartData', 'Download chart data'),
				br(),
				DT::dataTableOutput("plotData"),
				offset = 3
			))
			
		)
		
		
	),
	
	tabPanel(
		"View and download all data",
		tags$img(
			src = "GitHub-Mark-120px-plus.png",
			width = "20px",
			height = "20px"
		),
		tags$a(href = "https://github.com/jrf1111/IPEDS-peer-comparison-shiny", "Click here for the GitHub repo"),
		hr(),
		downloadButton('downloadData', 'Download all data'),
		br(),
		br(),
		DT::dataTableOutput("table1")
		
	)
	
)
