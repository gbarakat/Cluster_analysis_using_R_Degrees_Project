
# Cluster_analysis_using_R_Degrees_Project

## Background info
This project can help us understand the professions that are well paid in the short and long term in an individual's professional career. However, this study provides us with a broad view on various professional areas including the salary of an entry level to an experienced senior professional:
 - Investigating the initial salaries for people with   degrees of 50  different majors. 
 - Identifying the career growth rate per each major.

## Data Source
The data used was being collected from a year-long survey of 1.2 million people with only a bachelor's degree by PayScale Inc. After doing some data clean up, we'll compare the recommendations from three different methods for determining the optimal number of clusters, apply a k-means clustering analysis, and visualize the results.



## Exploring the Data 
The dataset used to solve that challenge is not a complicated one (50X8) with no missing values. 

 ```
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
 ```
![image](https://user-images.githubusercontent.com/49054741/150647785-00b43d64-c687-4498-9553-ba4959531bae.png)


## Cleaning Data
The salary data is in currency format, which R considers a string. Let's strip those special characters using the gsub function and convert all of our columns except College.Major to numeric. Career.Percent.Growth column should be converted to a decimal value.

```
degrees_clean <- degrees %>% 
  mutate_at(vars(Starting.Median.Salary:Percentile.90),
            function(x) as.numeric(gsub('[\\$,]',"",x))) %>%
  mutate(Career.Percent.Growth = Career.Percent.Growth / 100)
```

## Data Scaling
To be able to provide accurate comparisons between salaries of different majors. That data should be scaled to overcome gaps and variance between inputs.

```
k_means_data <- degrees_clean %>%
  select(c("Starting.Median.Salary",
           "Mid.Career.Median.Salary",
           "Percentile.10", 
           "Percentile.90"))%>%
  scale()

View(k_means_data)
```
![image](https://user-images.githubusercontent.com/49054741/150647762-2c1211cf-f0df-402a-821b-db8d67df6f25.png)

## Identiying number of clusters
To be able to identify number of clusters, three methods should be calculated earlier. To validate the number of selected clusters.
Used Methods:
 - Elbow Method.
 - Silhouette Method.
 - Gap Statistic Method
