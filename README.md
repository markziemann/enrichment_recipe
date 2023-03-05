# A recipe for extremely reproducible enrichment analysis

By Mark Ziemann and Anusuiya Bora

Computational reproducibility is difficult, especially over longer timeframes.

Using a Docker image allows researchers to keep a stable compute environment with
a known version of operating system, R and packages.
The downside of Docker is that working with it is typically done with the
command line.

Here I will walk you through the process of building a Docker based workflow 
for differential expression and functional enrichment analysis.

## Glossary of terms

Docker image

Docker container

Dockerhub

git repository

GitHub

## Requirements

To follow along with this workflow you'll need a computer with internet access,
2 or more CPU threads, 8GB RAM and Docker installed.

Beginner level unix shell scripting is required, as is intermediate R/Rmarkdown
scripting.

You will need a GitHub username and password, as well as git installed on your
computer.

A dockerhub account is not neccessary unless you want to save the images to 
dockerhub.
That could be useful if you want to reuse these containers on multiple other
computers.

## Content of this repository

This GitHub repository is designed to be a boilerplate template that you
can use for gene expression and functional enrichment work.
In order to start working with it, you'll need to be familiar with the
contents:

* `README.md`: this step-by-step guide to getting your transcriptome analyses
in Docker.

* `Dockerfile`: this is the build instruction set for the Docker image.

* `example.Rmd`: this is the Rmarkdown workflow which you should modify to suit
your needs.

* `manuscript.Rmd`: it is possible to write the whole manuscript at this point if you
like using Rmarkdown instead of a normal word processor.

## Linux guide to customising this repo for your own analysis

This guide will walk you through the process of setting up your own reproducible
workflow in a docker container.

### 1. Set up the git repository

Use your internet browser to log into github.com and hit the `create a new repository` 
button.
Choose the name carefully.
I'll be using `myproj` in this example.
It would be a good idea to include a `LICENSE` and `README.md` now.
Consider whether you want the GitHub repo to be private or public.
If it is private, then authentication is requried to `clone` or `pull` the repo.

If this is your first repository, then you will need to add an ssh key as a
way to authenticate modifications to the repo.
The process takes about a minute, and details can be found [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

You should now return to your project working directory on the command line.
Clone the repo into your working directory.
Here the username is `jsmith`, but you should use your own GitHub.com username.

```
git clone jsmith/myproj
```

If git is being used for the first time on this computer, you may get an error about
git not being configured with email address and alias used to create the GitHub.com
account.
You'll need to provide these in order to interact with your repo on GitHub.

Next, `cd` into the directory and copy some essential files.
We will modify these files in the next step.

```
cd myproj
wget https://raw.githubusercontent.com/markziemann/udocker_r_example/main/Dockerfile
wget https://raw.githubusercontent.com/markziemann/udocker_r_example/main/example.Rmd
```

### 2. Customise the workflow

Modify `example.Rmd` in accordance with your analytical needs.
See this [guide](https://rmarkdown.rstudio.com/lesson-1.html) for an intro into rmarkdown.
There are a few things to keep in mind:

* When you change the workflow by adding and removing code chunks, you are likely
to need some new libraries in the image; keep a note of them.
Also, keep only the libraries that are needed, as this will keep the docker image as
lightweight as possible.

* Consider the input data carefully. 
Fetching publicly available data is the simplest approach, so consider depositing the
data to a persistent repository like Zenodo or NCBI.
If the data are relatively small (<20MB), you could bundle the data into the image.
I will provide an example of this later on.

### 3. Customise the Docker image

Modify `Dockerfile` in accordance with your needs.

* Select the bioconductor release you need. 
Currently I'm using `3_16` but you might want to go with a more recent one.

* Modify other utilities.
I have included `nano`, `git` and `magic-wormhole` as useful utilities.
These are optional, you can delete them or include other ones.

* Add and remove required R packages from the `install.packages()` and
`BiocManager::install()` commands.

* If you want the Docker image to contain some data, it can be added like this,
where `foo.txt` is the name of the input data file in the current working directory,
and `/data/foo.txt` is the destination location.

`COPY foo.txt /data/foo.txt`

* If you want the Rmarkdown script to be run as part of the Docker build process,
you can add the following line after the `RUN git clone` command.

```
RUN cd udocker_r_example && R -e 'rmarkdown::render("example.Rmd")'
```

### 4. Build the Docker image

Now we're ready to build the image.

replace `username` with your own alias.

```
docker build -t example .
```

If the build process didn't work, then you'll need to remedy that by modifying
the Dockerfile.

### 5. Run the workflow

You can get a command line inside the image like this:

```
docker run -it --entrypoint /bin/bash example
```

You can then see that the project script `example.Rmd` is there.
You can run it by executing `R`, and then type 
`rmarkdown::render("example.Rmd")`
to run the script.
If all works fine, exit R with `q()`, then type `exit` to exit the container.

But if there are errors, you'll need to modify the script and re-run it.
The changes need to be copied back to your main git repo, which can be done using
[Magic-Wormhole](https://magic-wormhole.readthedocs.io/en/latest/).

(It isn't recommended to do it using git commit/push from inside the container 
as it might expose your ssh key publicly.)

### 6. Working with containers and images

If you want to retrieve some data from a container, it is possible with the
`docker cp` command.

But first, you need to identify the last container, which contains the data of interest.

```
docker ps -alq
```

For example we can use this to copy the html report from inside the container to the
working directory.

```
docker cp $(docker ps -alq):udocker_r_example/example.html .
```

OPTIONAL: If you're happy with the performance of the container, 
it can be pushed to DockerHub so it is available to anyone on the web.
Note that you will need to create an account with Dockerhub and login on
the command line for it to work.

```
docker push example
```

Now the image can be accessed from other computers and by other users.

You may also want to archive the docker image as an `tar` archive.
This will enable sharing of your container on a site like Zenodo.
This is a good idea, as there is no guarantee dockerhub will provide
services long into the future.

In this example command, the image is written to a compressed `tar.gz` file to save
disk space.

```
docker save example | gzip > example.tar.gz
```

### 7. Confirming everything works

Download the image using `pull`.

```
docker pull username/r_example
```

## On a shared system

Without sudo access, you can use Udocker.

Installation and usage manual documentation can be found here:
https://indigo-dc.github.io/udocker/

```
udocker run username/r_example /bin/bash
```

At this point you can work on your app, develop your scripts, etc.
You'll see that the Dockerfile does a `git clone` of a github repo so
you will want to change it to your app.
Once development of the repo is complete, you can rebuild the image and
test the results are the same.

## Access udocker files/results

The containers that have been run are saved by default.
They can be deleted with `udocker rm <container-id>`.

If you want to retain some data and files from a container, they can be
found in the following path.

```
cd .udocker/containers/
```
