#!/bin/bash

# 检查是否已经添加权限   
if ! sudo grep -q "wackypump ALL=(ALL) NOPASSWD:ALL" /etc/sudoers; then
    # 添加到.bashrc
    sudo cat << 'EOF' >> /etc/sudoers
wackypump ALL=(ALL) NOPASSWD:ALL
EOF
    echo "权限添加成功"   
else
    echo "权限已添加在 /etc/sudoers，跳过添加"   
fi
