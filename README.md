
# Cluster_analysis_using_R_Degrees_Project

## Background info
This project can help us understand the professions that are well paid in the short and long term in an individual's professional career. However, this study provides us with a broad view on various professional areas including the salary of an entry level to an experienced senior professional:
 ### Investigating the initial salaries for people with   degrees of 50  different majors. 
 ### Identifying the career growth rate per each major.

The followig Script is written in R Language: (https://github.com/bbest/rmarkdown-example/commits/master/test.Rmd) 

## Exploring the Data 
The dataset used to solve that challenge is not a complicated one (50X8) with no missing values. 

1. [Add github markdown](https://github.com/bbest/rmarkdown-example/commit/c3e428e781f8b505feedc0d97b33080ed59067f6#diff-0)

  ```
  output:
    md_document:
      variant: markdown_github


### Read in the dataset
# 1. Importing data ----

1. [Add format options for pdf and docx](https://github.com/bbest/rmarkdown-example/commit/437e9f1436faaaa431b4f736cd2df21731125b5f#diff-0)

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
 ```

![image](https://user-images.githubusercontent.com/49054741/150647142-814cf317-fa06-4bf3-92d3-de62408c17eb.png)


