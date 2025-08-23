#!/bin/bash

# Qt5 安装脚本
# 功能：自动安装Qt5开发环境和相关依赖
# 作者：WackyPump
# 使用方法：chmod +x install_qt5.sh && ./install_qt5.sh

set -e

# 定义静默执行函数
quiet() {
    "$@" > /dev/null 2>&1
}

echo "======================================"
echo "  Qt5 开发环境自动安装脚本"
echo "======================================"

# 步骤1：安装基础编译工具链
echo "[1/5] 正在安装基础编译工具链..."
quiet sudo apt update
quiet sudo apt install gcc -y
quiet sudo apt install g++ -y
quiet sudo apt install make -y
#sudo apt install build-essential	#三合一
echo "[1/5] 基础编译工具链安装完成"

# 步骤2：可选安装Clang编译器
read -p "是否安装Clang编译器？(y/n, 默认n): " install_clang
if [[ $install_clang == "y" || $install_clang == "Y" ]]; then
    echo "[2/5] 正在安装Clang编译器..."
    quiet sudo apt install clang -y
    echo "[2/5] Clang编译器安装完成"
else
    echo "[2/5] 跳过Clang编译器安装"
fi

# 步骤3：安装make-guile
echo "[3/5] 正在安装make-guile..."
quiet sudo apt install make-guile -y
echo "[3/5] make-guile安装完成"

# 步骤4：安装CMake
echo "[4/5] 正在安装CMake..."
quiet sudo snap install cmake --classic
echo "[4/5] CMake安装完成"

# 步骤5：安装Qt5核心组件
echo "[5/5] 正在安装Qt5核心组件..."
echo "[5/5] 安装基本开发包..."
quiet sudo apt-get install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools

echo "[5/5] 安装Qt Creator IDE..."
quiet sudo apt-get install -y qtcreator

echo "[5/5] 安装常见依赖库..."
quiet sudo apt install -y libxcb-xinerama0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1

echo "[5/5] 安装附加Qt模块..."
quiet sudo apt-get install qtdeclarative5-dev -y
quiet sudo apt-get install -y \
    qt5-doc \
    qt5-image-formats-plugins \
    qt5-style-plugins \
    qml-module-qtquick2 \
    qml-module-qtquick-controls2 \
    qml-module-qtquick-dialogs

echo "[5/5] Qt5核心组件安装完成"

clear
echo "======================================"
echo "  Qt5 开发环境安装完成！"
echo "  您现在可以运行Qt Creator开始开发了:"
echo "  命令行输入: qtcreator"
echo "======================================"
