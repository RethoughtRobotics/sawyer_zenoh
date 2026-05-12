#!/usr/bin/env bash

set -e 

source /opt/ros/one/setup.bash
source /ros1_ws/devel/setup.bash
source /opt/ros/kilted/setup.bash
source /ros2_ws/install/setup.bash
source /bridge_ws/install/local_setup.bash

export ROS_MASTER_URI=http://10.42.0.2:11311
export ROS_IP=10.42.0.1
unset ROS_HOSTNAME

export RMW_IMPLEMENTATION=rmw_zenoh_cpp

exec ros2 run rmw_zenoh_cpp rmw_zenohd  & sleep 3

rosparam load /bridge_topics.yaml

exec ros2 run ros1_bridge parameter_bridge

# exec ros2 run ros1_bridge dynamic_bridge --bridge-all-topics

