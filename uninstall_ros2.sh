# 查找并删除所有ROS相关包
sudo apt remove 'ros-*' -y
sudo apt autoremove -y

# 清理残留配置
sudo apt purge 'ros-*' -y

# 删除可能存在的残留目录
sudo rm -rf /opt/ros
sudo rm -rf ~/.ros


# 从.bashrc中移除ESP-IDF相关配置
sed -i '/# >>> ROS2 initialize >>>/,/# <<< ROS2 initialize <<</d' ~/.bashrc

# 同时检查.zshrc（如果是zsh用户）
if [ -f ~/.zshrc ]; then
    sed -i '/# >>> ROS2 initialize >>>/,/# <<< ROS2 initialize <<</d' ~/.zshrc
fi
