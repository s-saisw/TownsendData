##################################################
############Merge Data from same year#############
##################################################

library(dplyr)
library(haven)
#library(foreign)

setwd("/Data/Townsend_data/Data_cleaned")

folder = list.files("/Data/Townsend_data/downloadedData",
                    full.names = TRUE)

# Alternative version to get domain_demog etc more neatly

domain = list()

for (i in 1:26){
  name = paste0(folder[i], "/Data")
  domain[i] = list.files(name, pattern = "_01cvr.dta", full.names = TRUE)
}

#########################################################


Townsendclean = function(year, area){
name = paste0(paste(year, sep = "_", area),".csv")

#create file domain --------------------------------------
domain_demog = paste0("/Data/Townsend_data/downloadedData/", 
                year, "_", area, 
                "/Data/",
                "hh", substr(year,3,4), "_01cvr.dta")
domain_wagedf = paste0("T:/Thesis_Data/Townsend_data/Data/", 
                       year, "_", area, 
                       "/Data/hh", substr(year,3,4), "_05oc_tab1.dta")
domain_workloca = paste0("T:/Thesis_Data/Townsend_data/Data/", 
                         year, "_", area, 
                         "/Data/hh", substr(year,3,4), "_05oc_tab2.dta")
domain_educ = paste0("T:/Thesis_Data/Townsend_data/Data/", 
                       year, "_", area, 
                       "/Data/hh", substr(year,3,4), "_04hc_tab1.dta")

#import files---------------------------------------------
demog <- read_dta(domain_demog)
wagedf <- read_dta(domain_wagedf)
workloca <- read_dta(domain_workloca)
educ <- read_dta(domain_educ)

#construct indivID for cvr: demographic
format_num = ifelse(demog$cvr8>=10, 
                    demog$cvr8, 
                    paste0("0",demog$cvr8))

demog$indivID = paste0(demog$newid, format_num)

#construct indivID for 05oc_tab1: wage, wage type
newnum = ifelse(wagedf$number>=10,
                wagedf$number,
                paste0("0",wagedf$number))

wagedf$indivID = paste0(wagedf$newid, newnum)

#construct indivID for 05oc_tab2: work location
newroster = ifelse(workloca$oc3b>=10,
                   workloca$oc3b,
                   paste0("0", workloca$oc3b))

workloca$indivID = paste0(workloca$newid, newroster)

#construct indivID for 04hc_tab1: educ
numnum = ifelse(educ$number>=10,
                educ$number,
                paste0("0", educ$number))

educ$indivID = paste0(educ$newid, numnum)

#new data frame-------------------------------------------
temp1 = merge(demog, wagedf, 
              by.x = "indivID", by.y = "indivID",
              all.x = TRUE, all.y = TRUE)

temp2 = merge(workloca, educ, 
              by.x = "indivID", by.y = "indivID",
              all.x = TRUE, all.y = TRUE)

df = merge(temp1, temp2, 
           by.x = "indivID", by.y = "indivID",
           all.x = TRUE, all.y = TRUE)

df$province = substr(df$indivID,1,2)

#export new data frame -----------------------------------
#exp_path = paste0("T:/Thesis_Data/Townsend_data/Data_cleaned/", name)
write.csv(df, file = name)
}

#Repeat same procedure for every file --------------------

file.name = list.files(path = "T:/Thesis_Data/Townsend_data/Data")[c(-1,-2,-3, -7, -9, -32)]
#exclude data files with inconsistent format, baseline survey files

file.name_year = as.numeric(substr(file.name, 1, 4))
file.name_area = substr(file.name, 6, 100)

mapply(Townsendclean, file.name_year, file.name_area)

mapply(Townsendclean, 2000, "unknown")

#ERROR: 1997-1999, baseline


