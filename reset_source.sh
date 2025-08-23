#!/bin/bash
# Ubuntu 多选镜像源切换脚本

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 获取系统信息
if ! command -v lsb_release >/dev/null; then
    echo -e "${RED}错误：lsb_release 命令未找到，请先安装lsb-release包${NC}"
    exit 1
fi

CODENAME=$(lsb_release -cs)
DISTRIBUTOR=$(lsb_release -is)

# 验证系统代号
if [[ ! "$CODENAME" =~ ^[a-z]+$ ]]; then
    echo -e "${RED}错误：无效的系统代号 '$CODENAME'${NC}"
    exit 1
fi

# 显示菜单
show_menu() {
    clear
    echo -e "${YELLOW}============================================${NC}"
    echo -e "${YELLOW}          Ubuntu 镜像源切换工具            ${NC}"
    echo -e "${YELLOW}============================================${NC}"
    echo -e "${BLUE}请选择要切换的镜像源：${NC}"
    echo "1. 腾讯云镜像源"
    echo "2. 清华大学镜像源"
    echo "3. 中国科学技术大学镜像源"
    echo "4. 阿里云镜像源"
    echo "5. 恢复Ubuntu官方默认源"
    echo -e "${YELLOW}============================================${NC}"
    echo -e "${RED}注意：此操作将覆盖现有源配置！${NC}"
    echo -e "${YELLOW}============================================${NC}"
}

# 备份现有源
backup_sources() {
    echo -e "\n${YELLOW}[1/3] 备份当前源${NC}"
    BACKUP_DIR="/etc/apt/backup_$(date +%Y%m%d_%H%M%S)"
    sudo mkdir -p "$BACKUP_DIR"

    sudo cp -v /etc/apt/sources.list "$BACKUP_DIR/" 2>/dev/null || true
    sudo find /etc/apt/sources.list.d/ -name '*.list' -exec sudo cp -v {} "$BACKUP_DIR/" \; 2>/dev/null || true

    echo -e "${GREEN}备份完成：${NC}所有源已备份到 $BACKUP_DIR"
}

# 清理第三方源
clean_sources() {
    echo -e "\n${YELLOW}[2/3] 清理第三方源${NC}"
    sudo sh -c '> /etc/apt/sources.list'
    sudo rm -f /etc/apt/sources.list.d/* 2>/dev/null || true
    echo -e "${GREEN}清理完成：${NC}所有第三方源已删除"
}

# 应用腾讯源
apply_tencent() {
    echo -e "\n${YELLOW}[3/3] 应用腾讯云镜像源${NC}"
    sudo tee /etc/apt/sources.list >/dev/null <<EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释

deb http://mirrors.tencentyun.com/ubuntu/ jammy main restricted universe multiverse
# deb-src http://mirrors.tencentyun.com/ubuntu/ jammy main restricted universe multiverse

deb http://mirrors.tencentyun.com/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src http://mirrors.tencentyun.com/ubuntu/ jammy-updates main restricted universe multiverse

deb http://mirrors.tencentyun.com/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src http://mirrors.tencentyun.com/ubuntu/ jammy-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse

# deb http://mirrors.tencentyun.com/ubuntu/ jammy-security main restricted universe multiverse
# # deb-src http://mirrors.tencentyun.com/ubuntu/ jammy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb http://mirrors.tencentyun.com/ubuntu/ jammy-proposed main restricted universe multiverse
# deb-src http://mirrors.tencentyun.com/ubuntu/ jammy-proposed main restricted universe multiverse
EOF
}

# 应用清华源
apply_tsinghua() {
    echo -e "\n${YELLOW}[3/3] 应用清华大学镜像源${NC}"
    sudo tee /etc/apt/sources.list >/dev/null <<EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse

# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
EOF
}

# 应用中科大源
apply_ustc() {
    echo -e "\n${YELLOW}[3/3] 应用中国科学技术大学镜像源${NC}"
    sudo tee /etc/apt/sources.list >/dev/null <<EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释

deb https://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse

deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse

deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse

# deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
# # deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
EOF
}

# 应用阿里源
apply_aliyun() {
    echo -e "\n${YELLOW}[3/3] 应用阿里云镜像源${NC}"
    sudo tee /etc/apt/sources.list >/dev/null <<EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释

deb https://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse

# deb https://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
# # deb-src https://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse
EOF
}

# 恢复官方源
apply_official() {
    echo -e "\n${YELLOW}[3/3] 恢复Ubuntu官方默认源${NC}"
    sudo tee /etc/apt/sources.list >/dev/null <<EOF

# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释

deb http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb http://archive.ubuntu.com/ubuntu/ jammy-proposed main restricted universe multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ jammy-proposed main restricted universe multiverse
EOF
}


# 更新软件列表
update_apt() {
    echo -e "\n${YELLOW}更新软件列表...${NC}"
    sudo apt-get update -y

    echo -e "\n${GREEN}操作成功完成！${NC}"
    echo -e "当前有效源列表："
    sudo grep -v '^#' /etc/apt/sources.list | grep -v '^$'
}

# 主程序
main() {
    while true; do
    	clear
        show_menu
        read -p "请输入选择(1-5): " choice
        while true; do
            # 检查输入是否为1-5的数字
            if [[ "$choice" =~ ^[1-5]$ ]]; then
		break
            else
            	clear
            	show_menu
            	echo -e "${RED}无效的选择，请输入1-5之间的数字${NC}"
            	read -p "请输入选择(1-5): " choice
            fi
        done
        
        # 询问是否备份
        read -p "是否要备份当前源？[Y/n] " backup_confirm
        if [[ "$backup_confirm" =~ ^[Nn]$ ]]; then
            echo -e "${YELLOW}[1/3] 跳过备份操作${NC}"
        else
            if ! backup_sources; then
                echo -e "${RED}备份源失败！${NC}"
                continue
            fi
            echo -e "${GREEN}备份已完成:/etc/apt/backup_xxx${NC}"
        fi
        
                
        # 确认操作
        echo -e "\n${YELLOW}[警告] 此操作将执行以下操作：${NC}"
        echo "1. 删除所有第三方源列表文件"
        case $choice in
            1) echo "2. 切换为腾讯云镜像源";;
            2) echo "2. 切换为清华大学镜像源";;
            3) echo "2. 切换为中国科学技术大学镜像源";;
            4) echo "2. 切换为阿里云镜像源";;
            5) echo "2. 恢复为Ubuntu官方默认源";;
        esac
        
        read -p "是否继续？[y/N] " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}操作已取消${NC}"
            exit 0
        fi
        
        # 清除源
        clean_sources
        
        # 更换源
        case $choice in
            1) apply_tencent;;
            2) apply_tsinghua;;
            3) apply_ustc;;
            4) apply_aliyun;;
            5) apply_official;;
        esac
        
        update_apt
        break
    done
}

main
exit 0
