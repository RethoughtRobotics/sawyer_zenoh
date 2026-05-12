FROM osrf/ros:kilted-desktop-full@sha256:c62c1847b106e214fe18b2b8c94222fd3d03897761cce3d16be063be6fc0461d

# ROS-O: Noetic on Ubuntu 24.04 Noble ──────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends curl gnupg && \
    curl -sSL https://ros.packages.techfak.net/gpg.key \
        -o /etc/apt/keyrings/ros-one-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ros-one-keyring.gpg] \
https://ros.packages.techfak.net noble main" \
        > /etc/apt/sources.list.d/ros1.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ros-one-desktop=1.5.0-1noble.20250602.0114 \
        python3-catkin-tools \
        python3-rosdep && \
    rm -rf /var/lib/apt/lists/*ao

# ROS 1 sawyer messages (catkin, built against ROS-O)
COPY ros1_msgs/ /ros1_ws/src/

RUN bash -c "\
    source /opt/ros/one/setup.bash && \
    cd /ros1_ws && \
    catkin_make"

# ROS 2 sawyer messages (colcon, built against Kilted)
COPY ros2_msgs/ /ros2_ws/src/

RUN bash -c "\
    source /opt/ros/kilted/setup.bash && \
    cd /ros2_ws && \
    colcon build --packages-select intera_core_msgs intera_motion_msgs"

# ros1_bridge from source (master, pinned)
RUN git clone --branch kilted --single-branch \
    https://github.com/andnet-deboer/ros1_bridge \
    /bridge_ws/src/ros1_bridge && \
    git -C /bridge_ws/src/ros1_bridge checkout

RUN bash -c "\
    source /opt/ros/one/setup.bash && \
    source /ros1_ws/devel/setup.bash && \
    source /opt/ros/kilted/setup.bash && \
    source /ros2_ws/install/setup.bash && \
    cd /bridge_ws && \
    colcon build --packages-select ros1_bridge --cmake-force-configure"

# rmw_zenoh_cpp
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-kilted-rmw-zenoh-cpp \
    && rm -rf /var/lib/apt/lists/*

# Entrypoint
COPY bridge_topics.yaml /bridge_topics.yaml
COPY run_bridge.sh /run_bridge.sh
RUN chmod +x /run_bridge.sh
ENTRYPOINT ["/run_bridge.sh"]
