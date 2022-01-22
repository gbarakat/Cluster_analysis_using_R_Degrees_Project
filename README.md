# Cluster_analysis_using_R_Degrees_Project

## Background info
This project can help us understand the professions that are well paid in the short and long term in an individual's professional career. However, this study provides us with a broad view on various professional areas including the salary of an entry level to an experienced senior professional:
 ### Investigating the initial salaries for people with   degrees of 50  different majors. 
 ### Identifying the career growth rate per each major.

## Exploring the Data
### Read in the dataset
# 1. Importing data ----
features <-c("College.Major",
             "Starting.Median.Salary",
             "Mid.Career.Median.Salary",
             "Career.Percent.Growth",
             "Percentile.10",
             "Percentile.25",
             "Percentile.75" ,
             "Percentile.90")

degrees<-read_csv("degrees-that-pay-back.csv",col_names=features,
                  skip=1)
View(degrees)
is.na(degrees)
head(degrees)
summary(degrees)
