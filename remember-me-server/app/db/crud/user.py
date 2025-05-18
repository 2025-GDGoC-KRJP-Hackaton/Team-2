from sqlalchemy.orm import Session
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate
from typing import Optional
from .base import CRUDBase


class CRUDUser(CRUDBase[User, UserCreate, UserUpdate]):
    def get_by_email(self, db: Session, email: str) -> Optional[User]:
        """
        이메일로 사용자 조회
        """
        return db.query(User).filter(User.email == email).first()

    def get_by_firebase_uid(self, db: Session, firebase_uid: str) -> Optional[User]:
        """
        Firebase UID로 사용자 조회
        """
        return db.query(User).filter(User.firebase_uid == firebase_uid).first()

    def create_with_firebase(self, db: Session, obj_in: UserCreate, firebase_uid: str) -> User:
        """
        Firebase UID와 함께 사용자 생성
        """
        db_obj = User(
            email=obj_in.email,
            firebase_uid=firebase_uid,
            display_name=obj_in.display_name,
            is_active=True,
        )
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

crud_user = CRUDUser(User)

get_user_by_firebase_uid = crud_user.get_by_firebase_uid
get_user_by_email = crud_user.get_by_email
create_user = crud_user.create_with_firebase
get_user = crud_user.get
get_users = crud_user.get_multi
update_user = crud_user.update
delete_user = crud_user.remove 