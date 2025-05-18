from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.sql import text
from app.db.base import Base
from sqlalchemy.orm import relationship

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    firebase_uid = Column(String, unique=True, index=True)
    email = Column(String, unique=True, index=True)
    display_name = Column(String(20), nullable=True)
    is_active = Column(Boolean, default=True)
    is_superuser = Column(Boolean, default=False)
    profile_picture = Column(String(255), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=text("timezone('Asia/Tokyo', now())"))
    updated_at = Column(DateTime(timezone=True), onupdate=text("timezone('Asia/Seoul', now())"))
    
    memories = relationship("Memory", back_populates="author")