#File: server.R
#Desc: This file is really just one big function that assembles user input into outputs

function(input, output) {
	#make the table that will show all the data -------
	output$table1 <- DT::renderDataTable({all_data},
	filter = 'top',
	options = list(
		pageLength = 10,
		scrollX = TRUE,
		autoWidth = TRUE,
		columnDefs = list(list(width = '200px', targets = 2))
	))
	
	
	# add a button to download the full data set ----
	output$downloadData <- downloadHandler(
		filename = 'Download.csv',
		content = function(file) {
			write.csv( all_data , file, row.names = FALSE)
		}
	)
	
	# add a button to download only the chart data ----
	output$downloadChartData <- downloadHandler(
		filename = paste0(input$x, ".csv"),
		content = function(file) {
			write.csv(mdata[mdata$Question == input$x ,], file, row.names = FALSE)
		}
	)
	
	
	
	#make interactive charts with Plotly ----
	
	output$plot <- renderPlotly({
		
		#create a new dataset with only the variable of interest
		temp = mdata[mdata$Question == input$x, ]
		
		
		#add line breaks ("\n") for the chart
		temp$Institution = temp$`Institution Name`
		
		temp = temp %>%
			mutate(
				Institution = case_when(
					Institution == "Collin County Community College District" ~ "Collin County\nCommunity\nCollege District",
					Institution == "El Paso Community College" ~ "El Paso\nCommunity College",
					Institution == "Houston Community College" ~ "Houston\nCommunity College",
					Institution == "Lone Star College System" ~ "Lone Star\nCollege System",
					Institution == "San Jacinto Community College" ~ "San Jacinto\nCommunity College",
					Institution == "Tarrant County College District" ~ "Tarrant County\nCollege District",
					TRUE ~ as.character(Institution)
				)
			)
		
		
		
		#for highlighting missing data on chart
		temp$missing = case_when(is.na(temp$Value) ~ 0, !is.na(temp$Value) ~ NA_real_)
		
		temp$missing_alpha = case_when(is.na(temp$Value) ~ 1, !is.na(temp$Value) ~ 0)
		
		temp$missing_line = case_when(is.na(temp$Value) ~ "solid", !is.na(temp$Value) ~ "blank")
		
		
		#make the appropriate chart in ggplot
		if(input$plotType == "Bar"){
			
			#warn if missing data
			if (any(is.na(temp$Value))) {
				ylab = paste(input$x, "(red lines indicate missing data)")
			} else
				ylab = input$x
			ylab = str_wrap(ylab, width = 50)  #wrap long labels
			
			
			#add extra space between plot and label if needed
			space = 25 + 25 * (nchar(ylab) %/% 25)
			
			
			
			p = ggplot() +
				geom_col(
					data = temp,
					mapping = aes(y = missing, x = Institution),
					position = "dodge",
					color = "red",
					linetype = temp$missing_line,
					na.rm = T
				) +
				geom_col(
					data = temp,
					mapping = aes(
						y = Value,
						x = Institution,
						fill = Year,
						text = temp$`Institution Name`
					),
					position = "dodge",
					na.rm = T
				) +
				coord_flip() +
				theme_bw() +
				labs(y = ylab) +
				theme(
					text = element_text(size = input$size),
					plot.margin = margin(
						b = space,
						l = -100,
						r = 100,
						t = 50
					)
				)
			
			
			ifelse(input$colorScheme == "TCC",
						 {p = p + scale_fill_manual(values = c("#244061", "#63a038", "#0289b2", "grey"),
						 									name = "Year")},
						 {p = p + scale_fill_viridis_d(option = tolower(input$colorScheme),
						 										 name = "Year")}
			)
			
			
			#convert static ggplot to interactive plotly chart
			py = ggplotly(
				p,
				height = 600,
				tooltip = c("text", "Year", "Value"),
				legend = list(
					orientation = "h",
					x = 0.4,
					y = -0.2
				)
			)
			
			
			#for some reason ggplot2 and plotly disagree on how the years should be ordered.
			#the below section makes sure the order of the legend and the order of the bars 
			#are in (a) in agreement and (b) in chronological order
			{
				pdata = py[["x"]][["data"]]
				pdata_swap = pdata
				pdata_swap[[1]] = NULL
				for(i in length(pdata):2){
					pdata[[i]] = pdata_swap[[1+abs(i - length(pdata))]]
				}
				py[["x"]][["data"]] = pdata
			}
			
			
			
			
			#return the plotly chart
			py
			
			
		} else if(input$plotType == "Column"){
			
			
			
			#warn if missing data
			if (any(is.na(temp$Value))) {
				ylab = paste(input$x, "(red lines indicate missing data)")
			} else
				ylab = input$x
			ylab = str_wrap(ylab, width = 50)  #wrap long labels
			
			
			#add extra space between plot and label if needed
			space = 25 + 25 * (nchar(ylab) %/% 25)
			
			
			
			#create static ggplot chart
			p = ggplot() +
				geom_col(
					data = temp,
					mapping = aes(y = missing, x = str_wrap(temp$`Institution Name`, 10)),
					position = "dodge",
					color = "red",
					linetype = temp$missing_line,
					na.rm = T
				) +
				geom_col(
					data = temp,
					mapping = aes(
						y = Value,
						x = str_wrap(temp$`Institution Name`, 10),
						fill = Year,
						text = temp$`Institution Name`
					),
					position = "dodge",
					na.rm = T
				) +
				theme_bw() +
				labs(x = ylab, y = NULL) +
				theme(
					text = element_text(size = input$size),
					plot.margin = margin(
						b = space,
						l = -100,
						r = 100,
						t = 50
					)
				)
			
			
			ifelse(input$colorScheme == "TCC",
						 {p = p + scale_fill_manual(values = c("#244061", "#63a038", "#0289b2", "grey"),
						 													 name = "Year")},
						 {p = p + scale_fill_viridis_d(option = tolower(input$colorScheme),
						 															guide = guide_legend(reverse = TRUE))}
			)
			
			
			
			#convert static ggplot to interactive plotly chart
			py = ggplotly(
				p,
				height = 600,
				tooltip = c("text", "Year", "Value"),
				legend = list(
					orientation = "h",
					x = 0.4,
					y = -0.2
				)
			)
			
			#return plotly chart
			py
			
			
		} else if(input$plotType == "Line"){
			
			
			
			#warn if missing data
			if (any(is.na(temp$Value))) {
				ylab = paste(input$x, "(red lines indicate missing data)")
			} else
				ylab = input$x
			ylab = str_wrap(ylab, width = 50)  #wrap long labels
			
			
			#add extra space between plot and label if needed
			space = 25 + 25 * (nchar(ylab) %/% 25)
			
			
			
			#create static ggplot chart
			p = ggplot() +
				geom_path(
					data = temp,
					mapping = aes(
						y = Value,
						x = Year,
						group = str_wrap(temp$`Institution Name`, 10),
						color = str_wrap(temp$`Institution Name`, 10),
						text = temp$`Institution Name`
					), 
					size = 1
				) + 
			theme_bw() +
				labs(x = ylab) +
				theme(
					text = element_text(size = input$size),
					plot.margin = margin(
						b = space,
						l = -100,
						r = 100,
						t = 50
					)
				)
			
			n = length(unique(temp$`Institution Name`))
			ifelse(input$colorScheme == "TCC",
						 {p = p + 
						 	scale_color_manual(values = 
						 										 	colorRampPalette(c("#244061", "#63a038", "#0289b2", "grey"))(n),
						 										 name = "Institution") },
						 {p = p +scale_color_viridis_d(option = tolower(input$colorScheme),
						 															name = "Institution")}
			)
			
			#convert static ggplot to interactive plotly chart
			py = ggplotly(
				p,
				height = 600,
				tooltip = c("text", "Year", "Value"),
				legend = list(
					orientation = "h",
					x = 0.4,
					y = -0.2
				)
			)
			
			#return plotly chart
			py
			
		}
		
		
		
	
		

		
	})
	
	
	
	
	
	
	# render the chart data --------------------------------------------------------------
	
	output$plotData = DT::renderDataTable({
		temp = mdata[mdata$Question == input$x, ]
		temp = temp %>% select(`Institution Name`, Year, Value)
		
		if (input$showTable == TRUE) temp  #show the table if user clicked check box
		
	},
	
	#set options for the table
	filter = "top",
	options = list(
		pageLength = 6,
		scrollX = TRUE,
		autoWidth = F,
		sDom  = '<"top">t<"bottom">p'
	))
	
	
	
	
	
}
