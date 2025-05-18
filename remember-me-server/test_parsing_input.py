import os
import unittest
from parsing_input import process_client_image, process_client_audio, test_api_direct, get_api_key
from PIL import Image
import io
import numpy as np

class TestParsingInput(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # API 키 확인
        cls.api_key = get_api_key()
        if not cls.api_key:
            raise ValueError("GEMINI_API_KEY 환경 변수가 설정되어 있지 않습니다.")
        
        # API 테스트
        if not test_api_direct(cls.api_key):
            raise ValueError("API 테스트에 실패했습니다.")
        
        # 테스트용 이미지 생성
        cls.test_image = Image.new('RGB', (100, 100), color='red')
        img_byte_arr = io.BytesIO()
        cls.test_image.save(img_byte_arr, format='JPEG')
        cls.test_image_data = img_byte_arr.getvalue()
        
        # 테스트용 오디오 데이터 생성 (더미 데이터)
        cls.test_audio_data = b'dummy audio data'

    def test_process_image(self):
        """이미지 처리 테스트"""
        result = process_client_image(self.test_image_data)
        
        # 결과 구조 확인
        self.assertIsInstance(result, dict)
        if "error" not in result:
            self.assertIn("original_text", result)
            self.assertIn("bert_encoding", result)
            self.assertIn("input_type", result)
            self.assertIn("vector_size", result)
            self.assertIn("encoding_type", result)
            
            # BERT 인코딩 벡터 크기 확인
            self.assertIsInstance(result["bert_encoding"], list)
            self.assertGreater(len(result["bert_encoding"]), 0)
            
            # 입력 타입 확인
            self.assertEqual(result["input_type"], "image")
            
            # 인코딩 타입 확인
            self.assertEqual(result["encoding_type"], "BERT-multilingual-cased")

    def test_process_audio(self):
        """오디오 처리 테스트"""
        result = process_client_audio(self.test_audio_data, "mp3")
        
        # 결과 구조 확인
        self.assertIsInstance(result, dict)
        if "error" not in result:
            self.assertIn("original_text", result)
            self.assertIn("bert_encoding", result)
            self.assertIn("input_type", result)
            self.assertIn("vector_size", result)
            self.assertIn("encoding_type", result)
            
            # BERT 인코딩 벡터 크기 확인
            self.assertIsInstance(result["bert_encoding"], list)
            self.assertGreater(len(result["bert_encoding"]), 0)
            
            # 입력 타입 확인
            self.assertEqual(result["input_type"], "audio")
            
            # 인코딩 타입 확인
            self.assertEqual(result["encoding_type"], "BERT-multilingual-cased")

    def test_invalid_image(self):
        """잘못된 이미지 데이터 테스트"""
        invalid_image_data = b"invalid image data"
        result = process_client_image(invalid_image_data)
        self.assertIn("error", result)

    def test_invalid_audio(self):
        """잘못된 오디오 데이터 테스트"""
        invalid_audio_data = b"invalid audio data"
        result = process_client_audio(invalid_audio_data, "mp3")
        self.assertIn("error", result)

def main():
    # 환경 변수 확인
    if not os.getenv("GEMINI_API_KEY"):
        print("경고: GEMINI_API_KEY 환경 변수가 설정되어 있지 않습니다.")
        print("테스트를 실행하기 전에 환경 변수를 설정해주세요.")
        print("예시: export GEMINI_API_KEY='your-api-key'")
        return

    # 테스트 실행
    unittest.main(verbosity=2)

if __name__ == '__main__':
    main() 