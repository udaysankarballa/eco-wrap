from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routes.recommendation_routes import router as recommendation_router


app = FastAPI(
    title="ECO WRAP API",
    description="AI-based intelligent food packaging recommendation system",
    version="1.0.0",
)


# Allow Flutter Web / Chrome to communicate with the API.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def root():
    return {
        "message": "ECO WRAP Backend is running",
        "status": "success",
    }


@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "service": "ECO WRAP API",
    }


app.include_router(recommendation_router)