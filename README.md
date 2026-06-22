# ROS 2 Jazzy Tutorial Environment

Welcome! This repository contains a fully containerized ROS 2 Jazzy environment. It includes all the dependencies needed to complete the official [ROS 2 Tutorials](https://docs.ros.org/en/jazzy/Tutorials.html).

## 🚀 Quick Start Guide

### 1. Clone the repository
Open a terminal on your host machine and clone this repo:
```bash
git clone https://github.com/gglaspell/jazzy_tutorial.git
cd jazzy_tutorial
```

### 2. Allow GUI Passthrough (Linux Host Only)
Because you will be using graphical tools like Turtlesim and RViz2, you need to allow the Docker container to talk to your host's display server. Run this once per session:
```bash
xhost +local:root
```

### 3. Start the Environment
Build and start the container in the background using Docker Compose:
```bash
docker compose up -d
```
*(Note: The first time you run this, it will take a few minutes to download and build the ROS 2 Jazzy image).*

### 4. Enter the Container
To start working, open a bash shell inside the running container:
```bash
docker exec -it ros2_jazzy_tutorial_env bash
```
You should now see your terminal prompt change. You are inside the container! All the ROS 2 environment variables are automatically sourced for you.

### 5. Opening Multiple Terminals
ROS 2 requires running multiple nodes in separate terminals at the same time. Open a new terminal tab on your host machine and simply run the `docker exec` command again:
```bash
docker exec -it ros2_jazzy_tutorial_env /entrypoint.sh bash
```

## 📂 Where to write your code
Your code should go inside the `ros2_ws/src/` directory. This folder is bind-mounted from your host machine into the container.
* This means you can use your favorite code editor (like VS Code) on your **host machine** to edit the files, and then compile/run them **inside the container**.
* If the container is destroyed, your code is safe!

## 🛑 Stopping the Environment
When you are done for the day, exit your container terminals and run:
```bash
docker compose down
```

---

## 🔐 SROS2 Security Tutorial Setup

The security tutorials require a keystore and per-node enclave certificates. The `sros2/` folder contains helper scripts to set this up.

> **All commands below are run inside the container** unless noted otherwise.

### Step 1 — Generate the keystore and enclave keys

Run the setup script once. It is safe to re-run; it skips any step that is already complete.

```bash
bash /workspace/sros2/setup_sros2.sh
```

> **Note:** The `sros2/keystore/` directory in the repo contains only a `.gitkeep` placeholder. The script detects this correctly and creates a real keystore in its place.

### Step 2 — Enable security for the current terminal session

Source `secure_env.sh` in **every terminal** that will run a secured node:

```bash
source /workspace/sros2/secure_env.sh
```

This sets the three required environment variables:

| Variable | Value |
|---|---|
| `ROS_SECURITY_KEYSTORE` | absolute path to `sros2/keystore/` |
| `ROS_SECURITY_ENABLE` | `true` |
| `ROS_SECURITY_STRATEGY` | `Enforce` |

### Step 3 — Run the talker/listener demo

Open **Terminal A** inside the container, source `secure_env.sh`, then run the talker:

```bash
source /workspace/sros2/secure_env.sh
ros2 run demo_nodes_cpp talker --ros-args --enclave /talker_listener/talker
```

Open **Terminal B** inside the container, source `secure_env.sh`, then run the listener:

```bash
source /workspace/sros2/secure_env.sh
ros2 run demo_nodes_py listener --ros-args --enclave /talker_listener/listener
```

> **Jazzy requirement:** Enclave names must be **absolute paths** (start with `/`). Relative names like `talker_listener/talker` are rejected by the Jazzy security layer.
>
> **`--node-name` is not used here.** The `--ros-args --enclave` flag sets the *security enclave*, which is separate from the node name. Do not pass `--node-name` alongside `--enclave`.

### Troubleshooting

| Symptom | Fix |
|---|---|
| `secure_env.sh: No such file or directory` | Make sure you are using the path `/workspace/sros2/secure_env.sh` (not `sros2_demo/`) |
| `Security directory does not exist for enclave` | Re-run `setup_sros2.sh`; confirm enclave paths start with `/` |
| Setup script skips keystore creation even though it is empty | The fix is already applied: setup now checks for `identity_ca.cert.pem`, not just whether the folder is non-empty |
| Nodes connect but messages are not received | Verify both terminals have `ROS_SECURITY_STRATEGY=Enforce` and the same `ROS_SECURITY_KEYSTORE` |

---

## 🎓 ROS 2 Jazzy Tutorial Checklist

**Primary Resource:** [Tutorials — ROS 2 Documentation: Jazzy documentation](https://docs.ros.org/en/jazzy/Tutorials.html)

---

### 🟢 Beginner: CLI Tools (First Steps)
*Learn how to interact with ROS 2 from the command line.*

- [x] Configuring your ROS 2 environment *(✅ Handled by the Docker `entrypoint.sh` automatically sourcing the setup scripts)*
- [ ] Using `turtlesim`, `ros2`, and `rqt`
- [ ] Understanding ROS 2 nodes
- [ ] Understanding ROS 2 topics
- [ ] Understanding ROS 2 services
- [ ] Understanding ROS 2 parameters
- [ ] Understanding ROS 2 actions
- [ ] Using `rqt_console` to view logs
- [ ] Launching multiple nodes
- [ ] Recording and playing back data (`ros2 bag`)

### 🟡 Beginner: Client Libraries
*Write your first ROS 2 code in Python and/or C++.*

- [x] Using `colcon` to build packages *(✅ `colcon` is pre-installed in the Docker image. You should still read this tutorial to learn the `colcon build` command!)*
- [x] Creating a workspace *(✅ The `ros2_ws/src` folder is already created and mapped to the container)*
- [ ] Creating a package
- [ ] Writing a simple publisher and subscriber (C++)
- [ ] Writing a simple publisher and subscriber (Python)
- [ ] Writing a simple service and client (C++)
- [ ] Writing a simple service and client (Python)
- [ ] Creating custom `msg` and `srv` files
- [ ] Implementing custom interfaces
- [ ] Using parameters in a class (C++)
- [ ] Using parameters in a class (Python)
- [ ] Using `ros2doctor` to identify issues
- [ ] Creating and using plugins (C++)

### 🟠 Intermediate
*Level up with complex system architectures and foundational tools.*

- [x] Managing dependencies with `rosdep` *(✅ Note: `rosdep init` and `update` are handled by the Dockerfile, but read this to learn how to use `rosdep install` for new packages)*
- [ ] Creating a custom action
- [ ] Writing an action server and client (C++)
- [ ] Writing an action server and client (Python)
- [ ] Composing multiple nodes in a single process
- [ ] Monitoring for parameter changes
- [ ] **Launch tutorials:** Creating advanced launch files
- [ ] **tf2 tutorials:** Understanding coordinate frames and transforms
- [ ] **URDF tutorials:** Building a visual robot model from scratch

### 🔴 Advanced
*Explore under-the-hood configurations and performance tuning.*

- [ ] Enabling topic statistics
- [ ] Using Fast DDS Discovery Server
- [ ] Implementing a custom memory allocator
- [ ] Security tutorials (Setting up SROS2) — see [SROS2 setup section](#-sros2-security-tutorial-setup) above
- [ ] Recording a bag from a node (C++)
- [ ] Reading from a bag file (C++)
- [ ] Simulators (Connecting ROS 2 with Gazebo Harmonic)

### 🟣 Demos
*See ROS 2 in action with practical, real-world examples.*

- [ ] Quality of Service (QoS) features and degradation testing
- [ ] Managing nodes with Managed Nodes (Lifecycle nodes)
- [x] Using ROS 2 with Eclipse Cyclone DDS *(✅ Configured as our environment's default via `entrypoint.sh`)*
- [ ] Real-time programming in ROS 2 (Pendulum demo)
- [ ] Dummy robot demo
- [ ] Advanced logging and logger configuration
