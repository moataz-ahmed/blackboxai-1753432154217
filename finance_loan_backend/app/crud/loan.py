from sqlalchemy.orm import Session
from ..models.loan import Loan
from ..models.bank import Bank
from ..schemas.loan import LoanCreate, LoanStatusUpdate
from typing import List, Optional
from datetime import datetime


def calculate_loan_details(amount: float, interest_rate: float, duration_months: int):
    """Calculate monthly payment and total amount for a loan."""
    monthly_rate = interest_rate / 100 / 12
    if monthly_rate == 0:
        monthly_payment = amount / duration_months
    else:
        monthly_payment = amount * (monthly_rate * (1 + monthly_rate) ** duration_months) / ((1 + monthly_rate) ** duration_months - 1)
    
    total_amount = monthly_payment * duration_months
    return monthly_payment, total_amount


def get_loan(db: Session, loan_id: str) -> Optional[Loan]:
    """Get loan by ID."""
    return db.query(Loan).filter(Loan.id == loan_id).first()


def get_loans(db: Session, skip: int = 0, limit: int = 100) -> List[Loan]:
    """Get all loans with pagination."""
    return db.query(Loan).offset(skip).limit(limit).all()


def get_user_loans(db: Session, user_id: str, skip: int = 0, limit: int = 100) -> List[Loan]:
    """Get loans for a specific user."""
    return db.query(Loan).filter(Loan.user_id == user_id).offset(skip).limit(limit).all()


def get_loans_by_status(db: Session, status: str, skip: int = 0, limit: int = 100) -> List[Loan]:
    """Get loans by status."""
    return db.query(Loan).filter(Loan.status == status).offset(skip).limit(limit).all()


def create_loan(db: Session, loan: LoanCreate, user_id: str) -> Loan:
    """Create a new loan request."""
    # Get bank details for interest rate
    bank = db.query(Bank).filter(Bank.id == loan.bank_id).first()
    if not bank:
        raise ValueError("Bank not found")
    
    # Calculate loan details
    monthly_payment, total_amount = calculate_loan_details(
        loan.amount, bank.interest_rate, loan.duration_months
    )
    
    db_loan = Loan(
        user_id=user_id,
        bank_id=loan.bank_id,
        company_id=loan.company_id,
        amount=loan.amount,
        interest_rate=bank.interest_rate,
        duration_months=loan.duration_months,
        monthly_payment=monthly_payment,
        total_amount=total_amount,
        status="pending"
    )
    
    db.add(db_loan)
    db.commit()
    db.refresh(db_loan)
    return db_loan


def update_loan_status(db: Session, loan_id: str, status_update: LoanStatusUpdate) -> Optional[Loan]:
    """Update loan status."""
    db_loan = get_loan(db, loan_id)
    if not db_loan:
        return None
    
    db_loan.status = status_update.status
    
    if status_update.status == "approved":
        db_loan.approval_date = datetime.utcnow()
    elif status_update.status == "rejected":
        db_loan.rejection_date = datetime.utcnow()
        db_loan.rejection_reason = status_update.rejection_reason
    
    db.commit()
    db.refresh(db_loan)
    return db_loan


def delete_loan(db: Session, loan_id: str) -> bool:
    """Delete a loan (only if pending)."""
    db_loan = get_loan(db, loan_id)
    if not db_loan or db_loan.status != "pending":
        return False
    
    db.delete(db_loan)
    db.commit()
    return True


def get_loan_statistics(db: Session, user_id: Optional[str] = None):
    """Get loan statistics."""
    query = db.query(Loan)
    if user_id:
        query = query.filter(Loan.user_id == user_id)
    
    total_loans = query.count()
    pending_loans = query.filter(Loan.status == "pending").count()
    approved_loans = query.filter(Loan.status == "approved").count()
    rejected_loans = query.filter(Loan.status == "rejected").count()
    
    total_amount = query.filter(Loan.status == "approved").with_entities(
        db.func.sum(Loan.amount)
    ).scalar() or 0
    
    return {
        "total_loans": total_loans,
        "pending_loans": pending_loans,
        "approved_loans": approved_loans,
        "rejected_loans": rejected_loans,
        "total_amount": total_amount
    }
