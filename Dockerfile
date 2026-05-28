# Use the official ROS 2 Jazzy full desktop image as the base
FROM osrf/ros:jazzy-desktop-full

# Avoid user interaction prompts during apt installations
ENV DEBIAN_FRONTEND=noninteractive

# Update apt and install standard development and build tools
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    nano \
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep \
    python3-vcstool \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install all specific packages required across the ROS 2 Jazzy tutorials
RUN apt-get update && apt-get install -y \
    ros-jazzy-action-tutorials-cpp \
    ros-jazzy-action-tutorials-interfaces \
    ros-jazzy-action-tutorials-py \
    ros-jazzy-demo-nodes-cpp \
    ros-jazzy-demo-nodes-py \
    ros-jazzy-joint-state-publisher-gui \
    ros-jazzy-launch-testing-ament-cmake \
    ros-jazzy-launch-testing-ros \
    ros-jazzy-pendulum-control \
    ros-jazzy-pendulum-msgs \
    ros-jazzy-rmw-cyclonedds-cpp \
    ros-jazzy-ros2bag \
    ros-jazzy-rosbag2-storage-default-plugins \
    ros-jazzy-rqt* \
    ros-jazzy-sros2 \
    ros-jazzy-tf2-ros \
    ros-jazzy-tf2-tools \
    ros-jazzy-tlsf \
    ros-jazzy-tlsf-cpp \
    ros-jazzy-turtlesim \
    ros-jazzy-urdf-tutorial \
    ros-jazzy-xacro \
    && rm -rf /var/lib/apt/lists/*

# Initialize and update rosdep
RUN rosdep init || true \
    && rosdep update

# Set up the default workspace directory for the intern
WORKDIR /home/ros2_ws

# Copy the entrypoint script into the container and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint script to run every time the container starts
ENTRYPOINT ["/entrypoint.sh"]

# Default command to run after the entrypoint script
CMD ["bash"]
