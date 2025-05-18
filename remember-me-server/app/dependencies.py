
import chromadb
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from langchain_chroma import Chroma
from app.core.security import verify_token
from app.schemas.auth import TokenData
from app.db.base import SessionLocal
from langchain_community.embeddings import OpenAIEmbeddings
from langchain_google_genai import ChatGoogleGenerativeAI


oauth2_scheme = OAuth2PasswordBearer(tokenUrl=f"/api/v1/auth/token")


async def get_current_user(token: str = Depends(oauth2_scheme)) -> TokenData:
    """
    현재 인증된 사용자의 토큰 데이터를 반환하는 의존성 함수
    """
    try:
        return await verify_token(token)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

def get_db():
    """
    데이터베이스 세션을 제공하는 의존성 함수
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

async def get_vectordb(token: str = Depends(oauth2_scheme)) -> Chroma:
    client = chromadb.HttpClient(host="chroma", port=8000)
    embeddings = OpenAIEmbeddings()

    try:
        token_data = await verify_token(token)

        db = Chroma(
            client=client,
            collection_name=token_data.uid,
            embedding_function=embeddings
        )
        
        return db
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )




     