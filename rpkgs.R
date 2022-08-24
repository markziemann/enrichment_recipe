install.packages("systemfonts")
install.packages("gplots")
install.packages("ggplot2")
install.packages("rmarkdown")
install.packages("knitr")
install.packages("kableExtra")

packageurl <- "https://cran.r-project.org/src/contrib/Archive/rvcheck/rvcheck_0.1.8.tar.gz"
install.packages(packageurl, repos=NULL, type="source")

install.packages("BiocManager")
BiocManager::install("edgeR")
