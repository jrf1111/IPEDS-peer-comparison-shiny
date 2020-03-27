function(input, output) {
	#Creating all Output objects -------
	output$table1 <- DT::renderDataTable({
		mdata
	},
	filter = 'top',
	options = list(
		pageLength = 10,
		scrollX = TRUE,
		autoWidth = TRUE,
		columnDefs = list(list(width = '200px', targets = 2))
	))
	
	
	## Download Buttons ----
	output$downloadData <- downloadHandler(
		filename = 'Download.csv',
		content = function(file) {
			write.csv(mdata[input[["table1_rows_all"]],], file, row.names = FALSE)
		}
	)
	
	
	
	
	
	
	#plotly chart ----
	
	output$plot <- renderPlotly({
		temp = mdata[mdata$Question == input$x, ]
		
		
		
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
		
		
		temp$missing = case_when(is.na(temp$Value) ~ 0, !is.na(temp$Value) ~ NA_real_)
		
		temp$missing_alpha = case_when(is.na(temp$Value) ~ 1, !is.na(temp$Value) ~ 0)
		
		
		temp$missing_line = case_when(is.na(temp$Value) ~ "solid", !is.na(temp$Value) ~ "blank")
		
		
		
		
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
			scale_fill_viridis_d(guide = guide_legend(reverse = TRUE)) +
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
				),
				legend.position = "top"
			)
		
		ggplotly(
			p,
			height = 600,
			tooltip = c("text", "Year", "Value"),
			legend = list(
				orientation = "h",
				x = 0.4,
				y = -0.2
			)
		)
		
	})
	
	
	
	
	
	
	output$plotData = DT::renderDataTable({
		temp = mdata[mdata$Question == input$x, ]
		temp = temp %>% select(`Institution Name`, Year, Value)
		
		if (input$showTable == T)
			temp
		
	},
	
	filter = "top",
	options = list(
		pageLength = 6,
		scrollX = TRUE,
		autoWidth = F,
		sDom  = '<"top">t<"bottom">p'
	))
	
	
	
	
	
}
