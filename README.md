Docker image with Ubuntu 22.04 + ROS2 Humble + noVNC for ISMR2024 
=================================================================

Multiple Docker image "snapshots" are built for the ISMR Workshop tutorial. Those snapshots are taken at each major step to build the SlicerROS2. Those steps include:
- Base (Ubuntu 22.04, VNC, ROS Humble, and prerequisite libraries for 3D Slicer and ROS) ~4.96GB
- Slicer (Base + 3D Slicer build, and Extensions) ~20.4GB
- SlicerROS2 (Slicer + SlicerROS2 modules) ~22.7GB
- SlicerROS2 Lightweight (Base + 3D Slicer binary package + Extension binary package + PLUS  + ROS2 workspace folder) 11.9GB

Each image uses the previous image as a base (e.g., SlicerROS2 uses Slicer) except for SlicerROS2 Lightweight, which uses the Base image as a base and incorporates the Slicer and Extension binary packages extracted from SlicerROS2 image. 


Building Docker Image (Not needed for end-users)
------------------------------------------------
The Dockerfile repository can be obtained by cloning the repository at GitHub. Please note that '--recursive' option is required to build the image correctly. `ismr2024` branch is used for the ISMR 2023 workshop:

~~~~
$ git clone https://github.com/rosmed/docker-ubuntu-22.04-ros2-novnc
$ cd docker-ubuntu-22.04-ros2-novnc
$ git checkout ismr2024
~~~~

To build an image, run the following command:
~~~~
# Base image
$ docker build . -t rosmed/docker-ubuntu-22.04-ros2:ismr2023
# Slicer image
$ docker build -f Dockerfile.slicer . -t rosmed/docker-ubuntu-22.04-ros2-slicer:ismr2024
# SlicerROS2 image
$ docker build -f Dockerfile.slicerros2 . -t rosmed/docker-ubuntu-22.04-ros2-slicerros2:ismr2024
# SlicerROS2 Lightweight image
$ docker build -f Dockerfile.slicerros2.lw . -t rosmed/docker-ubuntu-22.04-ros2-slicerros2-lw:ismr2024 
~~~~

Please note that the colcon build process in this Docker build may fail due to memory shortage. If it fails, consider increasing the memory size assigned to the Docker image. The current Docker file was tested on macOS Big Sur + Docker Desktop 4.01. Six CPUs, 16GB memory, 1GB swap, and 69.6GB disk image were assigned.

To push the image to Docker Hub:
~~~~
$ docker login -u <<myusername>> 
$ docker push rosmed/docker-ubuntu-22.04-ros2:ismr2024
$ docker push rosmed/docker-ubuntu-22.04-ros2-slicer:ismr2024
$ docker push rosmed/docker-ubuntu-22.04-ros2-slicerros2:ismr2024
$ docker push rosmed/docker-ubuntu-22.04-ros2-slicerros2-lw:ismr2024
~~~~
NOTE: User `myusername` has to have write access for the repository.

To save the docker image to a file:
~~~~
$ docker save rosmed/docker-ubuntu-22.04-ros2-slicerros2-lw:ismr2024 | gzip > ismr2024-docker-slicerros2.tar.gz
~~~~

To load the docker image on the computer:
~~~~
$ docker load < ismr2024-docker-slicerros2.tar.gz
~~~~



Running Docker image
---------------------

If you run the image available in the Docker Hub, pull the image using the following command:
~~~~
$ docker pull rosmed/docker-ubuntu-22.04-ros2-slicerros2-lw:ismr2024
~~~~

To execute the docker image, call the following command:
~~~~
$ docker run -it --rm -p 6080:80 rosmed/docker-ubuntu-22.04-ros2-slicerros2-lw:ismr2024
~~~~

In this example, the web port on the docker container will be mapped to port 6080 on the host computer. The desktop can be accessed at http://127.0.0.1:6080/ from a web browser.

The '--rm' option will remove the container upon termination. Optionally, if you want to connect 3D Slicer with a process running on the host using OpenIGTLink by mapping the local (host) port 28944 to the guest OS's port 18944, use the following command to run the Docker image instead:
~~~~
$ docker run -it --rm -p 6080:80 -p 28944:18944 rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2023
~~~~


The original dockerfile was derived from [docker-ubuntu_22-04-novnc](https://github.com/Frederic-Boulanger-UPS/docker-ubuntu_22-04-novnc). 



VNC Viewer
------------------

Forward VNC service port 5900 to host by

```
docker run -p 6080:80 -p 5900:5900 rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2023
```

Now, open the vnc viewer and connect to port 5900. If you would like to protect vnc service by password, set environment variable `VNC_PASSWORD`, for example

```
docker run -p 6080:80 -p 5900:5900 -e VNC_PASSWORD=mypassword rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2023
```

A prompt will ask password either in the browser or vnc viewer.

HTTP Base Authentication
---------------------------

This image provides base access authentication of HTTP via `HTTP_PASSWORD`

```
docker run -p 6080:80 -e HTTP_PASSWORD=mypassword rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2023
```

SSL
--------------------

To connect with SSL, generate self signed SSL certificate first if you don't have it

```
mkdir -p ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl/nginx.key -out ssl/nginx.crt
```

Specify SSL port by `SSL_PORT`, certificate path to `/etc/nginx/ssl`, and forward it to 6081

```
docker run -p 6081:443 -e SSL_PORT=443 -v ${PWD}/ssl:/etc/nginx/ssl rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2023
```

Screen Resolution
------------------

The Resolution of virtual desktop adapts browser window size when first connecting the server. You may choose a fixed resolution by passing `RESOLUTION` environment variable, for example

```
docker run -p 6080:80 -e RESOLUTION=1920x1080 rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2023
```

Default Desktop User
--------------------

The default user is `root`. You may change the user and password respectively by `USERNAME`, `USERID` and `PASSWORD` environment variables, for example,

```
docker run -p 6080:80 -e USERNAME=`id -n -u` -e USERID=`id -u` -e PASSWORD=password rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2023
```

This way, you will have the same name and uid in the container as on the host machine, which is very convenient when you mount a directory in the container using ```--volume```.


Deploy to a subdirectory (relative url root)
--------------------------------------------

You may deploy this application to a subdirectory, for example `/some-prefix/`. You then can access application by `http://127.0.0.1:6080/some-prefix/`. This can be specified using the `RELATIVE_URL_ROOT` configuration option like this

```
docker run -p 6080:80 -e RELATIVE_URL_ROOT=some-prefix rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2023
```

NOTE: this variable should not have any leading and trailing slash (/)

Use as a base image
-------------------
You may use this image as a base image to benefit from the GUI in a web browser, and install additional software.
You can customize the startup process of the container by adding shell scripts to the ```/etc/startup/``` folder. Any readable file with extension ```.sh``` placed in this folder will be sourced at this end of the startup process. You may use the following variables in your script:
* ```$USER``` is the user name of the user connected to the session
* ```$HOME``` is the home directory of that user
* ```$RESOLUTION```, if defined, is the resolution of the display, in the form ```<width>x<height>``` in pixels.


License
==================

Apache License Version 2.0, January 2004 http://www.apache.org/licenses/LICENSE-2.0

Original work by [Doro Wu](https://github.com/fcwu) and [Frédéric Boulanger](https://github.com/Frederic-Boulanger-UPS)
