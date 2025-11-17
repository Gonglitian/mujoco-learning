#!/bin/bash 
# Pinocchio 安装脚本
# 功能：从源码编译安装 Eigenpy、CasADi 和 Pinocchio
# 需要：确保已创建并激活 uv 虚拟环境

set -e  # 遇到错误立即退出

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$SCRIPT_DIR/orocos_kinematics_dynamics"

echo "项目根目录: $PROJECT_ROOT"
echo "构建目录: $SCRIPT_DIR"

# 检查虚拟环境
if [ -z "$VIRTUAL_ENV" ]; then
    echo "错误: 未检测到虚拟环境，请先激活虚拟环境"
    echo "提示: cd $PROJECT_ROOT && source .venv/bin/activate"
    exit 1
fi

echo "虚拟环境: $VIRTUAL_ENV"

function installEigenpy () {
  echo "=========================================="
  echo "安装 Eigenpy"
  echo "=========================================="
  
  # 安装 numpy
  uv pip install numpy
  
  cd "$SCRIPT_DIR"
  
  # 清理旧版本
  if [ -d "eigenpy" ]; then
      echo "清理旧的 eigenpy 目录..."
      rm -rf eigenpy
  fi
  
  # 克隆仓库
  git clone https://github.com/stack-of-tasks/eigenpy.git
  cd eigenpy
  mkdir -p build && cd build
  
  # CMake 配置
  cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$VIRTUAL_ENV" \
    -DPYTHON_EXECUTABLE="$(which python)"

  # 编译和安装
  make -j$(nproc)
  make install
  
  cd "$SCRIPT_DIR"
  echo "✓ Eigenpy 安装完成"
}

function installCasADi(){
  echo "=========================================="
  echo "安装 CasADi"
  echo "=========================================="
  
  cd "$SCRIPT_DIR"
  
  # 清理旧版本
  if [ -d "casadi" ]; then
      echo "清理旧的 casadi 目录..."
      rm -rf casadi
  fi
  
  # 安装系统依赖
  echo "安装系统依赖..."
  sudo apt install swig liblapack-dev libblas-dev -y
  
  # 克隆仓库
  git clone https://github.com/casadi/casadi.git
  cd casadi
  mkdir -p build && cd build
  
  # CMake 配置
  cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DPYTHON_EXECUTABLE="$(which python)" \
      -DCMAKE_INSTALL_PREFIX="$VIRTUAL_ENV" \
      -DWITH_IPOPT=ON \
      -DWITH_PYTHON=ON

  # 编译和安装
  make -j$(nproc)
  make install
  
  cd "$SCRIPT_DIR"
  echo "✓ CasADi 安装完成"
}

function installPinocchio(){
  echo "=========================================="
  echo "安装 Pinocchio"
  echo "=========================================="
  
  cd "$SCRIPT_DIR"
  
  # 清理旧版本
  if [ -d "pinocchio" ]; then
      echo "清理旧的 pinocchio 目录..."
      rm -rf pinocchio
  fi
  
  # 克隆仓库 (使用 HTTPS，避免 SSH 密钥问题)
  git clone https://github.com/stack-of-tasks/pinocchio.git
  cd pinocchio
  
  # 切换到特定版本 (兼容 example-robot-data)
  echo "切换到兼容版本..."
  git reset --hard bb5658416724a36d5e8d2fb6c65614f39796f7f1
  
  mkdir -p build && cd build
  
  # CMake 配置
  cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-I${VIRTUAL_ENV}/include -L${VIRTUAL_ENV}/lib" \
    -DCMAKE_INSTALL_PREFIX="$VIRTUAL_ENV" \
    -DBUILD_WITH_CASADI_SUPPORT=ON \
    -DCMAKE_PREFIX_PATH="$VIRTUAL_ENV" \
    -DCMAKE_INCLUDE_PATH="${VIRTUAL_ENV}/include" \
    -Dcasadi_DIR="${VIRTUAL_ENV}/lib/cmake/casadi" \
    -DCMAKE_LIBRARY_PATH="${VIRTUAL_ENV}/lib"

  # 编译和安装
  make -j$(nproc)
  make install
  
  cd "$SCRIPT_DIR"
  echo "✓ Pinocchio 安装完成"
}

# 主执行流程
echo "=========================================="
echo "开始安装 Pinocchio 及其依赖"
echo "=========================================="

# 取消注释以下行来选择要安装的组件
# installEigenpy
# installCasADi
installPinocchio

echo ""
echo "=========================================="
echo "✓ 所有组件安装完成！"
echo "=========================================="
echo ""
echo "提示: 如果需要完整安装，请取消注释脚本中的 installEigenpy 和 installCasADi"
