import uvicorn
from app.db.init_db import init_db

if __name__ == "__main__":
    # Initialize database with sample data
    print("Initializing database...")
    init_db()
    
    # Start the server
    print("Starting Finance Loan API server...")
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
