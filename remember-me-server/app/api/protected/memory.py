

from typing import Any, List
from langchain_community.docstore.document import Document
from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile
from langchain_chroma import Chroma
from requests import Session
from app.ai.image_process import get_image_description_chain
from app.core.exceptions import NotFound
from app.core.utilities import compress_image_to_base64
from app.db.crud.memory import create_memory, create_memory_image, get_user_memories
from app.db.crud.user import get_user_by_firebase_uid
from langchain.chains import RetrievalQA
from app.dependencies import get_current_user, get_db, get_vectordb
from app.schemas.ai import QueryInput
from app.ai.base import llm
from app.schemas.auth import TokenData
from app.schemas.memory import CreateImageMemory, CreateMemory, ListMemoryResponse


router = APIRouter(prefix="/memories", tags=["memories"])

@router.post("/recall")
async def recall_memory(
    query_input: QueryInput,
    vectordb: Chroma = Depends(get_vectordb),
) -> Any:
    qa_chain = RetrievalQA.from_chain_type(
        llm=llm,
        chain_type="stuff",
        retriever=vectordb.as_retriever()
    )
    result = qa_chain.invoke({"query": query_input.query})
    return {"answer": result["result"]}

@router.get("/me", response_model=ListMemoryResponse)
async def list_user_memories(
    token_data: TokenData = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> Any:
    user = get_user_by_firebase_uid(db, token_data.uid)
    if not user:
        raise NotFound("User not found")
    memories = get_user_memories(db, user.id, skip=0, limit=100)
    
    return {"memories": memories}

@router.post("/image")
async def create_image_memory(
    image: UploadFile = File(...),
    image_url: str = Form(...),
    token_data: TokenData = Depends(get_current_user),
    db: Session = Depends(get_db),
    vectordb: Chroma = Depends(get_vectordb)
) -> Any:
    
    user = get_user_by_firebase_uid(db, token_data.uid)
    if not user:
        raise NotFound("User not found")
    
    create_memory_image(db, CreateImageMemory(image_url=image_url), user.id)
    try:
        image_content = await image.read()
        image_data = await compress_image_to_base64(image_content)
        description_chain = get_image_description_chain()
        result = description_chain({
            "image_data": image_data
        })
        
        langchain_docs = [
            Document(page_content=result.description, metadata={})
        ]
        vectordb.add_documents(langchain_docs)

        return True
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to add documents: {str(e)}")

@router.post("/text", response_model=bool)
async def create_text_memory(
    request: CreateMemory,
    token_data: TokenData = Depends(get_current_user),
    db: Session = Depends(get_db),
    vectordb: Chroma = Depends(get_vectordb)
) -> Any:
    
    user = get_user_by_firebase_uid(db, token_data.uid)
    if not user:
        raise NotFound("User not found")
    
    create_memory(db, request, user.id)
    try:
        langchain_docs = [
            Document(page_content=request.text, metadata={})
        ]

        vectordb.add_documents(langchain_docs)
        
        return True
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to add documents: {str(e)}")
