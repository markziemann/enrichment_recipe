# Docker inheritance

# this is a ubuntu image with R, Rstudio and bioC
FROM bioconductor/bioconductor_docker:RELEASE_3_16

# Update apt-get
RUN apt-get update \
	&& apt-get install -y nano git \
	## Install the python package magic wormhole to send files
	&& pip install magic-wormhole		\
	## Remove packages in '/var/cache/' and 'var/lib'
	## to remove side-effects of apt-get update
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*


# Install required CRAN packages
RUN R -e 'install.packages(c("kableExtra","vioplot","gplots","eulerr","rmdformats","RhpcBLASctl"))'

# Install required Bioconductor package
RUN R -e 'BiocManager::install(c("getDEE2","DESeq2","fgsea","clusterProfiler","mitch"))'

# Clone the repository that contains the research code and execute it
RUN  git clone https://github.com/markziemann/enrichment_recipe.git

# Set the container working directory
ENV DIRPATH /enrichment_recipe
WORKDIR $DIRPATH

# Copy the REACTOME DB fromlocal disk to the container
COPY ref/ReactomePathways_2023-03-06.gmt /enrichment_recipe

# change folder permissions so user can work freely
RUN chmod -R 777 /enrichment_recipe
