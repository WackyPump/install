#!/bin/bash

# 通用Qt项目跨平台打包脚本
# 支持QMake和CMake项目
# 使用方法: ./build.sh [qmake|cmake] [项目路径]

# 设置MXE环境变量
export MXE_PATH=/opt/mxe
export PATH="$MXE_PATH/usr/bin:$PATH"

# 检测构建类型参数
BUILD_TYPE=${1:-"qmake"}  # 默认为qmake
PROJECT_PATH=${2:-"."}    # 默认为当前目录

# 定义输出目录
OUTPUT_DIR="../output"

# 检查MXE环境
if [ ! -d "$MXE_PATH" ]; then
    echo "错误: MXE路径 $MXE_PATH 不存在!"
    exit 1
fi

# 创建并进入构建目录
mkdir -p build
cd build || exit 1

# 创建输出目录(和build同级)
mkdir -p $OUTPUT_DIR

# 根据构建类型执行不同的构建流程
case $BUILD_TYPE in
    "qmake")
        echo "使用QMake构建系统..."
        
        # 设置QMake路径
        export MXE_QMAKE="$MXE_PATH/usr/x86_64-w64-mingw32.static/qt5/bin/qmake"
        
        # 查找.pro文件(如果未指定完整路径)
        if [ ! -f "$PROJECT_PATH" ]; then
            PROJECT_FILE=$(find ../$PROJECT_PATH -maxdepth 1 -name "*.pro" | head -n 1)
            if [ -z "$PROJECT_FILE" ]; then
                echo "错误: 未找到.pro文件!"
                exit 1
            fi
        else
            PROJECT_FILE=$PROJECT_PATH
        fi
        
        # 执行qmake
        $MXE_QMAKE $PROJECT_FILE -spec win32-g++ "CONFIG+=release" \
            "DESTDIR=${OUTPUT_DIR}"
        
        if [ $? -ne 0 ]; then
            echo "错误: qmake配置失败!"
            exit 1
        fi
        
        # 编译项目
        make -j$(nproc)
        
        if [ $? -ne 0 ]; then
            echo "错误: QMake编译失败!"
            exit 1
        fi
        
        # 复制生成的可执行文件到输出目录
        if [ -d "release" ]; then
            cp -r release/* $OUTPUT_DIR/
        fi
        ;;


    "cmake")
    	echo "使用CMake构建系统..."
        
        # 查找CMakeLists.txt(如果未指定完整路径)
        if [ ! -f "$PROJECT_PATH" ]; then
            if [ ! -f "../$PROJECT_PATH/CMakeLists.txt" ]; then
                echo "错误: 未找到CMakeLists.txt!"
                exit 1
            fi
            PROJECT_DIR="../$PROJECT_PATH"
        else
            PROJECT_DIR=$(dirname "$PROJECT_PATH")
        fi
        
        # 执行CMake
        x86_64-w64-mingw32.static-cmake $PROJECT_DIR \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_EXE_LINKER_FLAGS="-static" \
            -DCMAKE_INSTALL_PREFIX=$OUTPUT_DIR
            
        if [ $? -ne 0 ]; then
            echo "错误: CMake配置失败!"
            exit 1
        fi
        
        # 编译并安装项目
        make -j$(nproc)
#        make -j$(nproc) install
#        
#        if [ $? -ne 0 ]; then
#            echo "错误: CMake编译/安装失败!"
#            exit 1
#        fi
        ;;
    *)
        echo "错误: 未知构建类型 '$BUILD_TYPE'!"
        echo "用法: $0 [qmake|cmake] [项目路径]"
        exit 1
        ;;
esac

echo "编译成功完成!"
echo "输出文件在 $OUTPUT_DIR 目录中"
