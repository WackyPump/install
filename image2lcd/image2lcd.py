from PIL import Image
   
def image_to_led_array(image_path, output_file, max_width=320, max_height=240):
    # 打开图像文件
    img = Image.open(image_path)
    img = img.convert('RGB')
    
    # 获取原始尺寸
    orig_width, orig_height = img.size
    
    # 计算缩放比例（保持宽高比）
    width_ratio = max_width / orig_width
    height_ratio = max_height / orig_height
    scale = min(width_ratio, height_ratio)
    
    # 计算新尺寸
    new_width = int(orig_width * scale)
    new_height = int(orig_height * scale)
    
    # 调整图像尺寸（如果需要）
    if orig_width > max_width or orig_height > max_height:
        img = img.resize((new_width, new_height), Image.LANCZOS)
        print(f"图像已从 {orig_width}x{orig_height} 缩放至 {new_width}x{new_height}")
    else:
        new_width, new_height = orig_width, orig_height
    
    # 创建空白画布（320x240）
    canvas = Image.new('RGB', (max_width, max_height), (0, 0, 0))
    
    # 将图像居中放置在画布上
    x_offset = (max_width - new_width) // 2
    y_offset = (max_height - new_height) // 2
    canvas.paste(img, (x_offset, y_offset))
    
    # 计算数组大小 (16位色 = 2字节/像素)
    array_size = max_width * max_height * 2
    
    with open(output_file, 'w') as f:
        # 写入文件头
        f.write(f"static const unsigned char gImage_{image_path.split('.')[0]}[{array_size}] = {{\n")
        
        # 水平扫描处理
        for y in range(max_height):
            for x in range(max_width):
                # 获取RGB值
                r, g, b = canvas.getpixel((x, y))
                
                # 转换为16位RGB565格式
                # R:5位, G:6位, B:5位
                r_5 = (r >> 3) & 0x1F
                g_6 = (g >> 2) & 0x3F
                b_5 = (b >> 3) & 0x1F
                
                # 组合为16位值
                rgb_16 = (r_5 << 11) | (g_6 << 5) | b_5
                
                # 分割为高低字节
                high_byte = (rgb_16 >> 8) & 0xFF
                low_byte = rgb_16 & 0xFF
                
                # 写入文件
                f.write(f"0X{high_byte:02X},0X{low_byte:02X},")
                
                # 每16个像素换行
                if (x + 1) % 16 == 0:
                    f.write("\n")
        
        # 写入文件尾
        f.write("\n};\n")
   
# 使用示例   
image_to_led_array("yingwu.png", "yingwu.h")

