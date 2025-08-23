

sudo apt install git
cd
# 克隆 MXE 仓库
git clone https://github.com/mxe/mxe.git
#移动
sudo mv mxe /opt/mxe

# 安装必要的依赖（以 Ubuntu 为例）
sudo apt update
sudo apt install -y autoconf automake autopoint bash bison bzip2 flex g++ g++-multilib gettext git gperf intltool libc6-dev-i386 libgdk-pixbuf2.0-dev libltdl-dev libssl-dev libtool-bin libxml-parser-perl lzip make openssl p7zip-full patch perl python3 python3-pip python3-mako python3-pkg-resources ruby sed unzip wget xz-utils

	# 创建 python → python3 的软链接（解决命令缺失问题）   
	# 需要需要需要，很需要，因为里面有python的语句而这是需要python3的
	#TODO:如果已经存在则不用创建
	sudo ln -s /usr/bin/python3 /usr/bin/python


cd /opt/mxe	
# 编译 Qt 工具链（选择需要的版本，例如 qt5）
make MXE_TARGETS='x86_64-w64-mingw32.static i686-w64-mingw32.static' qt5

# 压缩
tar -czvf mxe.tar.gz /opt/mxe

