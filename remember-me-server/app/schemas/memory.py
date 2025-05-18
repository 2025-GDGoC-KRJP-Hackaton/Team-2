from typing import List, Optional
from pydantic import BaseModel
from datetime import datetime

class CreateMemory(BaseModel):
    text: str

class CreateImageMemory(BaseModel):
    image_url: str

class MemoryUpdate(CreateImageMemory):
    pass

class BaseMemory(BaseModel):
    id: int
    text: Optional[str] = None
    image_url: Optional[str] = None
    created_at: datetime

class MemoryInDB(BaseMemory):
    pass

class ListMemoryResponse(BaseModel):
    memories: List[MemoryInDB]