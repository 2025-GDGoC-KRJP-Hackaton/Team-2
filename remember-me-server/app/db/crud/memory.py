from typing import List, Optional
from sqlalchemy.orm import Session
from app.db.crud.base import CRUDBase
from app.models.memory import Memory
from app.schemas.memory import CreateImageMemory, CreateMemory, MemoryUpdate

class CRUDPost(CRUDBase[Memory, CreateMemory, MemoryUpdate]):
    def create_with_author(
        self, db: Session, *, obj_in: CreateMemory, author_id: int
    ) -> Memory:
        """
        작성자 ID와 함께 메모리 생성
        """
        post_data = obj_in.dict()
        db_obj = Memory(**post_data, author_id=author_id)
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def get_by_author(
        self, db: Session, author_id: int, skip: int = 0, limit: int = 100
    ) -> List[Memory]:
        """
        작성자별 메모리 조회
        """
        return (
            db.query(Memory)
            .filter(Memory.author_id == author_id)
            .offset(skip)
            .limit(limit)
            .all()
        )



memory_crud = CRUDPost(Memory)

def get_memory(db: Session, memory_id: int) -> Optional[Memory]:
    """
    ID로 메모리 조회
    """
    return memory_crud.get(db, memory_id)

def get_memorys(db: Session, skip: int = 0, limit: int = 100) -> List[Memory]:
    """
    메모리 목록 조회
    """
    return memory_crud.get_multi(db, skip=skip, limit=limit)

def create_memory(db: Session, post_data: CreateMemory, author_id: int) -> Memory:
    """
    메모리 생성
    """
    return memory_crud.create_with_author(db, obj_in=post_data, author_id=author_id)

def create_memory_image(db: Session, post_data: CreateImageMemory, author_id: int) -> Memory:
    """
    메모리 생성
    """
    return memory_crud.create_with_author(db, obj_in=post_data, author_id=author_id)

def update_memory(db: Session, post: Memory, post_data: MemoryUpdate) -> Memory:
    """
    메모리 업데이트
    """
    return memory_crud.update(db, db_obj=post, obj_in=post_data)

def delete_memory(db: Session, post_id: int) -> Memory:
    """
    메모리 삭제
    """
    return memory_crud.remove(db, id=post_id)

def get_user_memories(db: Session, author_id: int, skip: int = 0, limit: int = 100) -> List[Memory]:
    """
    사용자별 메모리 조회
    """
    return memory_crud.get_by_author(db, author_id, skip=skip, limit=limit)

def get_memory_by_id_and_author(db: Session, memory_id: int, author_id: int) -> Optional[Memory]:
    """
    ID와 작성자 ID로 메모리 조회
    """
    return db.query(Memory).filter(Memory.id == memory_id, Memory.author_id == author_id).first()