from datetime import datetime
import io
import base64
from PIL import Image




async def compress_image_to_base64(image_content, max_size_mb=18, quality_start=95, min_quality=40):
    max_size_bytes = max_size_mb * 1024 * 1024
    
    img = Image.open(io.BytesIO(image_content))
    original_format = img.format
    
    if not original_format:
        original_format = "JPEG"
    
    has_transparency = img.mode in ('RGBA', 'LA') or (img.mode == 'P' and 'transparency' in img.info)
    
    if has_transparency:
        save_format = 'PNG'
        if img.mode == 'P':
            img = img.convert('RGBA')
    else:
        save_format = original_format if original_format != 'PNG' else 'JPEG'
        if img.mode != 'RGB' and save_format == 'JPEG':
            img = img.convert('RGB')
    
    quality = quality_start
    
    while quality >= min_quality:
        buffered = io.BytesIO()
        img.save(buffered, format=save_format, quality=quality, optimize=True)
        
        size = buffered.getbuffer().nbytes
        if size <= max_size_bytes:
            break
        
        quality -= 5
    
    if buffered.getbuffer().nbytes > max_size_bytes:
        width, height = img.size
        
        scale_factor = 0.9
        
        while scale_factor > 0.1:
            new_width = int(width * scale_factor)
            new_height = int(height * scale_factor)
            
            resized_img = img.resize((new_width, new_height), Image.LANCZOS)
            
            buffered = io.BytesIO()
            resized_img.save(buffered, format=save_format, quality=quality, optimize=True)
            
            if buffered.getbuffer().nbytes <= max_size_bytes:
                break
                
            scale_factor *= 0.9
    
    buffered.seek(0)
    
    base64_image = base64.b64encode(buffered.getvalue()).decode("utf-8")
    mime_type = f"image/{save_format.lower()}"
    
    return {
        "base64_image": base64_image,
        "mime_type": mime_type
    }
