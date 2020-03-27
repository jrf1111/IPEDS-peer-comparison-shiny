#
# This is a Shiny web application for interacting with IPEDS dashboard data.
# Author: Jake Roden-Foreman
# Based on https://github.com/SurajMalpani/Shiny_H1b
#
#########---######---





source("ui.R")
source("server.R")

# Run the application
shinyApp(ui = ui,
				 server = server,
				 display.mode = "showcase")
