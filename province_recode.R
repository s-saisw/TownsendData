# This script ...
# fixes mistakes in Townsend data province coding
# merges townsend data 2000-2017
# exports as dta file

library(dplyr)
library(haven)

setwd("/Data/Townsend_data/Data_cleaned")

target = list.files("T:/Data/Townsend_data/Data_cleaned",
           pattern = ".csv",
           full.names = TRUE)

for (i in 1:length(target)) {
  mydata = read.csv(target[i], header = TRUE)
  mydata$province_recode = case_when(
    mydata$province == 7 ~ 24,
    mydata$province == 27 ~ 31,
    mydata$province == 49 ~ 16,
    mydata$province == 53 ~ 33,
    mydata$province == 91 ~ 91,
    mydata$province == 54 ~ 54,
    mydata$province == 67 ~ 67,
    mydata$province == 16 ~ 16,
    mydata$province == 24 ~ 24,
    mydata$province == 31 ~ 31,
    mydata$province == 33 ~ 33
  )
  mydata$year = as.numeric(substr(target[i],43,46))
  mydata$quarter = 2
 newname = paste0("town_", substr(target[i], 43, 49),
                  "_provrecode.csv")
 write.csv(mydata, newname)
}

alltownsend_file = list.files("T:/Thesis_Data/Townsend_data/Data_cleaned",
                         pattern = "town_",
                         full.names = TRUE)

alltownsend = lapply(alltownsend_file, read.csv, row.names=1)
townsend_data = bind_rows(alltownsend)

townsend = select(townsend_data, 
                       -c(X,newid.x.x,newid.y.x,
                          newid.x.y,newid.y.y,
                          number.x, number.y))
rm(townsend_data)

townsend_rename = rename(townsend,
                         CWT = province_recode)
townsend_rename$matchid = paste0(townsend_rename$CWT, 
                                 townsend_rename$year, 
                                 townsend_rename$quarter)

write_dta(townsend_rename, 
          "T:/Thesis_Data/townsend_analysis/townsend.dta")
rm(temp)
rm(mydata)
rm(townsend)
rm(townsend_data)
rm(townsend_rename)
rm(alltownsend)
