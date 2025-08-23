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

echo -e "${YELLOW}[1/4] 正在清理环境变量...${NC}"

# 从.bashrc中移除ESP-IDF相关配置
sed -i '/# >>> ESP initialize >>>/,/# <<< ESP initialize <<</d' ~/.bashrc

# 同时检查.zshrc（如果是zsh用户）
if [ -f ~/.zshrc ]; then
    sed -i '/# >>> ESP initialize >>>/,/# <<< ESP initialize <<</d' ~/.zshrc
fi

echo -e "${GREEN}环境变量已清理${NC}"

echo -e "${YELLOW}[2/4] 正在删除ESP-IDF目录...${NC}"

# 删除整个esp目录
if [ -d "$HOME/esp" ]; then
    rm -rf "$HOME/esp" && \
    echo -e "${GREEN}已删除 $HOME/esp${NC}"
else
    echo -e "${YELLOW}未找到 $HOME/esp 目录${NC}"
fi

echo -e "${YELLOW}[3/4] 正在清理Python虚拟环境...${NC}"

# 删除可能存在的Python虚拟环境
if [ -d "$HOME/.espressif" ]; then
    rm -rf "$HOME/.espressif" && \
    echo -e "${GREEN}已删除 $HOME/.espressif${NC}"
else
    echo -e "${YELLOW}未找到 $HOME/.espressif 目录${NC}"
fi


# 额外清理（缓存和临时文件）
echo -e "\n${YELLOW}执行额外清理...${NC}"
rm -rf "$HOME/.cache/idf_tools"
rm -rf "$HOME/.cache/esp-idf"

echo -e "\n${GREEN}ESP-IDF 已完全卸载！${NC}"
echo -e "建议重新打开终端使环境变量变更生效"

exit 0
