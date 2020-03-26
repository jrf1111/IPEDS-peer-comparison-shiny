function(input, output) {
	
	#load required packages
	libs = c("shiny", "flexdashboard", "tidyverse", "plotly", 
					 "viridis", "stringr", "ggplot2", "readr", "DT")
	
	for(p in libs){
		if(!require(p, character.only = TRUE)) 
			install.packages(p);
		library(p, character.only = TRUE)
	}
	
	
	
	#import data downloaded from IPEDS
	mdata = read_csv("https://raw.githubusercontent.com/jrf1111/IPEDS-peer-comparison-shiny/master/Data_3-25-2020.csv")
	
	mdata$X252 = NULL #delete extra column
	
	
	#convert data from wide to long
	mdata = mdata %>% 
		pivot_longer(-c(UnitID, "Institution Name"), names_to = "Question1", values_to = "Value")
	
	
	#create and format a year variable by pulling year from mdata$Question1
	mdata$Year = gsub("^.*?(\\d{4}).*", "\\1", mdata$Question1)
	mdata$Year = gsub("1516", "2016", mdata$Year, fixed = T)
	mdata$Year = gsub("1617", "2017", mdata$Year, fixed = T)
	mdata$Year = gsub("1718", "2018", mdata$Year, fixed = T)
	mdata$Year = as.numeric(mdata$Year)
	
	
	
	
	#create and format a Question variable that doesn't include year or dataset info
	mdata$Question = gsub("^(.*)( \\(.*)$", "\\1", mdata$Question1)
	mdata$Question = gsub("\\s{1,}20\\d{2}-\\d{2}", "", mdata$Question)
	mdata$Question = gsub("\\s{1,}20\\d{2}", "", mdata$Question)
	mdata$Question = gsub("  ", " ", mdata$Question)
	
	
	
	
	
	#Creating all Output objects -------
	output$table1 <- DT::renderDataTable({mdata}, filter='top', 
																			 options = list(pageLength = 10, scrollX=TRUE, autoWidth = TRUE, 
																			 							 columnDefs = list(list(width = '200px', targets = 2))))
	
	
	## Download Buttons ----
	output$downloadData <- downloadHandler(
		filename = 'Download.csv',
		content = function(file) {
			write.csv(mdata[input[["table1_rows_all"]],], file, row.names = FALSE)
		}
	)
	
	
	
	
	
	
	#plotly chart ----

	output$plot <- renderPlotly({
		
		mdata$Year = factor(mdata$Year, 
											 levels = sort(unique(as.numeric(as.character(mdata$Year))), 
											 							decreasing = TRUE))
		
		
		temp = mdata[mdata$Question == input$x, ]
		
		
		
		temp$Institution = temp$`Institution Name`
		
		temp = temp %>% 
			mutate(Institution = case_when(
				Institution == "Collin County Community College District" ~ "Collin County\nCommunity\nCollege District",
				Institution == "El Paso Community College" ~ "El Paso\nCommunity College",
				Institution == "Houston Community College" ~ "Houston\nCommunity College",
				Institution == "Lone Star College System" ~ "Lone Star\nCollege System",
				Institution == "San Jacinto Community College" ~ "San Jacinto\nCommunity College",
				Institution == "Tarrant County College District" ~ "Tarrant County\nCollege District",
				TRUE ~ as.character(Institution)
			)
			)
		
		
		temp$missing = case_when(
			is.na(temp$Value) ~ 0,
			!is.na(temp$Value) ~ NA_real_
		)
		
		temp$missing_alpha = case_when(
			is.na(temp$Value) ~ 1,
			!is.na(temp$Value) ~ 0
		)
		
		
		temp$missing_line = case_when(
			is.na(temp$Value) ~ "solid",
			!is.na(temp$Value) ~ "blank"
		)
		
		
		p = ggplot() + 
			geom_col(data = temp, 
							 mapping = aes(y = missing, x = Institution),
							 position = "dodge", color = "red", linetype = temp$missing_line, 
							 na.rm = T) +	
			geom_col(data=temp, 
							 mapping = aes(y=Value, x=Institution, fill = Year, text = temp$`Institution Name`), 
							 position = "dodge", na.rm = T) +
			scale_fill_viridis_d(guide = guide_legend(reverse=TRUE)) +
			coord_flip() +
			theme_bw() +
			labs(y = str_wrap(input$x, width = 50)) +
			theme(text = element_text(size = input$size), 
						plot.margin = margin(b = 50, l=-100, r = 100, t=50),
						legend.position="top")
		
		ggplotly(p, height = 600,
						 tooltip = c("text", "Year", "Value"),
						 legend = list(orientation = "h", x = 0.4, y = -0.2)
		)
		
	})
	
	

	
	
	
	
}


