from langchain_anthropic import ChatAnthropic
from langchain_google_genai import ChatGoogleGenerativeAI
from app.config import settings

llm = ChatGoogleGenerativeAI(model="gemini-2.0-flash", temperature=0.2)


claude_llm = ChatAnthropic(
    model="claude-3-5-sonnet-20240620",
    anthropic_api_key=settings.ANTHROPIC_API_KEY,
    temperature=0.2
)