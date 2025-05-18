from typing import Any, List
from fastapi import APIRouter, Depends, HTTPException
from langchain_chroma import Chroma
from requests import Session
from app.core.exceptions import NotFound
from app.db.crud.user import get_user_by_firebase_uid
from app.dependencies import get_current_user, get_db, get_vectordb
from app.schemas.ai import DocumentInput, QueryInput
from app.schemas.auth import TokenData
from app.schemas.user import User
from langchain.chains import RetrievalQA
from app.ai.base import llm
from xml.dom.minidom import Document


router = APIRouter(prefix="/test", tags=["test"])

@router.post("/add_documents/{collection_name}")
def add_documents(
    documents: List[DocumentInput],
    vectordb: Chroma = Depends(get_vectordb),
    ):
    try:
        langchain_docs = [
            Document(page_content=doc.text, metadata=doc.metadata)
            for doc in documents
        ]

        vectordb.add_documents(langchain_docs)
        
        return {"message": f"Added {len(documents)} documents to collection"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to add documents: {str(e)}")


@router.post("/me")
async def read_current_user(
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