#!/bin/bash
# ROS 2 Humble Hawksbill Installation Script for Ubuntu
# Reference: https://docs.ros.org/en/humble/Installation/Alternatives/Ubuntu-Development-Setup.html


#set -euo pipefail
set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# 检查是否为root用户
if [ "$(id -u)" -eq 0 ]; then
    echo -e "${RED}错误：请不要使用root用户运行此脚本${NC}"
    exit 1
fi

# 检查Ubuntu版本
UBUNTU_VERSION=$(lsb_release -rs)
if [[ "$UBUNTU_VERSION" != "22.04" ]]; then
    echo -e "${RED}错误：ROS 2 Humble需要Ubuntu 22.04 (Jammy)${NC}"
    exit 1
fi

# 安装类型选择
while true; do
    echo -e "${YELLOW}请选择安装类型：${NC}"
    echo "1) 桌面版 (包含GUI工具)"
    echo "2) 基础版 (仅核心功能)"
    read -p "输入选择 [1/2] (默认1): " install_type
    install_type=${install_type:-1}
    
    if [[ "$install_type" =~ ^[12]$ ]]; then
        break
    else
	clear
        echo -e "${RED}错误：请输入1或2${NC}"
    fi
done

# 确认操作
while true; do
    echo -e "\n${YELLOW}即将安装以下组件：${NC}"
    echo "- 设置区域配置为en_US.UTF-8"
    echo "- 添加Universe仓库"
    echo "- 配置ROS 2 APT源"
    if [ "$install_type" -eq 1 ]; then
        echo "- 安装ros-humble-desktop"
    else
        echo "- 安装ros-humble-ros-base"
    fi
    echo "- 安装ros-dev-tools"

    read -p "是否继续？[Y/n] " confirm
    confirm=${confirm:-Y}
    
    if [[ "$confirm" =~ ^[YyNn]$ ]]; then
        if [[ "$confirm" =~ ^[Nn]$ ]]; then
            echo -e "${RED}安装已取消${NC}"
            exit 0
        fi
        break
    else
    	clear
        echo -e "${RED}错误：请输入Y或N${NC}"
    fi
done

# 函数：执行命令并检查状态
run_command() {
    echo -e "\n${GREEN}[执行]${NC} $*"
    if ! "$@"; then
        echo -e "${RED}错误：命令执行失败${NC}"
        exit 1
    fi
}

# 1. 设置区域设置
echo -e "\n${YELLOW}[1/5] 设置区域配置${NC}"
locale  # check for UTF-8

sudo apt update && sudo apt install locales -y
sudo locale-gen en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US
export LANG=en_US.UTF-8
export LANGUAGE=en_US
export LC_ALL=en_US.UTF-8

echo -e "${GREEN}当前区域设置：${NC}"
locale

echo -e "如果报错执行：sudo dpkg-reconfigure locales，在界面中选择en_US.UTF-8作为默认"

# 2. 设置软件源
echo -e "\n${YELLOW}[2/5] 配置软件源${NC}"
sudo apt install software-properties-common -y
sudo add-apt-repository universe -y

# 3. 安装ROS 2 APT源
echo -e "\n${YELLOW}[3/5] 配置ROS 2 APT源${NC}"
sudo apt update
sudo apt install curl -y

sudo apt update && sudo apt install curl -y
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb" # If using Ubuntu derivates use $UBUNTU_CODENAME
sudo apt install /tmp/ros2-apt-source.deb


# 4. 安装ROS 2
echo -e "\n${YELLOW}[4/5] 安装ROS 2${NC}"
if [ "$install_type" -eq 1 ]; then
    sudo apt install ros-humble-desktop -y
else
    sudo apt install ros-humble-ros-base -y
fi

# 5. 安装开发工具
echo -e "\n${YELLOW}[5/5] 安装开发工具${NC}"
run_command sudo apt install ros-dev-tools -y

# 安装完成
clear
echo "======================================"
echo -e "\n${GREEN}ROS 2 Humble 安装完成！${NC}"
echo "======================================"

# 检查是否已经存在ROS2初始化标记   
if ! grep -q "# >>> ROS2 initialize >>>" ~/.bashrc; then
    # 添加到.bashrc
    cat << 'EOF' >> ~/.bashrc

# >>> ROS2 initialize >>>
source /opt/ros/humble/setup.bash
# <<< ROS2 initialize <<<
EOF
    echo "ROS2初始化代码已添加到~/.bashrc"   
else
    echo "ROS2初始化代码已存在于~/.bashrc中，跳过添加"   
fi

