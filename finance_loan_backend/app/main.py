from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from .core.config import settings
from .db.database import engine
from .models import User, Bank, Company, Loan, CreditLimit
from .api import auth, users, loans, banks, companies, credit_limits
from . import admin

# Create database tables
User.metadata.create_all(bind=engine)
Bank.metadata.create_all(bind=engine)
Company.metadata.create_all(bind=engine)
Loan.metadata.create_all(bind=engine)
CreditLimit.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.app_name,
    version=settings.app_version,
    description="A comprehensive Finance Loan Management API built with FastAPI",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static files
app.mount("/static", StaticFiles(directory="app/static"), name="static")

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(users.router, prefix="/api/users", tags=["Users"])
app.include_router(loans.router, prefix="/api/loans", tags=["Loans"])
app.include_router(banks.router, prefix="/api/banks", tags=["Banks"])
app.include_router(companies.router, prefix="/api/companies", tags=["Companies"])
app.include_router(credit_limits.router, prefix="/api/credit-limits", tags=["Credit Limits"])

# Include admin router
app.include_router(admin.router, tags=["Admin Portal"])


@app.get("/")
def read_root():
    """Root endpoint with API information."""
    return {
        "message": "Welcome to Finance Loan API",
        "version": settings.app_version,
        "docs": "/docs",
        "redoc": "/redoc"
    }


@app.get("/health")
def health_check():
    """Health check endpoint."""
    return {"status": "healthy", "service": settings.app_name}
