#!/bin/bash

# Qt5 安装脚本
# 功能：自动安装Qt5开发环境和相关依赖
# 作者：WackyPump
# 使用方法：chmod +x install_qt5.sh && ./install_qt5.sh

#出错退出
set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "======================================"
echo "  Qt5 开发环境自动安装脚本"
echo "======================================"
echo ""

# 步骤1：安装基础编译工具链
echo -e "\n${YELLOW}[1/5] 正在安装基础编译工具链..${NC}"
sudo apt update
sudo apt install gcc -y		#安装gcc 
sudo apt install g++ -y		#安装g++
sudo apt install make -y	#安装make
#sudo apt install build-essential	#三合一

echo ""
echo ">>> 验证工具链安装:"
gcc --version | head -n 1
g++ --version | head -n 1
make -v | head -n 1
echo ""

# 步骤2：可选安装Clang编译器
read -p "是否安装Clang编译器？(y/n, 默认n): " install_clang
if [[ $install_clang == "y" || $install_clang == "Y" ]]; then
    echo -e "\n${YELLOW}[2/5] 正在安装Clang编译器...${NC}"
    sudo apt install clang -y	#安装clang
    echo ""
    clang -v | head -n 1
    clang++ -v | head -n 1
else
    echo -e "\n${YELLOW}[2/5] 跳过Clang编译器安装${NC}"
fi
echo ""

# 步骤3：安装make-guile
echo -e "\n${YELLOW}[3/5] 正在安装make-guile...${NC}"
sudo apt install make-guile -y
echo ""

# 步骤4：安装CMake
echo -e "\n${YELLOW}[4/5] 正在安装CMake...${NC}"
sudo snap install cmake --classic
echo ""
echo ">>> 验证CMake安装:"
cmake --version | head -n 1
echo ""

# 步骤5：安装Qt5核心组件
echo -e "\n${YELLOW}[5/5] 正在安装Qt5核心组件...${NC}"
echo ">>> 安装基本开发包..."
sudo apt-get install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools


echo ">>> 安装Qt Creator IDE..."
sudo apt-get install -y qtcreator

echo ">>> 安装常见依赖库..."
sudo apt install -y libxcb-xinerama0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1

echo ">>> 安装附加Qt模块..."
sudo apt-get install qtdeclarative5-dev -y
sudo apt-get install -y \
    qt5-doc \
    qt5-image-formats-plugins \
    qt5-style-plugins \
    qml-module-qtquick2 \
    qml-module-qtquick-controls2 \
    qml-module-qtquick-dialogs


echo ""
echo ">>> 验证Qt安装:"
qmake -version
echo ""

clear
echo "======================================"
echo "  Qt5 开发环境安装完成！"
echo "  您现在可以运行Qt Creator开始开发:"
echo "  命令行输入: qtcreator"
echo "======================================"
