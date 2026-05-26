#!/usr/bin/env bash
# Source this file to prepare a terminal for Sawyer ROS 2 work.
# Usage: source activate.sh   (or via the sawyer_msgs alias)

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

source /opt/ros/"${ROS_DISTRO:-kilted}"/setup.bash

if [[ -f "$REPO_DIR/ros2_msgs/install/setup.bash" ]]; then
    source "$REPO_DIR/ros2_msgs/install/setup.bash"
else
    echo "Note: Sawyer message types unavailable. Run: cd $REPO_DIR/ros2_msgs && colcon build"
fi

unset ROS_DOMAIN_ID
export RMW_IMPLEMENTATION=rmw_zenoh_cpp

echo ""
echo "  Sawyer ROS 2 environment ready"
echo "  --------------------------------"
echo "  ROS:  ${ROS_DISTRO}"
echo "  RMW:  ${RMW_IMPLEMENTATION}"
if [[ -f "$REPO_DIR/ros2_msgs/install/setup.bash" ]]; then
    echo "  Msgs: sawyer_core_msgs, baxter_motion_msgs"
fi
if docker ps --filter ancestor=ghcr.io/rethoughtrobotics/sawyer-zenoh:latest --format "{{.ID}}" 2>/dev/null | grep -q .; then
    echo "  Bridge: running"
else
    echo "  Bridge: not running — open a new terminal and run sawyer_start"
fi
echo ""