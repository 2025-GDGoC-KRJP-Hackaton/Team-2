# 필요한 패키지 설치
import os
import json
import requests
import numpy as np
from PIL import Image
import base64
import io
from pydub import AudioSegment
import tempfile
import getpass
from transformers import BertTokenizer, BertModel
import torch
from dotenv import load_dotenv

# .env 파일 로드
load_dotenv()

# BERT 모델과 토크나이저 로드
def load_bert_model():
    tokenizer = BertTokenizer.from_pretrained('bert-base-multilingual-cased')  # 한국어 지원을 위해 다국어 모델 사용
    model = BertModel.from_pretrained('bert-base-multilingual-cased')
    return tokenizer, model

# 텍스트를 BERT로 인코딩하는 함수
def encode_text_with_bert(text, tokenizer, model):
    # 토큰화 및 인코딩
    inputs = tokenizer(text, return_tensors="pt", padding=True, truncation=True, max_length=512)
    
    # 모델 통과 (그래디언트 계산 없이)
    with torch.no_grad():
        outputs = model(**inputs)
    
    # [CLS] 토큰의 마지막 히든 스테이트 사용 (문장 표현)
    embeddings = outputs.last_hidden_state[:, 0, :].numpy()
    
    # NumPy 배열을 리스트로 변환 (JSON 직렬화를 위해)
    return embeddings.flatten().tolist()

# API 키 설정 (환경 변수에서 가져오거나 사용자 입력 받기)
def get_api_key():
    api_key = os.getenv("GEMINI_API_KEY")
    
    if not api_key:
        print("GEMINI_API_KEY 환경 변수를 찾을 수 없습니다.")
        print("API 키를 입력하세요 (입력 내용은 표시되지 않습니다):")
        api_key = getpass.getpass()
        
    return api_key

# 직접 HTTP 요청을 사용하여 API 테스트
def test_api_direct(api_key):
    try:
        # gemini-2.0-flash 모델 사용
        url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={api_key}"
        headers = {'Content-Type': 'application/json'}
        data = {
            "contents": [{
                "parts": [{"text": "Hello, this is a test!"}]
            }]
        }
        
        response = requests.post(url, headers=headers, json=data)
        
        if response.status_code == 200:
            result = response.json()
            print("API 테스트 성공! 응답:")
            if 'candidates' in result and len(result['candidates']) > 0:
                content = result['candidates'][0]['content']
                if 'parts' in content and len(content['parts']) > 0:
                    print(content['parts'][0]['text'])
            return True
        else:
            print(f"API 오류 (상태 코드: {response.status_code}):", response.text)
            return False
            
    except Exception as e:
        print("API 요청 오류:", str(e))
        return False

# 직접 HTTP 요청을 사용하여 이미지 처리
def process_image_direct(image_data, api_key, tokenizer, model):
    try:
        # 이미지가 이미 바이너리 데이터인 경우 그대로 사용, 파일 경로인 경우 파일 열기
        if isinstance(image_data, str) and os.path.isfile(image_data):
            with open(image_data, "rb") as image_file:
                image_binary = image_file.read()
        else:
            # 클라이언트로부터 받은 바이너리 데이터 사용
            image_binary = image_data
            
        # base64로 인코딩
        encoded_image = base64.b64encode(image_binary).decode('utf-8')
        
        # API 요청 URL - gemini-2.0-flash 모델 사용
        url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={api_key}"
        
        # 요청 헤더
        headers = {'Content-Type': 'application/json'}
        
        # 요청 데이터
        data = {
            "contents": [{
                "parts": [
                    {"text": "이 이미지에 대해 자세히 설명해 주세요."},
                    {
                        "inline_data": {
                            "mime_type": "image/jpeg",
                            "data": encoded_image
                        }
                    }
                ]
            }]
        }
        
        # API 요청 보내기
        response = requests.post(url, headers=headers, json=data)
        
        # 응답 처리
        if response.status_code == 200:
            result = response.json()
            if 'candidates' in result and len(result['candidates']) > 0:
                content = result['candidates'][0]['content']
                if 'parts' in content and len(content['parts']) > 0:
                    text_response = content['parts'][0]['text']
                    # BERT 인코딩 적용
                    bert_vector = encode_text_with_bert(text_response, tokenizer, model)
                    return {
                        "original_text": text_response,
                        "bert_encoding": bert_vector
                    }
            return {"error": "이미지 분석 결과를 가져올 수 없습니다."}
        else:
            return {"error": f"API 오류 (상태 코드: {response.status_code}): {response.text}"}
            
    except Exception as e:
        return {"error": f"이미지 처리 중 오류 발생: {str(e)}"}

