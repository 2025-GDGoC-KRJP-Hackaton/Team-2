from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime

class UserBase(BaseModel):
    email: Optional[EmailStr] = None
    is_active: Optional[bool] = True
    is_superuser: Optional[bool] = False
    firebase_uid: Optional[str] = None
    display_name: Optional[str] = None
    
class UserCreate(UserBase):
    email: EmailStr
    firebase_uid: str
    password: str = Field(..., min_length=6)
    
class UserUpdate(UserBase):
    pass

class UserInDBBase(UserBase):
    id: Optional[int] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

class User(UserInDBBase):
    pass