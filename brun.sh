#!/bin/bash

# TF卡烧录U-Boot脚本(三星ARM专用版)
# 使用方法: sudo ./burn_samsung.sh [uboot镜像路径] [目标设备]

# 默认参数
UBOOT_IMAGE="u-boot-samsung.bin"  # 修改为三星专用镜像名
TARGET_DEVICE=""
ERASE_SIZE="1M"  # 预擦除大小
BLOCK_SIZE="512"  # 更适合ARM的块大小
SEEK_OFFSET="1"   # 三星ARM通常从1块(512B)开始

# 检查是否以root权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "错误: 此脚本必须以root权限运行，请使用sudo执行"
    exit 1
fi

# 检查是否提供了自定义参数
if [ $# -ge 1 ]; then
    UBOOT_IMAGE="$1"
fi

if [ $# -ge 2 ]; then
    TARGET_DEVICE="$2"
fi

# 检查uboot镜像文件是否存在
if [ ! -f "$UBOOT_IMAGE" ]; then
    echo "错误: U-Boot镜像文件 $UBOOT_IMAGE 不存在"
    echo "提示: 请确认是否使用专为三星ARM编译的U-Boot镜像"
    exit 1
fi

# 如果没有指定目标设备，则列出所有可用设备供用户选择
if [ -z "$TARGET_DEVICE" ]; then
    echo "检测到的存储设备:"
    lsblk -d -o NAME,SIZE,MODEL | grep -v "loop\|rom"
    echo ""
    read -p "请输入目标设备名称(如sdb, mmcblk0等，不需要/dev/前缀): " TARGET_DEVICE
    
    if [ -z "$TARGET_DEVICE" ]; then
        echo "错误: 必须指定目标设备"
        exit 1
    fi
fi

# 确保设备名称不以/dev/开头
TARGET_DEVICE=$(echo "$TARGET_DEVICE" | sed 's/^\/dev\///')

# 检查目标设备是否存在
if [ ! -e "/dev/$TARGET_DEVICE" ]; then
    echo "错误: 设备 /dev/$TARGET_DEVICE 不存在"
    exit 1
fi

# 再次确认，防止用户误操作
echo ""
echo "!!! 严重警告 !!!"
echo "这将永久擦除设备 /dev/$TARGET_DEVICE 上的所有数据!"
echo "请三思而后行，确认这是目标TF卡而非系统磁盘!"
echo "目标设备信息:"
lsblk "/dev/$TARGET_DEVICE"
echo ""
read -p "确认要烧录U-Boot到/dev/$TARGET_DEVICE吗? (输入大写的YES确认): " confirm

if [ "$confirm" != "YES" ]; then
    echo "操作已取消"
    exit 0
fi

# 检查设备是否已挂载
mounted_partitions=$(mount | grep "/dev/$TARGET_DEVICE" | awk '{print $1}')
if [ -n "$mounted_partitions" ]; then
    echo "发现设备分区已挂载，正在卸载..."
    for partition in $mounted_partitions; do
        umount "$partition" 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "警告: 无法卸载 $partition，尝试强制卸载..."
            umount -l "$partition" 2>/dev/null || true
        fi
    done
fi

# 预擦除设备头部(重要!)
echo "正在擦除设备头部..."
dd if=/dev/zero of="/dev/$TARGET_DEVICE" bs=$BLOCK_SIZE count=$((ERASE_SIZE/BLOCK_SIZE)) conv=fsync

# 烧录U-Boot到设备(三星ARM特定参数)
echo ""
echo "正在烧录U-Boot到 /dev/$TARGET_DEVICE ..."
echo "使用参数: bs=$BLOCK_SIZE seek=$SEEK_OFFSET"
dd if="$UBOOT_IMAGE" of="/dev/$TARGET_DEVICE" bs=$BLOCK_SIZE seek=$SEEK_OFFSET conv=fsync

if [ $? -eq 0 ]; then
    echo ""
    echo "U-Boot烧录成功完成!"
    echo "建议操作:"
    echo "1. 使用sync命令确保数据写入"
    echo "2. 安全移除TF卡"
    echo "3. 插入三星ARM设备测试"
else
    echo ""
    echo "错误: U-Boot烧录失败"
    exit 1
fi

sync
exit 0
