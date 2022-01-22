#install.packages(c("tidyr","dplyr","readr","ggplot2","cluster","factoextra"),dependencies = T)
library(tidyr)
library(dplyr)
library(readr)
library(ggplot2)
library(cluster)
library(factoextra)

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

# 2. Data Cleaning -----
degrees_clean <- degrees %>% 
  mutate_at(vars(Starting.Median.Salary:Percentile.90),
            function(x) as.numeric(gsub('[\\$,]',"",x))) %>%
  mutate(Career.Percent.Growth = Career.Percent.Growth / 100)


# 3. Select and scale the relevant features and store as k_means_data ----
k_means_data <- degrees_clean %>%
  select(c("Starting.Median.Salary",
           "Mid.Career.Median.Salary",
           "Percentile.10", 
           "Percentile.90"))%>%
  scale()

View(k_means_data)
# 4. Identiying number of clusters
## i) elbow_method----
elbow_method <- fviz_nbclust(k_means_data,
                             FUNcluster=kmeans,
                             method="wss")

# View the plot
elbow_method

## ii) silhouette_method ---- 
silhouette_method <- fviz_nbclust(k_means_data,
                                  FUNcluster = kmeans,
                                  method="silhouette")

# View the plot
silhouette_method

# iii) Gap Statistic Method -----
gap_stat <- clusGap(k_means_data,
                    FUN = kmeans,
                    nstart=25,
                    K.max=10,
                    B=50)

# Use the fviz_gap_stat function to vizualize the results
gap_stat_method <- fviz_gap_stat(gap_stat)

# View the plot
gap_stat_method


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



# Graph the clusters by Starting and Mid Career Median Salaries
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

# Use the gather function to reshape degrees and 
# use mutate() to reorder the new percentile column
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
# 6.Graph the majors of Clusters 1 by percentile ----
## i) Cluster 1 ----
cluster_1 <- degrees_perc %>%
  filter(clusters == 1)%>%
  ggplot(aes(x=percentile, y = salary,group = College.Major, color = College.Major))+
  geom_point()+
  geom_line()+
  ggtitle("Cluster 1: The Liberal Arts")+
  theme(axis.text.x=element_text(size= 7, angle=25))
# View the plot
cluster_1

## ii) Cluster 2----
cluster_2 <- degrees_perc %>%
  filter(clusters == 2)%>%
  ggplot(aes(x=percentile, y = salary,group = College.Major, color = College.Major))+
  geom_point()+
  geom_line()+
  ggtitle("Cluster 2: The Goldilocks")+
  theme(axis.text.x=element_text(size= 7, angle=25))

# View the plot
cluster_2

## iii) Cluster 3----
cluster_3 <-  degrees_perc %>%
  filter(clusters == 3)%>%
  ggplot(aes(x=percentile, y = salary,group = College.Major, color = College.Major))+
  geom_point()+
  geom_line()+
  ggtitle("Cluster 3: The Over Achievers")+
  theme(axis.text.x=element_text(size= 7, angle=25))

# View the plot
cluster_3

# 7.Sort degrees by Career.Percent.Growth ----
View(degrees_labeled)
arrange(degrees_labeled, desc(Career.Percent.Growth))
slice_max(degrees_labeled,Career.Percent.Growth,n = 3)
slice_max(degrees_labeled,Starting.Median.Salary,n = 3)
slice_max(degrees_labeled,Mid.Career.Median.Salary,n = 3)



#"Starting.Median.Salary","Mid.Career.Median.Salary
# Identify the two majors tied for highest career growth potential
highest_career_growth <- c('Math','Philosophy')
