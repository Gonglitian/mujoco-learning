# MuJoCo Learning

A comprehensive Python package for robotics learning with MuJoCo, featuring inverse kinematics, path planning, reinforcement learning, and real robot control.

## 📋 Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Package Structure](#package-structure)
- [Quick Start](#quick-start)
- [Tutorials](#tutorials)
- [Contributing](#contributing)

## ✨ Features

- 🤖 **Kinematics**: IK solvers using Pinocchio, CasADi, PyKDL, and PyRoboPlan
- 🎮 **Control**: Joint/Cartesian space control, impedance control, PID control
- 🛤️ **Path Planning**: RRT, OMPL integration, trajectory optimization with TOPPRA
- 🧠 **Reinforcement Learning**: PPO-based robotic arm control with Stable-Baselines3
- 📊 **Visualization**: Custom viewers, real-time trajectory plotting, camera rendering
- 🕹️ **Joystick Control**: Xbox controller support for simulation and real robot
- 🔄 **Sim2Real**: SO-ARM100 real robot control via ZMQ communication

## 🚀 Installation

### Prerequisites

- **Python 3.10** (recommended, 3.11+ may have compatibility issues with system Boost)
- [uv](https://github.com/astral-sh/uv) (recommended) or pip
- Ubuntu 20.04/22.04 or similar Linux distribution

### Basic Setup

```bash
# Clone the repository
git clone https://github.com/Gonglitian/mujoco-learning.git
cd mujoco-learning

# Create and activate virtual environment with Python 3.10
uv venv --python 3.10
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install Python dependencies
uv pip install -r requirements.txt
```

### Optional Dependencies

#### Install PyKDL (for KDL-based IK)

```bash
cd scripts
bash install_pykdl.sh
```

#### Install Pinocchio with CasADi Support (for advanced IK)

```bash
cd scripts
bash install_pinocchio.sh
```

See [tutorial video](https://www.bilibili.com/video/BV1mSghz1EUx/) for detailed installation guide.

## 📁 Package Structure

```
mujoco-learning/
├── mj_learning/              # Main package
│   ├── kinematics/          # IK solvers (Pinocchio, CasADi, PyKDL, PyRoboPlan)
│   ├── control/             # Robot controllers (PID, impedance, joint/cartesian)
│   ├── path_planning/       # Path planners (RRT, OMPL) and trajectory optimization
│   ├── reinforcement_learning/  # RL environments and trained models
│   ├── visualization/       # Custom MuJoCo viewers and rendering tools
│   ├── sensors/             # Sensor data processing and contact detection
│   ├── joystick/           # Joystick control interfaces
│   ├── mocap/              # Motion capture interface
│   ├── converters/         # Format converters (MJCF to USD)
│   ├── tests/              # Test scripts
│   └── utils.py            # Utility functions and MODEL_ROOT constant
├── model/                   # Robot URDF/MJCF models
├── assets/                  # Trained RL models and resources
├── scripts/                 # Installation scripts
└── test_imports.py         # Package validation script
```

## 🎯 Quick Start

### Validate Installation

```bash
# Test package imports
uv run python test_imports.py
```

### Basic Usage Examples

```python
# Import modules using standard package syntax
from mj_learning import utils
from mj_learning.visualization import mujoco_viewer
from mj_learning.kinematics import casadi_ik

# Model paths use centralized constant
import os
model_path = os.path.join(utils.MODEL_ROOT, "franka_emika_panda/scene.xml")
```

### Running Examples

All example scripts are located in the `mj_learning/` submodules:

```bash
# Kinematics example
uv run python -m mj_learning.kinematics.ik_casadi_panda

# Control example
uv run python -m mj_learning.control.joint_impedance_control

# Path planning example
uv run python -m mj_learning.path_planning.path_plan_pyroboplan_rrt

# Reinforcement learning
uv run python -m mj_learning.reinforcement_learning.rl_panda_reach_target_high_profile

# Visualization
uv run python -m mj_learning.visualization.panda_viewer

# Joystick control (requires Xbox controller)
uv run python -m mj_learning.joystick.joystick_so100
```

## 📚 Tutorials

All tutorials include video explanations (in Chinese) and complete source code.

### Kinematics & Inverse Kinematics

| File | Description | Video Tutorial |
|------|-------------|----------------|
| `kinematics/test_pinocchio.py` | Pinocchio installation and basic usage | [🎥 Watch](https://www.bilibili.com/video/BV1UFoRYDEfF) |
| `kinematics/ik_casadi_panda.py` | IK with Pinocchio + CasADi | [🎥 Watch](https://www.bilibili.com/video/BV1o38gzSE9h) |
| `kinematics/kdl_urdf_test.py` | PyKDL IK without ROS | [🎥 Watch](https://www.bilibili.com/video/BV1RWMHzREg4) |
| `tests/test_pyroboplan.py` | PyRoboPlan differential IK with constraints | [🎥 Watch](https://www.bilibili.com/video/BV1Rod6YHET2) |
| `kinematics/ik_path_paln_trajectory_pyroboplan.py` | Cartesian IK + path planning + trajectory optimization | [🎥 Watch](https://www.bilibili.com/video/BV1qA5EzPEFh) |

### Robot Control

| File | Description | Video Tutorial |
|------|-------------|----------------|
| `control/control_joint_pos.py` | Joint space position control | [🎥 Watch](https://www.bilibili.com/video/BV1pWoBYcETJ) |
| `control/control_ee_with_pinocchio.py` | Cartesian CLIK control with Pinocchio | [🎥 Watch](https://www.bilibili.com/video/BV1aAZYYAE5f) |
| `control/control_ee_with_pinocchio_so100.py` | SO-ARM100 end-effector control | [🎥 Watch](https://www.bilibili.com/video/BV1o38gzSE9h) |
| `control/pid_torque_and_get.py` | PID torque control | [🎥 Watch](https://www.bilibili.com/video/BV1MbL6zSEAY) |
| `control/joint_impedance_control.py` | Joint space impedance control | [🎥 Watch](https://www.bilibili.com/video/BV1UK5czMEQr) |
| `control/so100_real_control.py` | Sim2Real: SO-ARM100 real robot control | [🎥 Watch](https://www.bilibili.com/video/BV1gHeHz7ETT) |

### Path Planning & Trajectory Optimization

| File | Description | Video Tutorial |
|------|-------------|----------------|
| `path_planning/path_plan_ompl_rrtconnect.py` | RRT path planning with OMPL | [🎥 Watch](https://www.bilibili.com/video/BV1EJd5YQExw) |
| `path_planning/path_plan_pyroboplan_rrt.py` | RRT planning + trajectory optimization | [🎥 Watch](https://www.bilibili.com/video/BV1tZo7YjEgd) |
| `path_planning/path_plan_pyroboplan_rrt_draw_trajectory.py` | End-effector trajectory visualization | [🎥 Watch](https://www.bilibili.com/video/BV1B2ocYSE7r) |
| `path_planning/trajectory_plan_toppra.py` | Time-optimal trajectory planning with TOPPRA | [🎥 Watch](https://www.bilibili.com/video/BV1fndxYSEui) |

### Reinforcement Learning

| File | Description | Video Tutorial |
|------|-------------|----------------|
| `reinforcement_learning/rl_panda.py` | PPO for inverse kinematics | [🎥 Watch](https://www.bilibili.com/video/BV1mHLVzzEMj) |
| `reinforcement_learning/rl_panda_reach_target_high_profile.py` | PPO end-effector reaching task | [🎥 Watch](https://www.bilibili.com/video/BV1DAskzmEPZ) |
| `reinforcement_learning/rl_panda_obstacle.py` | Obstacle avoidance with RL | - |
| `reinforcement_learning/add_random_obstacle.py` | Dynamic obstacle generation | - |

### Visualization & Sensors

| File | Description | Video Tutorial |
|------|-------------|----------------|
| `visualization/panda_viewer.py` | Custom MuJoCo viewer | [🎥 Watch](https://www.bilibili.com/video/BV1gaXxYaEnv) |
| `visualization/panda_pbvs.py` | Position-Based Visual Servoing (PBVS) | [🎥 Watch](https://www.bilibili.com/video/BV18zC5BNEt6) |
| `visualization/get_camera_pic.py` | Camera rendering and image capture | [🎥 Watch](https://www.bilibili.com/video/BV1THGSzvE6t) |
| `sensors/get_body_pos.py` | Real-time end-effector tracking | [🎥 Watch](https://www.bilibili.com/video/BV1gaXxYaEnv) |
| `sensors/get_torque.py` | Torque analysis with mouse interaction | [🎥 Watch](https://www.bilibili.com/video/BV1kH79zUEAc) |
| `sensors/set_and_get_qvel.py` | Joint velocity recording and visualization | [🎥 Watch](https://www.bilibili.com/video/BV1kSLdznEMd) |
| `sensors/contact_detect.py` | Contact and collision detection | [🎥 Watch](https://www.bilibili.com/video/BV12WfFYYE4T) |
| `sensors/move_ball.py` | Keyboard control with pose recording | [🎥 Watch](https://www.bilibili.com/video/BV1oTZrYaE2h) |

### Joystick Control

| File | Description | Video Tutorial |
|------|-------------|----------------|
| `joystick/joystick_so100.py` | Xbox controller for MuJoCo simulation | [🎥 Watch](https://www.bilibili.com/video/BV1fyYLzVEbW) |
| `joystick/joystick_sim_and_real_so100.py` | Dual-scene: simulation + real robot | [🎥 Watch](https://www.bilibili.com/video/BV1RCp1zFE2v) |

### Motion Capture & Others

| File | Description | Video Tutorial |
|------|-------------|----------------|
| `mocap/mocap_panda.py` | MuJoCo mocap interface | [🎥 Watch](https://www.bilibili.com/video/BV1k651zXEeN) |
| `tests/test_why_continuous_2q.py` | Pinocchio continuous joint issue | [🎥 Watch](https://www.bilibili.com/video/BV1tvVrzmEgx) |
| `converters/mjcf2usd.py` | MJCF to USD converter | - |

### Installation Guides

| File | Description | Video Tutorial |
|------|-------------|----------------|
| `scripts/install_pinocchio.sh` | Build Pinocchio from source with CasADi | [🎥 Watch](https://www.bilibili.com/video/BV1mSghz1EUx) |
| `scripts/install_pykdl.sh` | Build PyKDL from source | [🎥 Watch](https://www.bilibili.com/video/BV1RWMHzREg4) |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is open source and available under the MIT License.

## 🎓 Citation

If you find this repository helpful, please consider giving it a ⭐️!

## 📺 Author

Videos and tutorials: [@Bilibili](https://space.bilibili.com/445308449)

## 🙏 Acknowledgments

- [MuJoCo](https://mujoco.org/) - Physics engine
- [Pinocchio](https://github.com/stack-of-tasks/pinocchio) - Rigid body dynamics library
- [Stable-Baselines3](https://github.com/DLR-RM/stable-baselines3) - RL algorithms
- [PyRoboPlan](https://github.com/sea-bass/pyroboplan) - Robot planning library
