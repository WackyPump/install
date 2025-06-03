#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查是否以root运行
if [ "$(id -u)" -eq 0 ]; then
    echo -e "${RED}错误：请不要直接使用root运行此脚本${NC}"
    echo -e "请使用普通用户运行，脚本会在需要时请求sudo权限"
    exit 1
fi

# 安装依赖项
echo -e "${YELLOW}[1/4] 正在安装系统依赖项...${NC}"
sudo apt-get update && sudo apt-get install -y \
    git wget flex bison gperf \
    python3 python3-pip python3-venv \
    cmake ninja-build ccache \
    libffi-dev libssl-dev dfu-util \
    libusb-1.0-0 || {
    echo -e "${RED}依赖项安装失败${NC}"
    exit 1
}

# 创建esp目录
echo -e "${YELLOW}[2/4] 正在设置ESP-IDF环境...${NC}"
mkdir -p ~/esp/esp-idf || {
    echo -e "${RED}无法创建~/esp目录${NC}"
    exit 1
}

# 克隆ESP-IDF仓库
if [ ! -d ~/esp/esp-idf ]; then
    echo -e "正在克隆ESP-IDF v5.3.3..."
    cd ~/esp && git clone -b release/v5.3 https://gitee.com/EspressifSystems/esp-idf.git
        echo -e "${RED}克隆ESP-IDF失败${NC}"
        exit 1
    }
else
    echo -e "${GREEN}检测到已存在的ESP-IDF目录，跳过克隆${NC}"
fi

# 安装工具链
echo -e "${YELLOW}[3/4] 正在安装工具链...${NC}"
cd ~/esp/esp-idf
export IDF_GITHUB_ASSETS="dl.espressif.cn/github_assets"  # 国内镜像加速

if ! ./install.sh; then
    echo -e "${RED}工具链安装失败${NC}"
    exit 1
fi

# 设置环境变量
echo -e "${YELLOW}[4/4] 正在设置环境变量...${NC}"
if ! . $HOME/esp/esp-idf/export.sh; then
    echo -e "${RED}环境变量设置失败${NC}"
    exit 1
fi

# 验证安装
echo -e "\n${GREEN}安装完成！验证安装...${NC}"
idf.py --version || {
    echo -e "${RED}验证失败，请检查安装${NC}"
    exit 1
}

echo -e "\n${GREEN}ESP-IDF 安装成功！${NC}"
echo -e "每次使用前需要运行: ${YELLOW}source \$HOME/esp/esp-idf/export.sh${NC}"
echo -e "或将其添加到您的 ~/.bashrc 文件中"

exit 0