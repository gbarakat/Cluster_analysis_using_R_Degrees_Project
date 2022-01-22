
# Cluster analysis using R: Degrees That pay you back

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

## A deeper dive into the clusters
Unsurprisingly, most of the data points are hovering in the top left corner, with a relatively linear relationship. In other words, the higher your starting salary, the higher your mid career salary. The three clusters provide a level of delineation that intuitively supports this.

How might the clusters reflect potential mid career growth? There are also a couple curious outliers from clusters 1 and 3… perhaps this can be explained by investigating the mid career percentiles further, and exploring which majors fall in each cluster.

Right now, we have a column for each percentile salary value. In order to visualize the clusters and majors by mid career percentiles, we'll need to reshape the degrees_labeled data using tidyr's gather function to make a percentile key column and a salary value column to use for the axes of our following graphs. We'll then be able to examine the contents of each cluster to see what stories they might be telling us about the majors.
``` R
degrees_perc <- degrees_labeled %>%
  
  select(c("College.Major", 
           "Percentile.10", 
           "Percentile.25", 
           "Mid.Career.Median.Salary", 
           "Percentile.75", 
           "Percentile.90",
           "clusters"))%>%
  gather(key="percentile", value="salary", -c("College.Major","clusters"))%>%
  mutate(percentile=factor(percentile,levels=c('Percentile.10',
                                               'Percentile.25',
                                               'Mid.Career.Median.Salary',
                                               'Percentile.75',
                                               'Percentile.90')))

View(degrees_perc)
```
![image](https://user-images.githubusercontent.com/49054741/150648355-6a83d7f8-8f76-481a-8060-e2e79f5d48cf.png)

## Cluster 1: The liberal arts cluster
Let's graph Cluster 1 and examine the results. These Liberal Arts majors may represent the lowest percentiles with limited growth opportunity, but there is hope for those who make it! Music is our riskiest major with the lowest 10th percentile salary, but Drama wins the highest growth potential in the 90th percentile for this cluster (so don't let go of those Hollywood dreams!). Nursing is the outlier culprit of cluster number 1, with a higher safety net in the lowest percentile to the median. Otherwise, this cluster does represent the majors with limited growth opportunity.

An aside: It's worth noting that most of these majors leading to lower-paying jobs are women-dominated, according to this Glassdoor study. According to the research:

"The single biggest cause of the gender pay gap is occupation and industry sorting of men and women into jobs that pay differently throughout the economy. In the U.S., occupation and industry sorting explains 54 percent of the overall pay gap—by far the largest factor."

Does this imply that women are statistically choosing majors with lower pay potential, or do certain jobs pay less because women choose them…?
```R
cluster_1 <- degrees_perc %>%
  filter(clusters == 1)%>%
  ggplot(aes(x=percentile, y = salary,group = College.Major, color = College.Major))+
  geom_point()+
  geom_line()+
  ggtitle("Cluster 1: The Liberal Arts")+
  theme(axis.text.x=element_text(size= 7, angle=25))
# View the plot
cluster_1
```
![Cluster_1](https://user-images.githubusercontent.com/49054741/150648404-c3a1fdf6-793b-45df-9a48-e465b88327c6.png)

## Cluster 2: The goldilocks cluster
On to Cluster 2, right in the middle! Accountants are known for having stable job security, but once you're in the big leagues you may be surprised to find that Marketing or Philosophy can ultimately result in higher salaries. The majors of this cluster are fairly middle of the road in our dataset, starting off not too low and not too high in the lowest percentile. However, this cluster also represents the majors with the greatest differential between the lowest and highest percentiles.
``` R
cluster_2 <- degrees_perc %>%
  filter(clusters == 2)%>%
  ggplot(aes(x=percentile, y = salary,group = College.Major, color = College.Major))+
  geom_point()+
  geom_line()+
  ggtitle("Cluster 2: The Goldilocks")+
  theme(axis.text.x=element_text(size= 7, angle=25))

# View the plot
cluster_2
```
![Cluster_2](https://user-images.githubusercontent.com/49054741/150648487-86cce9b6-e3b4-4e5e-b69c-1f99099bcc82.png)

## Cluster 3 :The over achiever cluster
Finally, let's visualize Cluster 3. If you want financial security, these are the majors to choose from. Besides our one previously observed outlier now identifiable as Physician Assistant lagging in the highest percentiles, these heavy hitters and solid engineers represent the highest growth potential in the 90th percentile, as well as the best security in the 10th percentile rankings. Maybe those Freakonomics guys are on to something…
``` R
cluster_3 <-  degrees_perc %>%
  filter(clusters == 3)%>%
  ggplot(aes(x=percentile, y = salary,group = College.Major, color = College.Major))+
  geom_point()+
  geom_line()+
  ggtitle("Cluster 3: The Over Achievers")+
  theme(axis.text.x=element_text(size= 7, angle=25))

# View the plot
cluster_3
```
![Cluster_3](https://user-images.githubusercontent.com/49054741/150648548-49e5a05c-7426-45ca-8955-9a4bcae40db6.png)

