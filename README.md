# Writing with Rmarkdown

We can create versioned (ie in Github), live (ie output directly from data with R), documents in various formats (ie pdf, html, docx) with formatting, figures, tables, equations and references. All using [Rmarkdown](http://rmarkdown.rstudio.com). This is in the vein of generating truly reproducible research.

## Example

Here's an example of using a single Rmarkdown file [test.**Rmd**](./test.Rmd) and rendering it in the following formats:

- [test.**pdf**](./test.pdf?raw=true). Portable document format for pretty professional output.

- [test.**docx**](./test.docx?raw=true). Microsoft Word doc for sharing with collaborators who can use Track Changes for providing feedback.

- [test.**html**](https://rawgit.com/bbest/rmarkdown-example/master/test.html). All you need is a web browser to view this. Works well with linking out to source of References via DOI and links within document. Since Github doesn't natively show HTML, you'll need to right-click on link, Save Link as... to download and open from your computer.

- [test.**md**](./test.md). Great for tracking changes in Github (ie [rendered differences](https://github.com/bbest/rmarkdown-example/commit/4cfcbe626dfa0df5238872820169198fd2008401?short_path=574f1d9#diff-4)) and figuring out who changed what when (ie [blame](https://github.com/bbest/rmarkdown-example/blame/master/test.md)). Equations maintain their latex format, so not prettily rendered like other formats.

You can variously render different formats in RStudio and set options in the metadata header.

  ![rstudio_knit-button](https://raw.githubusercontent.com/bbest/rmarkdown-example/master/screenshots/rstudio_knit-button.png)

Check out [test.Rmd differences](https://github.com/bbest/rmarkdown-example/commits/master/test.Rmd) between commits as it gets built up:

1. [Initial](https://github.com/bbest/rmarkdown-example/commit/7d416b2adba1d49746d8e61b1f3cd53e89548784#diff-2). In RStudio, File > New File > R Markdown ...

1. [Add table of contents & bibliography](https://github.com/bbest/rmarkdown-example/commit/572559a1443cc285bba7b44f6d2a4b96e871069e#diff-1)

  ```
  ---
 output:
   html_document:
     toc: true
     number_sections: true
 bibliography: test.bib
 csl: apa.csl
 ---
  ```

  ...

  The Ocean Health Index [@halpern_index_2012; @selig_assessing_2013] derives most of its pressures from Halpern et al. [-@halpern_global_2008].

1. [Add equation](https://github.com/bbest/rmarkdown-example/commit/4c33f8ad0d5056714c6e72c433523c57e0f3fb4f#diff-0)

  ```
  $$
  x_{FIS} =  (\prod_{g=1}^{6} SS_{i,g}^{C_{i,g}})^\frac{1}{\sum{C_{i,g}}}
  $$ 
  ```

1. [Add format options for pdf and docx](https://github.com/bbest/rmarkdown-example/commit/437e9f1436faaaa431b4f736cd2df21731125b5f#diff-0)

  ```
  output:
    pdf_document:
      fig_caption: yes
      number_sections: yes
      toc: yes
    word_document:
      fig_caption: yes
  ```

1. [Add github markdown](https://github.com/bbest/rmarkdown-example/commit/c3e428e781f8b505feedc0d97b33080ed59067f6#diff-0)

  ```
  output:
    md_document:
      variant: markdown_github
# Cluster_analysis_using_R_Degrees_Project

## Background info
This project can help us understand the professions that are well paid in the short and long term in an individual's professional career. However, this study provides us with a broad view on various professional areas including the salary of an entry level to an experienced senior professional:
 ### Investigating the initial salaries for people with   degrees of 50  different majors. 
 ### Identifying the career growth rate per each major.

## Exploring the Data
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
