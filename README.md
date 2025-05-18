# Remember Me

<img src="/Users/1kl1/Downloads/AppIcons (1)/appstore.png" alt="appstore" style="zoom:33%;" />

A comprehensive memory preservation and recall application designed to help users store, organize, and retrieve personal memories.

## Project Overview

Remember Me is a full-stack application consisting of a Flutter mobile app and a Python FastAPI backend server. The application allows users to upload, categorize, and recall memories through text and images, with AI-powered features for memory stimulation and retrieval.

## Components

### Mobile Application (Flutter)

The mobile application provides a user-friendly interface for:
- Uploading and categorizing memories (photos and videos)
- Browsing memory albums organized by categories
- Memory stimulation exercises
- Family dashboard for shared memories

**Key Technologies:**
- Flutter for cross-platform mobile development
- Firebase for authentication and storage
- Flutter Riverpod for state management
- Go Router for navigation
- Dio for API communication

### Backend Server (FastAPI)

The server handles:
- User authentication and management
- Memory storage and retrieval
- AI-powered image processing
- Vector database for semantic memory recall

**Key Technologies:**
- FastAPI for API development
- SQLAlchemy for ORM and database operations
- Firebase Admin SDK for authentication
- LangChain for AI capabilities
- Chroma vector database for semantic search

## Features

- **Memory Upload**: Upload text memories and images with automatic AI-generated descriptions
- **Memory Album**: Browse memories organized by categories like Family, Friends, Travel, etc.
- **Memory Recall**: AI-powered semantic search to recall memories based on natural language queries
- **Family Dashboard**: Share and manage memories with family members
- **Memory Stimulation**: Exercises designed to stimulate memory recall

## Getting Started

### Prerequisites

- Flutter SDK (^3.7.2)
- Python (3.8+)
- Firebase account
- PostgreSQL database

### Mobile App Setup

1. Clone the repository
   ```
   git clone https://github.com/your-repo/remember-me.git
   cd remember-me
   ```

2. Install dependencies
   ```
   flutter pub get
   ```

3. Configure Firebase
   - Create a Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and place the configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS

4. Create a `.env` file with your API endpoint
   ```
   API_URL=https://your-api-url.com
   ```

5. Run the app
   ```
   flutter run
   ```

### Server Setup

1. Navigate to the server directory
   ```
   cd remember-me-server
   ```

2. Install dependencies
   ```
   pip install -r requirements.txt
   ```

3. Configure environment variables
   - Create a `.env` file with your database and Firebase credentials

4. Run database migrations
   ```
   alembic upgrade head
   ```

5. Start the server
   ```
   uvicorn app.main:app --reload
   ```

## Docker Deployment

The server can be deployed using Docker:

```
docker-compose up -d
```

## Project Structure

### Mobile App Structure

```
remember-me/
├── lib/
│   ├── app/
│   │   ├── api/          # API client and services
│   │   ├── auth/         # Authentication services
│   │   ├── provider/     # State management
│   │   ├── route/        # Navigation
│   │   ├── screens/      # UI screens
│   │   ├── service/      # Business logic
│   │   └── widgets/      # Reusable UI components
│   ├── constants.dart    # App constants
│   └── main.dart         # App entry point
├── assets/               # Images and resources
└── pubspec.yaml          # Dependencies
```

### Server Structure

```
remember-me-server/
├── app/
│   ├── ai/              # AI models and processing
│   ├── api/             # API endpoints
│   │   └── protected/   # Authenticated endpoints
│   ├── core/            # Core utilities
│   ├── db/              # Database models and CRUD
│   │   └── crud/        # Database operations
│   ├── models/          # SQLAlchemy models
│   └── schemas/         # Pydantic schemas
├── migrations/          # Alembic migrations
└── main.py              # Server entry point
```

## Teams



|          Name | School            | Role                          |
| ------------: | ----------------- | ----------------------------- |
|    Minjun Kim | Korea University  | Backend, Frontend Development |
|  Junseong Lee | Yonsei University | Artificial Intelligence       |
|    Jimin Park | Waseda University | Frontend Development          |
|     He JinXin | Korea University  | UI/UX Design                  |
| Krystal Hsueh | Waseda University | Background research, PPT      |



