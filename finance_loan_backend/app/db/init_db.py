from sqlalchemy.orm import Session
from ..core.security import get_password_hash
from ..models.user import User
from ..models.bank import Bank
from ..models.company import Company
from ..models.credit_limit import CreditLimit
from .database import SessionLocal


def init_db():
    """Initialize database with sample data."""
    db = SessionLocal()
    
    try:
        # Create sample banks
        banks_data = [
            {
                "name": "Kurdistan Bank",
                "code": "KDB",
                "logo": "https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg?auto=compress&cs=tinysrgb&w=100",
                "interest_rate": 8.5,
                "max_loan_period": 60
            },
            {
                "name": "Cihan Bank",
                "code": "CHB",
                "logo": "https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg?auto=compress&cs=tinysrgb&w=100",
                "interest_rate": 9.0,
                "max_loan_period": 48
            },
            {
                "name": "Ashur Bank",
                "code": "ASB",
                "logo": "https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg?auto=compress&cs=tinysrgb&w=100",
                "interest_rate": 7.5,
                "max_loan_period": 72
            }
        ]
        
        for bank_data in banks_data:
            existing_bank = db.query(Bank).filter(Bank.code == bank_data["code"]).first()
            if not existing_bank:
                bank = Bank(**bank_data)
                db.add(bank)
        
        # Create sample companies
        companies_data = [
            {
                "name": "Tech Solutions KRG",
                "description": "Leading technology company in Kurdistan Region",
                "logo": "https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=100",
                "category": "Technology"
            },
            {
                "name": "Kurdistan Oil Company",
                "description": "Major oil and gas company",
                "logo": "https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=100",
                "category": "Energy"
            },
            {
                "name": "Erbil Construction Ltd",
                "description": "Construction and infrastructure development",
                "logo": "https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=100",
                "category": "Construction"
            },
            {
                "name": "Kurdistan Healthcare",
                "description": "Healthcare services provider",
                "logo": "https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=100",
                "category": "Healthcare"
            }
        ]
        
        for company_data in companies_data:
            existing_company = db.query(Company).filter(Company.name == company_data["name"]).first()
            if not existing_company:
                company = Company(**company_data)
                db.add(company)
        
        # Create sample user
        existing_user = db.query(User).filter(User.email == "demo@example.com").first()
        if not existing_user:
            demo_user = User(
                email="demo@example.com",
                full_name="Demo User",
                phone_number="+964750123456",
                hashed_password=get_password_hash("demo123"),
                is_active=True
            )
            db.add(demo_user)
            db.commit()
            db.refresh(demo_user)
            
            # Create sample credit limits for demo user
            banks = db.query(Bank).all()
            companies = db.query(Company).all()
            
            for bank in banks[:2]:  # First 2 banks
                for company in companies[:2]:  # First 2 companies
                    credit_limit = CreditLimit(
                        user_id=demo_user.id,
                        bank_id=bank.id,
                        company_id=company.id,
                        total_limit=50000.0,
                        used_limit=0.0,
                        available_limit=50000.0
                    )
                    db.add(credit_limit)
        
        db.commit()
        print("Database initialized with sample data successfully!")
        
    except Exception as e:
        print(f"Error initializing database: {e}")
        db.rollback()
    finally:
        db.close()


if __name__ == "__main__":
    init_db()
