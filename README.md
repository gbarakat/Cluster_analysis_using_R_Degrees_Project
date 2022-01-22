
# Cluster_analysis_using_R_Degrees_Project

## Background info
This project can help us understand the professions that are well paid in the short and long term in an individual's professional career. However, this study provides us with a broad view on various professional areas including the salary of an entry level to an experienced senior professional:
 - Investigating the initial salaries for people with   degrees of 50  different majors. 
 - Identifying the career growth rate per each major.

## Data Source
The data used was being collected from a year-long survey of 1.2 million people with only a bachelor's degree by PayScale Inc. After doing some data clean up, we'll compare the recommendations from three different methods for determining the optimal number of clusters, apply a k-means clustering analysis, and visualize the results.



## Exploring the Data 
The dataset used to solve that challenge is not a complicated one (50X8) with no missing values. 

 ```R
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

```R
degrees_clean <- degrees %>% 
  mutate_at(vars(Starting.Median.Salary:Percentile.90),
            function(x) as.numeric(gsub('[\\$,]',"",x))) %>%
  mutate(Career.Percent.Growth = Career.Percent.Growth / 100)
```

## Data Scaling
To be able to provide accurate comparisons between salaries of different majors. That data should be scaled to overcome gaps and variance between inputs.

```R
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

### Elbow Method:
```R
elbow_method <- fviz_nbclust(k_means_data,
                             FUNcluster=kmeans,
                             method="wss")

# View the plot
elbow_method
```
![elbow_method](https://user-images.githubusercontent.com/49054741/150648019-deac29a5-9b3f-4a08-a0c1-d0b9db438142.png)


### Silhouette Method
``` R
silhouette_method <- fviz_nbclust(k_means_data,
                                  FUNcluster = kmeans,
                                  method="silhouette")

# View the plot
silhouette_method

```
![Silheoutte](https://user-images.githubusercontent.com/49054741/150648065-98ec1553-2ce4-4ead-b49f-f818cc005b01.png)

### Gap Statistic Method

``` R
gap_stat <- clusGap(k_means_data,
                    FUN = kmeans,
                    nstart=25,
                    K.max=10,
                    B=50)

# Use the fviz_gap_stat function to vizualize the results
gap_stat_method <- fviz_gap_stat(gap_stat)

# View the plot
gap_stat_method
```
![gap_stat](https://user-images.githubusercontent.com/49054741/150648109-80009a17-b6e8-4ff7-9e10-b555d63dbf9e.png)


## K-means algorithm
Looks like the Gap Statistic Method agreed with the Elbow Method! According to majority rule, let's use 3 for our optimal number of clusters. With this information, we can now run our k-means algorithm on the selected data. We will then add the resulting cluster information to label our original dataframe.
``` R
# 5. Set k equal to the optimal number of clusters ----
num_clusters <- 3

# Run the k-means algorithm 
k_means <- kmeans(k_means_data,
                  centers=num_clusters,
                  iter.max=15,
                  nstart=25)

# Label the clusters of degrees_clean
degrees_labeled <- degrees_clean %>%
  mutate(clusters = k_means$cluster)
 ```
## Visualizing the clusters
Now for the pretty part: visualizing our results. First let's take a look at how each cluster compares in Starting vs. Mid Career Median Salaries. What do the clusters say about the relationship between Starting and Mid Career salaries?
```R
career_growth <- ggplot(degrees_labeled,
                        aes(x=Starting.Median.Salary,
                            y=Mid.Career.Median.Salary,
                            color=factor(clusters)))+
  
  geom_point(alpha = 0.8, size = 7)+
  xlab("Starting Salary (Median)") +
  ylab("Mid-Career Salary (Median)") +
  ggtitle("K means - Starting vs Mid-Career Salary") +
  scale_x_continuous(labels = scales::dollar) +
  scale_y_continuous(labels = scales::dollar)

# View the plot
career_growth
```
![career-growth](https://user-images.githubusercontent.com/49054741/150648285-6911a9a9-3fae-40e4-94ce-c557dd5fab27.png)
![career-growth](https://user-images.githubusercontent.com/49054741/150648286-7d9f269b-ed3e-47ad-b0be-27ccc83ae00c.png)

# View the plot
