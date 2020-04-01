#File: ui.R
#Desc: This file is used to define the user interface (UI).  That is, it is responsible 
#      for creating everything the will interact with and see.


#make a page with a top-level navigation bar
navbarPage(
	title = "IPEDS Peer Comparison Dashboard",
	
	#dashboard tab -----
	#first tab/panel is the dashboard
	tabPanel(
		title = "Dashboard",
		
		# ~link to the github repo ----
		a(href = "https://github.com/jrf1111/IPEDS-peer-comparison-shiny", 
			list(img(src = "GitHub-Mark-120px-plus.png", width = "20px", height = "20px"),  #images must be stored in the "www" directory
					 "Click here for the GitHub repo")),
		
		
		hr(), # insert horizontal ruler/line
		
		# ~make a page with a custom layout ----
		fluidPage(
			
			#~~add spacing to plot and data tables ----
			#add custom HTML/CSS code to add space below the chart and the data tables
			tags$head(tags$style(
				HTML(
					".plotly { margin-bottom: 200px; }
					 .dataTables_wrapper { margin-bottom: 100px; }"
				)
			)),
			
			
			# ~~user input ----
			#add a row to the page that is narrow (width = 3) that gets user input
			fluidRow(
				column(
					width = 3, #out of 12
					
					#~~~drop down box to select the variable to be plotted ----
					selectInput('x', 'Variable', sort(unique(mdata$Question))), 
					
					#~~~drop down box to select plot type ----
					selectInput('plotType', 'Plot type', c("Bar", "Column", "Line") ),
					
					
					#~~~drop down to select color scheme ----
					selectInput('colorScheme', 
											list('Color scheme', 
												
													 #add tooltip about the color scheme options
													 tipify(img(src = "tooltip_icon.png", width = "12px", height = "12px"),
													 			 'These color schemes provide color maps that are perceptually uniform in both color and black-and-white. They are also designed to be perceived by viewers with common forms of color blindness. Learn more <a href="https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html#introduction">here</a>.',
													 			 trigger = "click", placement = "right"
													 			 )),
											
											c("Cividis", "Inferno", "Magma", "Plasma", "Viridis") ),
					
					#~~~show plot data? ---
					checkboxInput("showTable", "Show data under plot"),
					
					#~~~select text size ----
					sliderInput("size", "Text size", min = 6, max = 50, value = 16, step = 1,round = T)
				),
				
				
				#~~render plot ----
				#make a new column 
				column(width = 9, #9 + 3 from previous column = 12 (12=full page width)
							 plotlyOutput("plot")) #render the plot
				
			),
			
			
			#~~render plot data ----
			fluidRow(column(
				width = 9, #same width as plot column
				downloadButton('downloadChartData', 'Download chart data'),
				br(),
				DT::dataTableOutput("plotData"),
				#offset the column by 3 because this row doesnt have the user input section
				#that will make it line up with the plot
				offset = 3 
			))
			
		)
		
		
	),
	
	#View and download all data tab ----
	tabPanel(
		title = "View and download all data",
		
		# ~link to the github repo ----
		a(href = "https://github.com/jrf1111/IPEDS-peer-comparison-shiny", 
			list(img(src = "GitHub-Mark-120px-plus.png", width = "20px", height = "20px"),
					 "Click here for the GitHub repo")),
		hr(),
		
		#~button to download the data ----
		downloadButton('downloadData', 'Download all data'),
		
		#some line breaks
		br(),
		br(),
		
		#~render the data table ----
		DT::dataTableOutput("table1")
		
	)
	
)
