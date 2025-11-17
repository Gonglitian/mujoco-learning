#!/bin/bash
# PyKDL 安装脚本
# 功能：从源码编译安装 Orocos KDL 和 Python 绑定
# 需要：确保已创建并激活 uv 虚拟环境

set -e  # 遇到错误立即退出

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "项目根目录: $PROJECT_ROOT"
echo "构建目录: $SCRIPT_DIR"

# 检查虚拟环境
if [ -z "$VIRTUAL_ENV" ]; then
    echo "错误: 未检测到虚拟环境，请先激活虚拟环境"
    echo "提示: cd $PROJECT_ROOT && source .venv/bin/activate"
    exit 1
fi

echo "虚拟环境: $VIRTUAL_ENV"

# 获取 Python 版本
PYTHON_VERSION=$(python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
SITE_PACKAGES="$VIRTUAL_ENV/lib/python${PYTHON_VERSION}/site-packages"

echo "Python 版本: $PYTHON_VERSION"
echo "Site-packages: $SITE_PACKAGES"

# ========================================
# 安装 Orocos KDL
# ========================================
echo "=========================================="
echo "安装 Orocos KDL 和 Python 绑定"
echo "=========================================="

cd "$SCRIPT_DIR"

# 清理旧版本
if [ -d "orocos_kinematics_dynamics" ]; then
    echo "清理旧的 orocos_kinematics_dynamics 目录..."
    rm -rf orocos_kinematics_dynamics
fi

# 克隆仓库
echo "克隆 Orocos KDL 仓库..."
git clone https://github.com/orocos/orocos_kinematics_dynamics.git
cd orocos_kinematics_dynamics

# 安装核心 KDL 库
echo "编译 Orocos KDL 核心库..."
cd orocos_kdl
mkdir -p build && cd build
cmake ..
make -j$(nproc)
sudo make install

# 安装 Python 绑定
echo "编译 Python 绑定..."
cd ../../python_orocos_kdl

# 下载 pybind11
if [ ! -f "v2.13.0.zip" ]; then
    echo "下载 pybind11..."
    wget https://github.com/pybind/pybind11/archive/refs/tags/v2.13.0.zip
fi

if [ ! -d "pybind11" ]; then
    mkdir -p pybind11
fi

echo "解压 pybind11..."
unzip -o v2.13.0.zip
cp -r pybind11-2.13.0/* pybind11/

# 编译 Python 绑定
mkdir -p build && cd build
cmake .. -DPYTHON_EXECUTABLE="$(which python)"
make -j$(nproc)
sudo make install

# 复制到虚拟环境
echo "复制 PyKDL 到虚拟环境..."
mkdir -p "$SITE_PACKAGES"
cp PyKDL.*so* "$SITE_PACKAGES/" || echo "警告: 未找到 PyKDL.so 文件"

cd "$SCRIPT_DIR"
echo "✓ Orocos KDL 安装完成"

# 清理
echo "清理临时文件..."
rm -rf orocos_kinematics_dynamics

# ========================================
# 安装 kdl_parser
# ========================================
echo "=========================================="
echo "安装 kdl_parser"
echo "=========================================="

cd "$SCRIPT_DIR"

# 清理旧版本
if [ -d "kdl_parser" ]; then
    echo "清理旧的 kdl_parser 目录..."
    rm -rf kdl_parser
fi

# 克隆仓库 (使用 HTTPS，避免 SSH 密钥问题)
echo "克隆 kdl_parser 仓库..."
git clone https://github.com/jvytee/kdl_parser.git
cd kdl_parser

# 安装到虚拟环境
echo "安装 kdl_parser..."
uv pip install .

cd "$SCRIPT_DIR"
echo "✓ kdl_parser 安装完成"

# 清理
echo "清理临时文件..."
rm -rf kdl_parser

echo ""
echo "=========================================="
echo "✓ PyKDL 和 kdl_parser 安装完成！"
echo "=========================================="
echo ""
echo "验证安装:"
echo "  python -c 'import PyKDL; print(PyKDL.__version__)'"
echo "  python -c 'import kdl_parser; print(\"kdl_parser OK\")'"