# 직접 HTTP 요청을 사용하여 음성 처리 (WAV 또는 MP3만 지원)
def process_audio_direct(audio_data, audio_format, api_key, tokenizer, model):
    try:
        # 오디오가 이미 바이너리 데이터인 경우 그대로 사용, 파일 경로인 경우 파일 열기
        if isinstance(audio_data, str) and os.path.isfile(audio_data):
            file_ext = os.path.splitext(audio_data)[1].lower()
            
            # WAV 또는 MP3 파일만 처리
            if file_ext == '.wav':
                audio_format = "wav"
                with open(audio_data, "rb") as audio_file:
                    audio_binary = audio_file.read()
            elif file_ext == '.mp3':
                audio_format = "mp3"
                with open(audio_data, "rb") as audio_file:
                    audio_binary = audio_file.read()
            else:
                return {"error": "지원되지 않는 오디오 형식입니다. WAV 또는 MP3만 지원합니다."}
        else:
            # 클라이언트로부터 받은 바이너리 데이터 사용
            audio_binary = audio_data
            
            # audio_format이 지정되지 않은 경우 기본값 설정
            if not audio_format:
                audio_format = "mp3"  # 기본값으로 mp3 설정
        
        # base64로 인코딩
        encoded_audio = base64.b64encode(audio_binary).decode('utf-8')
        
        # API 요청 URL - gemini-2.0-flash 모델 사용
        url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={api_key}"
        
        # 요청 헤더
        headers = {'Content-Type': 'application/json'}
        
        # 요청 데이터
        data = {
            "contents": [{
                "parts": [
                    {"text": "이 오디오 파일에서 말하는 내용을 텍스트로 변환해주세요."},
                    {
                        "inline_data": {
                            "mime_type": f"audio/{audio_format}",
                            "data": encoded_audio
                        }
                    }
                ]
            }]
        }
        
        # API 요청 보내기
        response = requests.post(url, headers=headers, json=data)
        
        # 응답 처리
        if response.status_code == 200:
            result = response.json()
            if 'candidates' in result and len(result['candidates']) > 0:
                content = result['candidates'][0]['content']
                if 'parts' in content and len(content['parts']) > 0:
                    text_response = content['parts'][0]['text']
                    # BERT 인코딩 적용
                    bert_vector = encode_text_with_bert(text_response, tokenizer, model)
                    return {
                        "original_text": text_response,
                        "bert_encoding": bert_vector
                    }
            return {"error": "음성 분석 결과를 가져올 수 없습니다."}
        else:
            error_message = response.text
            
            # 오류 메시지가 너무 길 경우 줄이기
            if len(error_message) > 500:
                error_message = error_message[:500] + "... (생략)"
                
            return {"error": f"API 오류 (상태 코드: {response.status_code}): {error_message}"}
            
    except Exception as e:
        return {"error": f"음성 처리 중 오류 발생: {str(e)}"}

def process_client_image(image_data):
    """
    클라이언트로부터 받은 이미지 데이터를 처리하는 함수
    image_data: 클라이언트로부터 받은 이미지 바이너리 데이터
    """
    # API 키 가져오기
    api_key = get_api_key()
    
    # BERT 모델 로드
    tokenizer, model = load_bert_model()
    
    # 이미지 처리
    result_data = process_image_direct(image_data, api_key, tokenizer, model)
    
    # 기본 결과 정보 추가
    if "error" not in result_data:
        result_data["input_type"] = "image"
        result_data["vector_size"] = len(result_data["bert_encoding"])
        result_data["encoding_type"] = "BERT-multilingual-cased"
    
    return result_data

def process_client_audio(audio_data, audio_format="mp3"):
    """
    클라이언트로부터 받은 오디오 데이터를 처리하는 함수
    audio_data: 클라이언트로부터 받은 오디오 바이너리 데이터
    audio_format: 오디오 형식 (기본값: mp3)
    """
    # API 키 가져오기
    api_key = get_api_key()
    
    # BERT 모델 로드
    tokenizer, model = load_bert_model()
    
    # 오디오 처리
    result_data = process_audio_direct(audio_data, audio_format, api_key, tokenizer, model)
    
    # 기본 결과 정보 추가
    if "error" not in result_data:
        result_data["input_type"] = "audio"
        result_data["vector_size"] = len(result_data["bert_encoding"])
        result_data["encoding_type"] = "BERT-multilingual-cased"
    
    return result_data

def main():
    print("Gemini 미디어 분석 서비스 (gemini-2.0-flash 모델 사용)")
    print("- 이 스크립트는 서버에서 클라이언트로부터 이미지나 오디오를 받아 처리하는 용도입니다.")
    
    # API 키 가져오기
    api_key = get_api_key()
    
    # API 키 테스트
    print("\nAPI 키 테스트 중...")
    if not test_api_direct(api_key):
        print("API 테스트에 실패했습니다. 프로그램을 종료합니다.")
        return
    
    # BERT 모델 로드
    print("\nBERT 모델 로드 중...")
    tokenizer, model = load_bert_model()
    print("BERT 모델 로드 완료!")
    
    print("\n서버가 준비되었습니다. 클라이언트로부터 요청을 처리할 수 있습니다.")
    
    # 여기서 실제 서버 구현을 할 수 있습니다.
    # 예시:
    # from flask import Flask, request, jsonify
    # app = Flask(__name__)
    # 
    # @app.route('/process-image', methods=['POST'])
    # def process_image_endpoint():
    #     image_data = request.files['image'].read()
    #     result = process_client_image(image_data)
    #     return jsonify(result)
    # 
    # @app.route('/process-audio', methods=['POST'])
    # def process_audio_endpoint():
    #     audio_data = request.files['audio'].read()
    #     audio_format = request.form.get('format', 'mp3')
    #     result = process_client_audio(audio_data, audio_format)
    #     return jsonify(result)
    # 
    # app.run(host='0.0.0.0', port=5000)

if __name__ == "__main__":
    main()