#source files
source("ui.R")
source("server.R")

# Run the application
shinyApp(ui = ui,
				 server = server,
				 display.mode = "showcase")
