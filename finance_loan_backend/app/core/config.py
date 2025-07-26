from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    # Database
    database_url: str = "sqlite:///./finance_loan.db"
    
    # JWT Settings
    secret_key: str = "your-secret-key-here-change-in-production"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    
    # App Settings
    app_name: str = "Finance Loan API"
    app_version: str = "1.0.0"
    debug: bool = True
    
    # Admin Settings
    admin_email: str = "admin@financeloan.com"
    admin_password: str = "admin123"  # In production, use environment variables and secure hashing
    
    class Config:
        env_file = ".env"


settings = Settings()
