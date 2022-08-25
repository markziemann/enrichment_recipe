# Base image
FROM ubuntu:20.04

# Metadata
LABEl base.image="ubuntu:22.04"
LABEL version="1"
LABEL software="Image for ncRNA"
LABEL software.version="20220809"
LABEL description="Image for ncRNA"
LABEL website=""
LABEL documentation=""
LABEL license=""
LABEL tags="Genomics"

# Maintainer
MAINTAINER Mark Ziemann <mark.ziemann@gmail.com>

RUN rm /bin/sh && \
  ln /bin/bash /bin/sh

#numaverage numround numsum
RUN \
  apt-get clean all && \
  apt-get update && \
  apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata


RUN \
  apt-get install -y \
    libfontconfig1-dev \
    curl \
    nano \
    num-utils \
    wget \
    git \
    perl \
    zip \
    pigz \
    pbzip2 \
    unzip \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libtbb2 \
    openssh-server \
    pandoc \
    dirmngr \
    gnupg \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    libcairo2-dev

########################################
# install official R4.2
########################################
RUN apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'

RUN apt-get install -y r-base

########################################
# Authorize SSH Host
########################################
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

########################################
# now downloading a bunch of dependancies
# best to do this in the /sw directory
# also prep where the pipeline will run
# /mnt is for users own data
########################################
RUN mkdir sw

########################################
# Get the ncRNA repo
########################################
RUN git clone https://github.com/markziemann/udocker_r_example.git
ENV DIRPATH /udocker_r_example
WORKDIR $DIRPATH
RUN chmod -R 777 /udocker_r_example

########################################
# Get R packages based on own script
########################################
RUN echo "TZ=Etc/UTC" >> /root/.Renviron

RUN Rscript /udocker_r_example/rpkgs.R

########################################
# set entrypoint
########################################
#ENTRYPOINT [ "/dee2/code/volunteer_pipeline.sh" ]
