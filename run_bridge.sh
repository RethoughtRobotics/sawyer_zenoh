#!/usr/bin/env bash
set -e

export ROS_MASTER_URI=${ROS_MASTER_URI:-http://10.42.0.2:11311}
export ROS_IP=${ROS_IP:-10.42.0.1}
unset ROS_HOSTNAME
unset ROS_DOMAIN_ID

source /opt/ros/one/setup.bash
source /ros1_ws/devel/setup.bash
source /opt/ros/kilted/setup.bash
source /ros2_ws/install/setup.bash
source /bridge_ws/install/local_setup.bash

export RMW_IMPLEMENTATION=rmw_zenoh_cpp

ros2 run rmw_zenoh_cpp rmw_zenohd &
ZENOH_PID=$!
trap 'kill "$ZENOHD_PID" 2>/dev/null; wait "$ZENOHD_PID" 2>/dev/null' EXIT

echo "Waiting for zenoh daemon (pid $ZENOH_PID)..."

until timeout 1 bash -c 'echo >/dev/tcp/localhost/7447' 2>/dev/null; do
    kill -0  "$ZENOH_PID" 2>/dev/null || { echo "ERROR: zenohd exited unexpectedly" >&2; exit 1;}
    sleep 1
done
echo "Zenoh daemon ready."

MASTER_HOST="${ROS_MASTER_URI#http://}"
MASTER_HOST="${MASTER_HOST%:*}"
MASTER_PORT="${ROS_MASTER_URI##*:}"
echo "Waiting for ROS master at $ROS_MASTER_URI..."
until timeout1 bash -c "echo >/dev/tcp/${MASTER_HOST}/${MASTER_PORT}" 2>/dev/null; do
    sleep 2
done
echo "ROS master ready."

rosparam load /bridge_topics.yaml

ros2 run ros1_bridge parameter_bridge 
