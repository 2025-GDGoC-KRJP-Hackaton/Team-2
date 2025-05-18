from typing import Optional
from pydantic import BaseModel, Field

class QueryInput(BaseModel):
    query: str

class DocumentInput(BaseModel):
    text: str
    metadata: Optional[dict] = {}

class ImageDescription(BaseModel):
    description: str = Field(description="이미지에 대한 3줄 이내의 설명")