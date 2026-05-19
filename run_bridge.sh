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

# Start zenohd without exec, wait for it to be ready
ros2 run rmw_zenoh_cpp rmw_zenohd &
ZENOH_PID=$!
sleep 5

# Verify ROS 1 master is reachable before loading params
# rostopic list || { echo "Cannot reach ROS 1 master!"; exit 1; }

# Load bridge config into ROS 1 param server
rosparam load /bridge_topics.yaml

# Start the bridge (no exec so cleanup can happen)
ros2 run ros1_bridge parameter_bridge &
BRIDGE_PID=$!

# Trap to clean up background processes on exit
trap "kill $ZENOH_PID $BRIDGE_PID 2>/dev/null" EXIT
wait $BRIDGE_PID
