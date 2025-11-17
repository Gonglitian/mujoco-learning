# MuJoCo Learning 学习路径指南

本指南为 `mj_learning` 包提供循序渐进的学习路径，帮助你从零开始掌握机器人仿真、运动学、控制和强化学习。

## 📚 目录

- [前置知识](#前置知识)
- [阶段 1: MuJoCo 基础](#阶段-1-mujoco-基础)
- [阶段 2: 传感器与数据获取](#阶段-2-传感器与数据获取)
- [阶段 3: 运动学基础](#阶段-3-运动学基础)
- [阶段 4: 机器人控制](#阶段-4-机器人控制)
- [阶段 5: 路径规划](#阶段-5-路径规划)
- [阶段 6: 强化学习](#阶段-6-强化学习)
- [阶段 7: 高级应用](#阶段-7-高级应用)

---

## 前置知识

在开始学习之前，建议你具备以下基础：

### 必需
- ✅ Python 基础（变量、函数、类）
- ✅ NumPy 基础（数组操作、矩阵运算）
- ✅ 线性代数基础（向量、矩阵、旋转）

### 推荐
- 📖 机器人学基础（DH参数、正/逆运动学概念）
- 📖 控制理论基础（PID、状态空间）
- 📖 强化学习概念（MDP、策略、价值函数）

---

## 阶段 1: MuJoCo 基础

**目标**：熟悉 MuJoCo 仿真环境，掌握基本的模型加载、数据访问和可视化。

### 1.1 环境搭建与验证 ⭐ 必学

**学习内容**：
- 验证 MuJoCo 安装
- 了解 `mj_learning` 包结构
- 理解 `utils.MODEL_ROOT` 路径管理

**实践脚本**：
```bash
# 验证安装
uv run python test_imports.py
```

**关键概念**：
- MuJoCo 数据结构（`MjModel`, `MjData`）
- 仿真循环（`mj_step`, `mj_forward`）

---

### 1.2 基础可视化 ⭐ 必学

**模块**: `visualization/`

**学习顺序**：

1. **`mujoco_viewer.py`** - 自定义查看器基类
   ```bash
   # 查看源码，理解 CustomViewer 的结构
   cat mj_learning/visualization/mujoco_viewer.py
   ```
   - 学习如何创建自定义查看器
   - 理解 `runBefore()`, `runFunc()` 回调函数

2. **`panda_viewer.py`** - 基础查看器示例 🎥
   ```bash
   uv run python -m mj_learning.visualization.panda_viewer
   ```
   - 查看机械臂末端位姿
   - 学习 `data.body().xpos`, `data.body().xquat` 访问方式
   - [视频教程](https://www.bilibili.com/video/BV1gaXxYaEnv)

3. **`mujoco_quat_view.py`** - 四元数可视化
   ```bash
   uv run python -m mj_learning.visualization.mujoco_quat_view
   ```
   - 理解四元数与旋转矩阵转换
   - 使用 `utils.quat2rotmat()`, `utils.euler2rotmat()`

4. **`get_camera_pic.py`** - 相机渲染 🎥
   ```bash
   uv run python -m mj_learning.visualization.get_camera_pic
   ```
   - 离屏渲染（Offscreen rendering）
   - 相机参数设置
   - [视频教程](https://www.bilibili.com/video/BV1THGSzvE6t)

**作业**：
- [ ] 修改 `panda_viewer.py`，显示不同 body 的位置
- [ ] 创建一个新查看器，显示关节角度

---

## 阶段 2: 传感器与数据获取

**目标**：掌握 MuJoCo 的传感器系统，学会获取和记录仿真数据。

**模块**: `sensors/`

### 2.1 基础数据获取 ⭐ 必学

**学习顺序**：

1. **`get_body_pos.py`** - 刚体位置获取 🎥
   ```bash
   uv run python -m mj_learning.sensors.get_body_pos
   ```
   - `data.body(id).xpos` 位置
   - `data.body(id).xquat` 四元数
   - [视频教程](https://www.bilibili.com/video/BV1gaXxYaEnv)

2. **`set_and_get_qvel.py`** - 关节速度 🎥
   ```bash
   uv run python -m mj_learning.sensors.set_and_get_qvel
   ```
   - `data.qvel` 关节角速度
   - 数据记录与可视化
   - [视频教程](https://www.bilibili.com/video/BV1kSLdznEMd)

3. **`get_torque.py`** - 力矩分析 🎥
   ```bash
   uv run python -m mj_learning.sensors.get_torque
   ```
   - `data.qfrc_*` 力矩类型解析
   - 鼠标交互测试
   - [视频教程](https://www.bilibili.com/video/BV1kH79zUEAc)

---

### 2.2 高级传感器

4. **`contact_detect.py`** - 碰撞检测 🎥
   ```bash
   uv run python -m mj_learning.sensors.contact_detect
   ```
   - `data.contact` 碰撞信息
   - 接触力计算
   - [视频教程](https://www.bilibili.com/video/BV12WfFYYE4T)

5. **`move_ball.py`** - 键盘控制 🎥
   ```bash
   uv run python -m mj_learning.sensors.move_ball
   ```
   - 键盘输入处理
   - 实时位姿记录
   - [视频教程](https://www.bilibili.com/video/BV1oTZrYaE2h)

**作业**：
- [ ] 记录机械臂运动轨迹并绘图
- [ ] 实现碰撞检测报警系统

---

## 阶段 3: 运动学基础

**目标**：理解正/逆运动学，掌握多种 IK 求解器的使用。

**模块**: `kinematics/`

### 3.1 运动学库入门 ⭐ 必学

**学习顺序**：

1. **`test_pinocchio.py`** - Pinocchio 入门 🎥
   ```bash
   uv run python -m mj_learning.kinematics.test_pinocchio
   ```
   - Pinocchio 安装验证
   - 模型加载与关节限位
   - [视频教程](https://www.bilibili.com/video/BV1UFoRYDEfF)

2. **`pinocchio_urdf_test.py`** - URDF 正运动学
   ```bash
   uv run python -m mj_learning.kinematics.pinocchio_urdf_test
   ```
   - 从 URDF 构建模型
   - 正运动学计算
   - 雅可比矩阵

3. **`kdl_urdf_test.py`** - PyKDL 使用 🎥
   ```bash
   uv run python -m mj_learning.kinematics.kdl_urdf_test
   ```
   - KDL 树构建
   - KDL IK 求解器
   - [视频教程](https://www.bilibili.com/video/BV1RWMHzREg4)

---

### 3.2 逆运动学求解 ⭐⭐ 重要

4. **`ik_casadi_panda.py`** - CasADi IK 🎥
   ```bash
   uv run python -m mj_learning.kinematics.ik_casadi_panda
   ```
   - CasADi 优化框架
   - 非线性规划 IK
   - [视频教程](https://www.bilibili.com/video/BV1o38gzSE9h)

5. **`casadi_ik.py`** - CasADi IK 封装类
   ```bash
   # 查看源码，理解 Kinematics 类
   cat mj_learning/kinematics/casadi_ik.py
   ```
   - 通用 IK 类实现
   - 多机器人支持

---

### 3.3 高级运动学

6. **`ik_pyroboplan_so_arm100.py`** - PyRoboPlan IK
   ```bash
   uv run python -m mj_learning.kinematics.ik_pyroboplan_so_arm100
   ```
   - 微分 IK（CLIK）
   - 关节限位处理

7. **`ik_path_paln_trajectory_pyroboplan.py`** - IK + 路径规划 🎥
   ```bash
   uv run python -m mj_learning.kinematics.ik_path_paln_trajectory_pyroboplan
   ```
   - 笛卡尔空间路径规划
   - 轨迹优化
   - [视频教程](https://www.bilibili.com/video/BV1qA5EzPEFh)

**关键概念**：
- 正运动学（Forward Kinematics, FK）
- 逆运动学（Inverse Kinematics, IK）
- 雅可比矩阵（Jacobian）
- 微分逆运动学（Differential IK）

**作业**：
- [ ] 比较不同 IK 求解器的性能
- [ ] 实现有障碍物约束的 IK

---

## 阶段 4: 机器人控制

**目标**：掌握关节空间和笛卡尔空间控制方法。

**模块**: `control/`

### 4.1 关节空间控制 ⭐ 必学

**学习顺序**：

1. **`control_joint_pos.py`** - 位置控制 🎥
   ```bash
   uv run python -m mj_learning.control.control_joint_pos
   ```
   - 关节位置控制
   - `data.ctrl` 控制接口
   - [视频教程](https://www.bilibili.com/video/BV1pWoBYcETJ)

2. **`pid_torque_and_get.py`** - PID 力矩控制 🎥
   ```bash
   uv run python -m mj_learning.control.pid_torque_and_get
   ```
   - PID 控制器实现
   - 力矩模式控制
   - [视频教程](https://www.bilibili.com/video/BV1MbL6zSEAY)

3. **`joint_impedance_control.py`** - 关节阻抗控制 🎥
   ```bash
   uv run python -m mj_learning.control.joint_impedance_control
   ```
   - 阻抗控制原理
   - 柔顺控制
   - [视频教程](https://www.bilibili.com/video/BV1UK5czMEQr)

4. **`impedance_control.py`** - 阻抗控制变体
   ```bash
   uv run python -m mj_learning.control.impedance_control
   ```

---

### 4.2 笛卡尔空间控制 ⭐⭐ 重要

5. **`control_ee_with_pinocchio.py`** - CLIK 控制 🎥
   ```bash
   uv run python -m mj_learning.control.control_ee_with_pinocchio
   ```
   - 闭环逆运动学控制
   - Pinocchio 雅可比
   - [视频教程](https://www.bilibili.com/video/BV1aAZYYAE5f)

6. **`control_ee_with_pinocchio_so100.py`** - SO-ARM100 控制 🎥
   ```bash
   uv run python -m mj_learning.control.control_ee_with_pinocchio_so100
   ```
   - SO-ARM100 末端控制
   - [视频教程](https://www.bilibili.com/video/BV1o38gzSE9h)

---

### 4.3 实机控制（可选）

7. **`so100_real_control.py`** - Sim2Real 🎥
   ```bash
   uv run python -m mj_learning.control.so100_real_control
   ```
   - ZMQ 通信
   - 仿真到实机
   - [视频教程](https://www.bilibili.com/video/BV1gHeHz7ETT)

**关键概念**：
- 关节空间 vs 笛卡尔空间
- PID 控制（比例-积分-微分）
- 阻抗控制（Impedance Control）
- CLIK（Closed-Loop Inverse Kinematics）

**作业**：
- [ ] 调试 PID 参数实现平滑运动
- [ ] 实现末端力控制

---

## 阶段 5: 路径规划

**目标**：学习路径规划算法和轨迹优化方法。

**模块**: `path_planning/`

### 5.1 采样规划 ⭐⭐ 重要

**学习顺序**：

1. **`path_plan_ompl_rrtconnect.py`** - RRT 规划 🎥
   ```bash
   uv run python -m mj_learning.path_planning.path_plan_ompl_rrtconnect
   ```
   - OMPL 库使用
   - RRT-Connect 算法
   - [视频教程](https://www.bilibili.com/video/BV1EJd5YQExw)

2. **`path_plan_pyroboplan_rrt.py`** - PyRoboPlan RRT 🎥
   ```bash
   uv run python -m mj_learning.path_planning.path_plan_pyroboplan_rrt
   ```
   - RRT + 轨迹优化
   - 碰撞检测
   - [视频教程](https://www.bilibili.com/video/BV1tZo7YjEgd)

3. **`path_plan_pyroboplan_rrt_draw_trajectory.py`** - 轨迹可视化 🎥
   ```bash
   uv run python -m mj_learning.path_planning.path_plan_pyroboplan_rrt_draw_trajectory
   ```
   - 末端轨迹绘制
   - [视频教程](https://www.bilibili.com/video/BV1B2ocYSE7r)

---

### 5.2 轨迹优化

4. **`trajectory_plan_toppra.py`** - 时间最优轨迹 🎥
   ```bash
   uv run python -m mj_learning.path_planning.trajectory_plan_toppra
   ```
   - TOPPRA 算法
   - 速度/加速度约束
   - [视频教程](https://www.bilibili.com/video/BV1fndxYSEui)

**关键概念**：
- RRT (Rapidly-exploring Random Tree)
- 碰撞检测（Collision Detection）
- 轨迹优化（Trajectory Optimization）
- TOPPRA (Time-Optimal Path Parameterization)

**作业**：
- [ ] 在有障碍物环境中规划路径
- [ ] 比较不同规划算法的效率

---

## 阶段 6: 强化学习

**目标**：使用深度强化学习训练机器人策略。

**模块**: `reinforcement_learning/`

### 6.1 RL 基础 ⭐⭐⭐ 高级

**前置知识**：
- 强化学习基础（Q-learning, Policy Gradient）
- Stable-Baselines3 库

**学习顺序**：

1. **`rl_panda.py`** - PPO 逆运动学 🎥
   ```bash
   uv run python -m mj_learning.reinforcement_learning.rl_panda
   ```
   - PPO 算法
   - 自定义 Gym 环境
   - [视频教程](https://www.bilibili.com/video/BV1mHLVzzEMj)

2. **`rl_panda_reach_target_high_profile.py`** - 到达任务 🎥
   ```bash
   uv run python -m mj_learning.reinforcement_learning.rl_panda_reach_target_high_profile
   ```
   - 末端到达任务
   - 奖励函数设计
   - [视频教程](https://www.bilibili.com/video/BV1DAskzmEPZ)

---

### 6.2 RL 进阶

3. **`rl_panda_obstacle.py`** - 避障训练
   ```bash
   uv run python -m mj_learning.reinforcement_learning.rl_panda_obstacle
   ```
   - 动态障碍物
   - 碰撞惩罚

4. **`rl_panda_obstacle_high_profile.py`** - 高性能避障
   ```bash
   uv run python -m mj_learning.reinforcement_learning.rl_panda_obstacle_high_profile
   ```
   - 并行环境训练
   - 性能优化

5. **`rl_panda_obstacle_test.py`** - 模型测试
   ```bash
   uv run python -m mj_learning.reinforcement_learning.rl_panda_obstacle_test
   ```

6. **`add_random_obstacle.py`** - 障碍物生成
   ```bash
   uv run python -m mj_learning.reinforcement_learning.add_random_obstacle
   ```

**关键概念**：
- MDP (Markov Decision Process)
- PPO (Proximal Policy Optimization)
- Reward Shaping（奖励塑造）
- Gym 环境接口

**作业**：
- [ ] 设计新的奖励函数
- [ ] 训练避障策略

---

## 阶段 7: 高级应用

**目标**：学习手柄控制、动作捕捉等高级功能。

### 7.1 手柄控制

**模块**: `joystick/`

**学习顺序**：

1. **`test_joystick.py`** - 手柄测试
   ```bash
   uv run python -m mj_learning.joystick.test_joystick
   ```
   - pygame 手柄接口

2. **`joystick_so100.py`** - 仿真控制 🎥
   ```bash
   uv run python -m mj_learning.joystick.joystick_so100
   ```
   - Xbox 手柄映射
   - [视频教程](https://www.bilibili.com/video/BV1fyYLzVEbW)

3. **`joystick_sim_and_real_so100.py`** - 仿真+实机 🎥
   ```bash
   uv run python -m mj_learning.joystick.joystick_sim_and_real_so100
   ```
   - 双场景控制
   - [视频教程](https://www.bilibili.com/video/BV1RCp1zFE2v)

---

### 7.2 动作捕捉

**模块**: `mocap/`

**`mocap_panda.py`** - Mocap 接口 🎥
```bash
uv run python -m mj_learning.mocap.mocap_panda
```
- MuJoCo mocap 接口
- 键盘控制 mocap 体
- [视频教程](https://www.bilibili.com/video/BV1k651zXEeN)

---

### 7.3 视觉伺服

**模块**: `visualization/`

**`panda_pbvs.py`** - 位置视觉伺服 🎥
```bash
uv run python -m mj_learning.visualization.panda_pbvs
```
- PBVS (Position-Based Visual Servoing)
- 姿态误差控制
- [视频教程](https://www.bilibili.com/video/BV18zC5BNEt6)

---

### 7.4 格式转换

**模块**: `converters/`

**`mjcf2usd.py`** - MJCF 转 USD
```bash
uv run python -m mj_learning.converters.mjcf2usd
```
- USD 导出

---

### 7.5 测试工具

**模块**: `tests/`

1. **`test_pyroboplan.py`** - PyRoboPlan 测试 🎥
   ```bash
   uv run python -m mj_learning.tests.test_pyroboplan
   ```
   - [视频教程](https://www.bilibili.com/video/BV1Rod6YHET2)

2. **`test_why_continuous_2q.py`** - Continuous 关节问题 🎥
   ```bash
   uv run python -m mj_learning.tests.test_why_continuous_2q
   ```
   - [视频教程](https://www.bilibili.com/video/BV1tvVrzmEgx)

3. **`test_dh.py`** - DH 参数测试
   ```bash
   uv run python -m mj_learning.tests.test_dh
   ```

---

## 📝 学习建议

### 按主题学习路径

#### 路径 A: 仿真与可视化方向
```
阶段1 → 阶段2 → 阶段7.3 (PBVS) → 阶段7.1 (手柄)
```

#### 路径 B: 运动规划方向
```
阶段1 → 阶段3 (运动学) → 阶段5 (路径规划) → 阶段4 (控制)
```

#### 路径 C: 强化学习方向
```
阶段1 → 阶段2 → 阶段4 (控制) → 阶段6 (RL)
```

#### 路径 D: 实机应用方向
```
阶段1 → 阶段3 → 阶段4 → 阶段7.1 (手柄) → 阶段4.3 (Sim2Real)
```

---

## 💡 学习技巧

1. **循序渐进**：先掌握基础，再学习高级内容
2. **动手实践**：运行每个示例，修改参数观察效果
3. **完成作业**：每个阶段的作业帮助巩固知识
4. **观看视频**：配合视频教程理解更深入
5. **阅读源码**：`mj_learning` 的代码是学习资源
6. **提问交流**：遇到问题及时查文档或提issue

---

## 🎓 进阶资源

### 官方文档
- [MuJoCo Documentation](https://mujoco.readthedocs.io/)
- [Pinocchio Documentation](https://gepettoweb.laas.fr/doc/stack-of-tasks/pinocchio/master/doxygen-html/)
- [CasADi Documentation](https://web.casadi.org/)
- [Stable-Baselines3 Docs](https://stable-baselines3.readthedocs.io/)

### 推荐书籍
- 《机器人学导论》- John J. Craig
- 《现代机器人学》- Kevin M. Lynch
- 《Reinforcement Learning: An Introduction》- Sutton & Barto

### 视频教程
- 所有带 🎥 标记的示例都有配套视频教程
- [作者 Bilibili 频道](https://space.bilibili.com/445308449)

---

## ⚠️ 常见问题

### Q1: 某个脚本运行报错怎么办？
- 检查依赖是否安装：`uv run python test_imports.py`
- 查看错误信息，确认模型文件路径是否正确
- 参考视频教程中的操作

### Q2: 如何选择 IK 求解器？
- **快速原型**: PyKDL（简单易用）
- **优化质量**: CasADi（非线性优化，质量高）
- **约束复杂**: PyRoboPlan（支持关节限位、碰撞）

### Q3: 强化学习训练很慢？
- 使用 GPU（PyTorch with CUDA）
- 增加并行环境数量（`n_envs` 参数）
- 简化环境/降低渲染频率

### Q4: 实机控制需要什么硬件？
- SO-ARM100 机械臂
- ZMQ 通信环境
- 参考 `so100_real_control.py` 配置

---

## 🎯 学习检查清单

完成以下任务，说明你已掌握 `mj_learning`：

- [ ] 能创建自定义 MuJoCo 查看器
- [ ] 理解并实现至少 2 种 IK 求解方法
- [ ] 实现 PID 和阻抗控制器
- [ ] 完成有障碍物的路径规划
- [ ] 训练一个简单的 RL 策略
- [ ] 使用手柄控制仿真机器人
- [ ] 阅读并理解 `mj_learning` 核心代码

---

**祝学习愉快！🚀**

如有问题，欢迎提 issue 或查看视频教程。

