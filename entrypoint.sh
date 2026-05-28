#!/bin/bash
# shellcheck disable=SC1090,SC1091
set -e

# Source ROS 2 setup
source /opt/ros/"$ROS_DISTRO"/setup.bash

# Source the intern's local workspace (if it has been built)
if [ -f "/home/ros2_ws/install/setup.bash" ]; then
    source "/home/ros2_ws/install/setup.bash"
fi

# Setup colcon_cd
source /usr/share/colcon_cd/function/colcon_cd.sh
export _colcon_cd_root=/opt/ros/"$ROS_DISTRO"/

# Setup colcon tab completion
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

# Switch to CycloneDDS
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# TurtleBot3 model for Gazebo simulation
export TURTLEBOT3_MODEL=burger

# Execute the command passed into this entrypoint
exec "$@"
