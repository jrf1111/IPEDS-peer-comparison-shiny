#File: app.R
#Desc: a very short file that is used to load then run the UI and server files.

#source files
source("ui.R")
source("server.R")

# Run the application
shinyApp(ui = ui,
				 server = server,
				 display.mode = "normal")
