#load required packages
libs = c("shiny", "tidyverse", "plotly", 
				 "viridis", "stringr", "ggplot2", "readr", "DT")

for(p in libs){
	if(!require(p, character.only = TRUE)) 
		install.packages(p);
	library(p, character.only = TRUE)
}