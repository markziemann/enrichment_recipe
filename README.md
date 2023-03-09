# A recipe for extremely reproducible enrichment analysis

By Mark Ziemann and Anusuiya Bora

Computational reproducibility is difficult, especially over longer timeframes.

Using a Docker image allows researchers to keep a stable compute environment with
a known version of operating system, R and packages.
The downside of Docker is that working with it is typically done with the
command line, and requires a relatively high degree of specialised knowledge.

This work is designed to help researchers make their enrichment analyses more
reproducible by providing two important things:

* Templates for a functional Docker container with R-based enrichment tools.

* Step-by-step guides to help users customise templates and deploy analyses in their
research projects.

## Content of this repository

* `README.md`: this file.

* `Dockerfile`: this is the build instruction set for the Docker image. 

* `example.Rmd`: this is the Rmarkdown workflow which you should modify to suit
your needs.

* `manuscript.Rmd`: we wrote the whole manuscript in Rmarkdown to prove we could
make the whole process reproducible.

* `docs`: Step-by-step guides to getting your transcriptome analyses done in Docker.

