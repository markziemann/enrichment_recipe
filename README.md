# Getting a working R environment in Docker and Udocker

By Mark Ziemann

Computational reproducibility is difficult, especially over longer timeframes.

Using a Docker image allows you to keep a stable compute environment with a
known version of operating system and R.
The downside of Docker is that it cannot be used on a shared system without
sudo administration rights.

Here I will walk you through the process of building a Docker image with 
Ubuntu 20 and R 4.0, push it to DockerHub and then using it as a Udocker
image on a cluster environment without sudo admin rights.

The Dockerfile provided can be customised to your project, currently it
installs a few packages but you can include whatever packages you need
from CRAN and Bioconductor.

## Building

This will create the Docker image which can be used locally.
Change the name of the image for your project.

```
docker build -t mziemann/r_example .
```

You can get a command line inside the image like this.

```
docker run -it -d mziemann/r_example bash
```

Type `exit` to leave the container

It is not recommended to make changes to the image setup, as it is
better to change the dockerfile (more reproducible).

If you did make changes to the image, by default these are not saved.
If you do want to retain those changes, you'll need to commit the changes.

You can list the used docker containers with `ps` and get the container
ID.

```
docker ps -a
```

Then commit the changes.

```
docker commit container_name mziemann/r_example
```

Now it can be pushed to DockerHub so it is available to anyone on the web.
Note that you will need to create an account with Dockerhub and login on
the command line for it to work.

```
docker push mziemann/r_example
```

Now the image can be accessed from other computers and by other users.

## Download the image

```
docker pull mziemann/r_example
```

## Run the image interactively

Get a bash prompt inside the container.

```
docker run --rm -it --entrypoint /bin/bash mziemann/r_example
```

## On a shared system

Without sudo access, you can use Udocker.

Installation and usage manual documentation can be found here:
https://indigo-dc.github.io/udocker/

```
udocker run mziemann/r_example /bin/bash
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
