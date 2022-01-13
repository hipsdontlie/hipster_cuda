!/bin/bash
# Manipulation dependencies inside docker container
# Author: Kaushik Balasundar

#Env variables
HOME=/home/hipster
CATKIN_WS=/home/hipster/arthur_ws
CATKIN_SRC=/home/hipster/arthur_ws/src
ROS_DISTRO=melodic

#Setup REPO
echo "hipster" | sudo -S apt -y update
echo "hipster" | sudo -S apt -y upgrade
echo "hipster" | sudo -S apt -y install curl terminator okular nano gedit 

#installing ROS dependencies
echo "Installing ROS dependencies"

echo "hipster" | sudo -S sudo apt -y install ros-$ROS_DISTRO-controller-interface ros-$ROS_DISTRO-controller-manager-msgs  \
                    ros-$ROS_DISTRO-hardware-interface ros-$ROS_DISTRO-controller-interface ros-$ROS_DISTRO-controller-manager \
                    ros-$ROS_DISTRO-controller-manager-msgs ros-$ROS_DISTRO-hardware-interface ros-$ROS_DISTRO-joint-limits-interface \
                    ros-$ROS_DISTRO-realtime-tools ros-$ROS_DISTRO-catkin python-catkin-tools ros-$ROS_DISTRO-moveit ros-$ROS_DISTRO-moveit-visual-tools \
                    ros-$ROS_DISTRO-octomap ros-$ROS_DISTRO-joint-state-publisher ros-$ROS_DISTRO-robot-state-publisher ros-$ROS_DISTRO-industrial-robot-client \
                    python-catkin-pkg python-catkin-tools python-pip python-git python-setuptools python-termcolor python-wstool \
                    usbutils can-utils ros-$ROS_DISTRO-filters libmuparser-dev ros-$ROS_DISTRO-joint-state-publisher-gui \
                    build-essential cmake git libpoco-dev libeigen3-dev ros-$ROS_DISTRO-rosparam-shortcuts \
                    ros-melodic-joint-trajectory-controller ros-melodic-ddynamic-reconfigure\
                    bc curl ca-certificates fakeroot gnupg2 libssl-dev lsb-release libelf-dev bison flex    \
                    ros-melodic-handeye ros-melodic-baldor ros-melodic-criutils \
                    sudo apt install build-essential cmake git pkg-config libgtk-3-dev \
                    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
                    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
                    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
                    libtbb2 libtbb-dev libdc1394-22-dev libopenexr-dev \
                    libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \ 
                    software-properties-common

source /opt/ros/$ROS_DISTRO/setup.bash
