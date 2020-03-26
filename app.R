#
# This is a Shiny web application for interacting with IPEDS dashboard data.
# Author: Jake Roden-Foreman
# Based on https://github.com/SurajMalpani/Shiny_H1b
#
#########---######---



#load required packages
require(shiny)
libs = c("shiny", "flexdashboard", "tidyverse", "plotly", 
				 "viridis", "stringr", "ggplot2", "readr", "DT")

for(p in libs){
	if(!require(p, character.only = TRUE)) 
		install.packages(p);
	library(p, character.only = TRUE)
}



source("ui.R")
source("server.R")

# Run the application 
shinyApp(ui = ui, server = server)
