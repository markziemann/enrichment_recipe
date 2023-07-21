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

## To reproduce this workflow

```
docker pull mziemann/enrichment_recipe

docker run -it -v ${pwd}:/enrichment_recipe --entrypoint /bin/bash mziemann/enrichment_recipe
```

Then inside the container, execute the Rmarkdown script.

```
R -e 'rmarkdown::render("example.Rmd")'
```

After it completes, exit R and the container.
Then copy the report from the container to the working directory.

```
docker cp $(docker ps -aql):/enrichment_recipe/example.html .

```

The result you obtain should be identical to [this one](https://ziemann-lab.net/public/enrichment_recipe/example.html)
we generated previously.

## Rebuild the docker image

If for some reason you need to rebuild the docker image, use the following:

```
docker build -t mziemann/enrichment_recipe --no-cache .
```

Note that the Dockerfile must be in the current directory.
The "no cache" option forces docker to repeat the entire build,
even if a cached occurrance is saved.

# Data and Software Availability

## Underlying data

Publicly available data were obtained from Digital Expression Explorer 2 (dee2.io).
Expression data from untreated and Aza treated AML3 cells.
Accession Number SRP038101.
Data are available under the terms of the GNU General Public License v3.0.

## Software and Code

* Code repository including template Dockerfile and R Markdown script is available on GitHub
(https://github.com/markziemann/enrichment_recipe).

* The example Docker image was deposited to DockerHub
(https://hub.docker.com/r/mziemann/enrichment_recipe).

* The code repository and Docker image have been uploaded to Zenodo for long-term archiving
(https://zenodo.org/record/8170984).

## Availability of other materials

* Protocol: can be found at protocols.io
(https://www.protocols.io/view/a-recipe-for-extremely-reproducible-enrichment-ana-j8nlkwpdxl5r/v2).

* Instructional video guides are available on YouTube
(https://www.youtube.com/playlist?list=PLAAydBPtqFMXDpLa796q7f7W1HK4t_6Db).
