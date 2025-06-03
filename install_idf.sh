
sudo apt-get install git wget flex bison gperf python3 python3-pip python3-venv cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0


cd ~/esp
git clone -b v5.3.3 --recursive https://github.com/espressif/esp-idf.git
# git clone -b release/v5.3 https://gitee.com/EspressifSystems/esp-idf.git

cd ~/esp/esp-idf
export IDF_GITHUB_ASSETS="dl.espressif.cn/github_assets"		#国内提高下载速度
./install.sh


#设置环境变量
. $HOME/esp/esp-idf/export.sh