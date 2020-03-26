#load required packages
libs = c("shiny", "tidyverse", "plotly", 
				 "viridis", "stringr", "ggplot2", "readr", "DT")

for(p in libs){
	if(!require(p, character.only = TRUE)) 
		install.packages(p)
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

mdata$Year = factor(mdata$Year, 
										levels = sort(unique(as.numeric(as.character(mdata$Year))), 
																	decreasing = TRUE))

