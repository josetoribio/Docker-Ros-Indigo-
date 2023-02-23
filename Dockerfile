FROM ros:indigo

RUN apt-get update

RUN chmod +x /bin/sh

RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y emacs
RUN apt-get install -y sudo
RUN apt-get install -y python-pip
RUN apt-get install -y net-tools
RUN apt-get install -y iproute2
RUN apt-get install -y iputils-ping
RUN apt-get install -y openssh-client openssh-server
RUN apt-get install -y ros-indigo-desktop-full

#baxter sdk dependencies
RUN apt-get install -y git-core
RUN apt-get install -y python-argparse
RUN apt-get install -y python-wstool
RUN apt-get install -y python-vcstools
RUN apt-get install -y python-rosdep
RUN apt-get install -y ros-indigo-control-msgs
RUN apt-get install -y ros-indigo-joystick-drivers

RUN apt-get install -y gdb
RUN apt-get install -y mlocate
RUN apt-get install -y screen
RUN apt-get install -y emacs
RUN apt-get install -y git
RUN apt-get install -y netcat nmap wget iputils-ping openssh-client vim less
RUN apt-get install -y python-numpy
RUN apt-get install -y python-smbus
RUN apt-get install -y python-scipy
RUN apt-get install -y locate

#copied and paste from pidrone dockerfile
ARG hostuser
ARG hostgroup
ARG hostuid
ARG hostgid
ARG hostname
ARG i2cgid
ARG dialoutgid
ARG videogid

RUN echo Host user is $hostuser:$hostuser
RUN groupadd --gid $hostgid $hostgroup
RUN groupmod --gid $i2cgid i2c; exit 0
RUN groupmod --gid $dialoutgid dialout
RUN groupmod --gid $videogid video
RUN adduser --disabled-password --gecos '' --gid $hostgid --uid $hostuid $hostuser
RUN adduser $hostuser sudo
RUN adduser $hostuser i2c
RUN adduser $hostuser dialout
RUN adduser $hostuser video


# Ensure sudo group users are not asked for a p3assword when using sudo command
# by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> \
/etc/sudoers

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

USER $hostuser
WORKDIR /home/$hostuser
ENV HOME=/home/$hostuser
RUN mkdir $HOME/repo
RUN mkdir -p $HOME/catkin_ws/src
RUN rosdep update
#baxter sdk install

RUN cd ~/catkin_ws/src
RUN  wstool init .
RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
RUN wstool update




CMD ["bash"]

