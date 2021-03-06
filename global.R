#File: global.R
#Desc: This optional file is used to perform actions (e.g., data loading, wrangling, etc.)
#      that other files in the shiny app need to be able to access.  For example, 
#      any packages that are loaded here or data that are imported here will be 
#      available for use in the server.R and ui.R files.




#load required packages
library(DT)
library(plotly)
library(tidyverse)
library(shiny)
library(DT)
library(viridis)
library(shinyBS)







#import data downloaded from IPEDS
mdata = read_csv(
	"https://raw.githubusercontent.com/jrf1111/IPEDS-peer-comparison-shiny/master/Data_3-25-2020.csv"
)

mdata = mdata[,-ncol(mdata)] #delete extra column at end of file


#convert data from wide to long
mdata = mdata %>%
	pivot_longer(-c(UnitID, "Institution Name"),
							 names_to = "Question1",
							 values_to = "Value")


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

mdata$Year = factor(mdata$Year,
										levels = sort(unique(as.numeric(
											as.character(mdata$Year)
										)),
										decreasing = F),
										ordered = T)



#data in the	"View and download all data" tab
all_data = select(mdata, UnitID, 'Institution Name', Question1, Value, Year)
colnames(all_data) = c("UnitID", 'Institution Name', "Variable", "Value", "Year")