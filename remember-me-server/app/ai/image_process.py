from fastapi import FastAPI, File, UploadFile, Form, HTTPException
from fastapi.responses import JSONResponse
import io
import base64
from typing import Optional
from PIL import Image
from pydantic import BaseModel, Field
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import PydanticOutputParser
from langchain_core.output_parsers import StrOutputParser
from langchain_core.messages import HumanMessage
from langchain_core.runnables import RunnablePassthrough
from app.schemas.ai import ImageDescription
from app.ai.base import llm, claude_llm


def get_image_description_chain():
    """이미지로부터 설명을 생성하는 체인"""
    
    parser = PydanticOutputParser(pydantic_object=ImageDescription)
    format_instructions = parser.get_format_instructions()
    
    def generate_description(inputs):
        base64_image = inputs["image_data"]["base64_image"]
        mime_type = inputs["image_data"]["mime_type"]
        
        prompt_text = f"""
Please analyze the following image in detail.
1. Please explain all the main elements included in the image.
2. If there is text in the image, please transcribe all text exactly.
3. Please explain important details in the image (logos, colors, layout, expressions, etc.).
4. Please analyze what the overall context and purpose of the image appears to be.
5. If there are any data, charts, or graphs included in the image, please explain their content in detail.
6. If there are people in the image, explain only the number of people and the general situation without identifying specific individuals.

Please describe the image as detailed and objectively as possible. Please review all parts of the image to ensure no important information is omitted.
        {format_instructions}
        """
        
        message = HumanMessage(
            content=[
                {"type": "text", "text": prompt_text},
                {
                    "type": "image",
                    "source": {
                        "type": "base64", 
                        "media_type": mime_type,
                        "data": base64_image
                    }
                }
            ]
        )
        
        response = claude_llm.invoke([message])
        
        try:
            parsed_response = parser.parse(response.content)
            return parsed_response
        except Exception as e:
        
            return ImageDescription(description=response.content)
    
    return generate_description
