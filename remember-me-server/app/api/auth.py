from fastapi import APIRouter, Depends, HTTPException, Request, status, Body
from fastapi.responses import JSONResponse
from fastapi.security import OAuth2PasswordRequestFormStrict
from sqlalchemy.orm import Session
from app.dependencies import get_db
from app.schemas.auth import Token, UserSignIn, RefreshToken, TokenData, AccessToken
from app.schemas.user import User, UserCreate
from app.core.auth import authenticate_firebase_user, create_tokens
from app.core.security import verify_token
from app.db.crud.user import create_user, get_user_by_email, get_user_by_firebase_uid
from app.core.exceptions import AuthError, BadRequest
from jose import JWTError, jwt
from firebase_admin import auth
from app.config import settings
from datetime import timedelta
from typing import Any

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/signup", response_model=Token)
async def signup(
    user_data: UserCreate,
    db: Session = Depends(get_db)
) -> Any:
    """
    Firebase로 사용자 등록 및 JWT 토큰 발급
    """
    try:
        db_user = get_user_by_email(db, user_data.email)
        if db_user:
            raise BadRequest("Email already registered")
        
        firebase_user = auth.create_user(
            email=user_data.email,
            password=user_data.password,
            display_name=user_data.display_name
        )
        
        db_user = create_user(db, user_data, firebase_user.uid)
        
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        tokens = create_tokens(
            email=db_user.email,
            uid=firebase_user.uid,
            access_token_expires=access_token_expires
        )
        
        return tokens
    except Exception as e:
        if "EMAIL_EXISTS" in str(e):
            raise BadRequest("Email already registered")
        raise BadRequest(f"Error creating user: {str(e)}")

@router.post("/signin", response_model=Token)
async def signin(
    user_data: UserSignIn,
    db: Session = Depends(get_db)
) -> Any:
    """
    Firebase로 로그인 및 JWT 토큰 발급
    """
    try:
        user, tokens = await authenticate_firebase_user(db, user_data.email, user_data.password)
        return tokens
    except Exception as e:
        raise AuthError(f"Authentication failed: {str(e)}")

@router.post("/refresh", response_model=Token)
async def refresh_token(
    refresh_token_data: RefreshToken,
    db: Session = Depends(get_db)
) -> Any:
    """
    리프레시 토큰으로 새 액세스 토큰 발급
    """
    try:
        payload = jwt.decode(
            refresh_token_data.refresh_token,
            settings.SECRET_KEY,
            algorithms=[settings.ALGORITHM]
        )
        email: str = payload.get("sub")
        uid: str = payload.get("uid")
        
        if email is None or uid is None:
            raise AuthError("Invalid refresh token")
        
        user = get_user_by_email(db, email)
        if not user or user.firebase_uid != uid:
            raise AuthError("User not found or token mismatch")
        
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        tokens = create_tokens(
            email=email,
            uid=uid,
            access_token_expires=access_token_expires
        )
        
        return tokens
    except JWTError as e:
        raise AuthError(f"Invalid refresh token: {str(e)}")
    except Exception as e:
        raise AuthError(f"Token refresh failed: {str(e)}")

@router.post("/verify")
async def verify_token_route(
    token_data: AccessToken,
    db: Session = Depends(get_db)
) -> Any:
    """
    토큰 유효성 검증
    """
    try:
        token = token_data.access_token
        if not token:
            raise BadRequest("Token is required")
        
        token_data = await verify_token(token)
        user = get_user_by_firebase_uid(db, token_data.uid)
        if not user:
            raise AuthError("User not found")
        
        return {"valid": True, "user_id": user.id}
    except JWTError as e:
        return {"valid": False, "error": str(e)}
    except Exception as e:
        return {"valid": False, "error": str(e)}


@router.post("/token")
async def TokenRead(
        req: Request,
        schemas: OAuth2PasswordRequestFormStrict = Depends(),
        db: Session = Depends(get_db),
):
    user, tokens = await authenticate_firebase_user(db, schemas.username, schemas.password)

    return JSONResponse(status_code=200, content={
        "access_token": tokens.access_token,
        "token_type": "bearer"
    })