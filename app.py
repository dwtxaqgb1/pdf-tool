# -*- coding: utf-8 -*-
from flask import Flask, render_template, request, send_file, jsonify
from flask_cors import CORS
import fitz
from PIL import Image, ImageFilter
import io
import os
import uuid
import base64
from werkzeug.utils import secure_filename

app = Flask(__name__)
CORS(app)
app.config['MAX_CONTENT_LENGTH'] = 100 * 1024 * 1024
app.config['UPLOAD_FOLDER'] = '/tmp/pdf_tool'
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

def process_image(image_bytes, binary_threshold, sharpen, denoise, do_invert):
    img = Image.open(io.BytesIO(image_bytes))
    if img.mode == 'RGBA':
        r, g, b, a = img.split()
        img = Image.merge('RGB', (r, g, b))
    else:
        img = img.convert('RGB')
    if do_invert:
        img = Image.eval(img, lambda x: 255 - x)
    gray_img = img.convert('L')
    if denoise:
        gray_img = gray_img.filter(ImageFilter.MedianFilter(size=3))
    binary_img = gray_img.point(lambda p: 255 if p > binary_threshold else 0)
    if sharpen:
        binary_img = binary_img.filter(ImageFilter.SHARPEN)
    return binary_img.convert('RGB')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'})

@app.route('/api/process_pdf', methods=['POST'])
def process_pdf():
    try:
        file = request.files.get('file')
        if not file:
            return jsonify({'error': '请选择文件'}), 400
        
        threshold = int(request.form.get('threshold', 120))
        do_invert = request.form.get('invert') == 'true'
        denoise = request.form.get('denoise') == 'true'
        sharpen = request.form.get('sharpen') == 'true'
        
        temp_id = str(uuid.uuid4())
        input_path = os.path.join(app.config['UPLOAD_FOLDER'], f'{temp_id}_input.pdf')
        output_path = os.path.join(app.config['UPLOAD_FOLDER'], f'{temp_id}_output.pdf')
        file.save(input_path)
        
        doc = fitz.open(input_path)
        new_doc = fitz.open()
        processed_count = 0
        total_images = 0
        
        for page_num in range(len(doc)):
            page = doc[page_num]
            image_list = page.get_images(full=True)
            new_page = new_doc.new_page(width=page.rect.width, height=page.rect.height)
            
            for img_info in image_list:
                total_images += 1
                xref = img_info[0]
                try:
                    base_image = doc.extract_image(xref)
                    processed_img = process_image(base_image["image"], threshold, sharpen, denoise, do_invert)
                    img_buffer = io.BytesIO()
                    processed_img.save(img_buffer, format='JPEG', quality=70, optimize=True)
                    img_buffer.seek(0)
                    rects = page.get_image_rects(xref)
                    if rects:
                        for rect in rects:
                            new_page.insert_image(rect, stream=img_buffer.getvalue())
                        processed_count += 1
                except Exception as e:
                    print(f"处理图片出错: {e}")
        
        new_doc.save(output_path, garbage=4, deflate=True, clean=True)
        new_doc.close()
        doc.close()
        os.remove(input_path)
        
        return send_file(output_path, as_attachment=True, download_name='处理后文档.pdf')
    except Exception as e:
        print(f"process_pdf 错误: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/api/images_to_pdf', methods=['POST'])
def images_to_pdf():
    try:
        files = request.files.getlist('files')
        if not files or len(files) == 0:
            return jsonify({'error': '请选择图片文件'}), 400
        
        threshold = int(request.form.get('threshold', 120))
        do_invert = request.form.get('invert') == 'true'
        denoise = request.form.get('denoise') == 'true'
        sharpen = request.form.get('sharpen') == 'true'
        page_size = request.form.get('page_size', 'A4')
        
        print(f"处理参数: threshold={threshold}, invert={do_invert}, denoise={denoise}, sharpen={sharpen}, page_size={page_size}")
        print(f"接收到 {len(files)} 个文件")
        
        doc = fitz.open()
        size_map = {'A4': (595, 842), 'A3': (842, 1191), 'Letter': (612, 792)}
        page_width, page_height = size_map.get(page_size, (595, 842))
        
        for idx, file in enumerate(files):
            print(f"处理第 {idx+1} 张图片: {file.filename}")
            
            # 读取图片
            img_bytes = file.read()
            img = Image.open(io.BytesIO(img_bytes))
            
            # 转换为RGB
            if img.mode == 'RGBA':
                r, g, b, a = img.split()
                img = Image.merge('RGB', (r, g, b))
            else:
                img = img.convert('RGB')
            
            # 反色处理
            if do_invert:
                img = Image.eval(img, lambda x: 255 - x)
            
            # 灰度化
            gray_img = img.convert('L')
            
            # 去噪点
            if denoise:
                gray_img = gray_img.filter(ImageFilter.MedianFilter(size=3))
            
            # 二值化
            binary_img = gray_img.point(lambda p: 255 if p > threshold else 0)
            
            # 锐化
            if sharpen:
                binary_img = binary_img.filter(ImageFilter.SHARPEN)
            
            # 转换为RGB（PDF需要）
            final_img = binary_img.convert('RGB')
            
            # 获取尺寸
            img_width, img_height = final_img.size
            
            # 计算缩放比例（保持比例，居中显示）
            scale = min(page_width / img_width, page_height / img_height)
            final_w = img_width * scale
            final_h = img_height * scale
            x = (page_width - final_w) / 2
            y = (page_height - final_h) / 2
            
            # 保存到内存
            img_buffer = io.BytesIO()
            final_img.save(img_buffer, format='PNG')
            img_buffer.seek(0)
            
            # 创建PDF页面并插入图片
            page = doc.new_page(width=page_width, height=page_height)
            page.insert_image(fitz.Rect(x, y, x + final_w, y + final_h), stream=img_buffer.getvalue())
        
        # 保存PDF
        temp_id = str(uuid.uuid4())
        output_path = os.path.join(app.config['UPLOAD_FOLDER'], f'{temp_id}_output.pdf')
        doc.save(output_path, garbage=4, deflate=True)
        doc.close()
        
        print(f"PDF生成成功: {output_path}")
        return send_file(output_path, as_attachment=True, download_name='合成文档.pdf')
        
    except Exception as e:
        print(f"images_to_pdf 错误: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=False)