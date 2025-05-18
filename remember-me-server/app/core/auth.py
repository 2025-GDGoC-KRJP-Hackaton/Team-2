from firebase_admin import auth
from app.db.crud.user import get_user_by_firebase_uid, create_user
from app.schemas.user import UserCreate, User
from app.core.security import create_access_token, create_refresh_token
from app.schemas.auth import Token
from datetime import timedelta
from sqlalchemy.orm import Session
from app.config import settings
from typing import Tuple, Optional
import requests



async def authenticate_firebase_user(
    db: Session, email: str, password: str
) -> Tuple[User, Token]:
    """
    Firebase Authentication REST API를 사용하여 이메일/비밀번호 인증 후
    데이터베이스에서 사용자 정보를 조회하고 토큰 생성
    """
    try:
        
        auth_data = {
            "email": email,
            "password": password,
            "returnSecureToken": True
        }
        
        response = requests.post(settings.FIREBASE_AUTH_URL, json=auth_data)
        response.raise_for_status()  
        
        firebase_response = response.json()
        firebase_uid = firebase_response.get("localId")
        
        if not firebase_uid:
            raise Exception("Firebase Authentication Failed: No UID returned")
        
        user = get_user_by_firebase_uid(db, firebase_uid)
        
        if not user:
            user_data = UserCreate(
                email=email,
                firebase_uid=firebase_uid
            )
            user = create_user(db, user_data)
        
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        tokens = create_tokens(user.email, firebase_uid, access_token_expires)
        
        return user, tokens
    except requests.exceptions.RequestException as e:
        raise Exception(f"Firebase Authentication Faiulre: {str(e)}")
    except Exception as e:
        raise Exception(f"Error while Authentication: {str(e)}")

def create_tokens(email: str, uid: str, access_token_expires: Optional[timedelta] = None) -> Token:
    """
    액세스 토큰과 리프레시 토큰 생성
    """
    access_token = create_access_token(
        data={"sub": email, "uid": uid},
        expires_delta=access_token_expires
    )
    refresh_token = create_refresh_token(
        data={"sub": email, "uid": uid}
    )
    
    return Token(
        access_token=access_token,
        refresh_token=refresh_token,
        token_type="bearer"
    )