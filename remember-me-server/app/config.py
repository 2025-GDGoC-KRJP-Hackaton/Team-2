from pydantic_settings import BaseSettings
import os
from dotenv import load_dotenv

load_dotenv()

class Settings(BaseSettings):
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "Firebase FastAPI Auth"
    
    SECRET_KEY: str = os.getenv("SECRET_KEY", "some-secret")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7
    
    FIREBASE_CREDENTIALS_PATH: str = os.getenv(
        "FIREBASE_CREDENTIALS_PATH", "firebase-credentials.json"
    )

    FIREBASE_API_KEY: str = os.getenv(
        "FIREBASE_API_KEY", ""
    )
    ANTHROPIC_API_KEY: str = os.getenv(
        "ANTHROPIC_API_KEY", "ANTHROPIC_API_KEY"
    )

    FIREBASE_AUTH_URL: str = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={os.getenv('FIREBASE_API_KEY', '')}"
    
    DATABASE_URL: str = os.getenv(
        "DATABASE_URL", "sqlite:///./sql_app.db"
    )
    
settings = Settings()