from sqlalchemy.orm import Session
from ..models.credit_limit import CreditLimit
from ..schemas.credit_limit import CreditLimitCreate, CreditLimitUpdate
from typing import List, Optional


def get_credit_limit(db: Session, credit_limit_id: str) -> Optional[CreditLimit]:
    """Get credit limit by ID."""
    return db.query(CreditLimit).filter(CreditLimit.id == credit_limit_id).first()


def get_user_credit_limits(db: Session, user_id: str) -> List[CreditLimit]:
    """Get all credit limits for a user."""
    return db.query(CreditLimit).filter(CreditLimit.user_id == user_id).all()


def get_credit_limit_by_user_bank_company(
    db: Session, user_id: str, bank_id: str, company_id: str
) -> Optional[CreditLimit]:
    """Get credit limit for specific user, bank, and company combination."""
    return db.query(CreditLimit).filter(
        CreditLimit.user_id == user_id,
        CreditLimit.bank_id == bank_id,
        CreditLimit.company_id == company_id
    ).first()


def create_credit_limit(db: Session, credit_limit: CreditLimitCreate) -> CreditLimit:
    """Create a new credit limit."""
    db_credit_limit = CreditLimit(
        user_id=credit_limit.user_id,
        bank_id=credit_limit.bank_id,
        company_id=credit_limit.company_id,
        total_limit=credit_limit.total_limit,
        available_limit=credit_limit.total_limit  # Initially, available = total
    )
    db.add(db_credit_limit)
    db.commit()
    db.refresh(db_credit_limit)
    return db_credit_limit


def update_credit_limit(
    db: Session, credit_limit_id: str, credit_limit_update: CreditLimitUpdate
) -> Optional[CreditLimit]:
    """Update credit limit information."""
    db_credit_limit = get_credit_limit(db, credit_limit_id)
    if not db_credit_limit:
        return None
    
    update_data = credit_limit_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_credit_limit, field, value)
    
    # Recalculate available limit if total or used limit changed
    if 'total_limit' in update_data or 'used_limit' in update_data:
        db_credit_limit.available_limit = db_credit_limit.total_limit - db_credit_limit.used_limit
    
    db.commit()
    db.refresh(db_credit_limit)
    return db_credit_limit


def update_used_credit(
    db: Session, user_id: str, bank_id: str, company_id: str, amount: float
) -> Optional[CreditLimit]:
    """Update used credit amount for a specific credit limit."""
    db_credit_limit = get_credit_limit_by_user_bank_company(db, user_id, bank_id, company_id)
    if not db_credit_limit:
        return None
    
    db_credit_limit.used_limit += amount
    db_credit_limit.available_limit = db_credit_limit.total_limit - db_credit_limit.used_limit
    
    db.commit()
    db.refresh(db_credit_limit)
    return db_credit_limit


def get_available_credit(
    db: Session, user_id: str, bank_id: str, company_id: str
) -> float:
    """Get available credit for a specific user, bank, and company combination."""
    credit_limit = get_credit_limit_by_user_bank_company(db, user_id, bank_id, company_id)
    if not credit_limit:
        return 0.0
    return credit_limit.available_limit


def delete_credit_limit(db: Session, credit_limit_id: str) -> bool:
    """Delete a credit limit."""
    db_credit_limit = get_credit_limit(db, credit_limit_id)
    if not db_credit_limit:
        return False
    
    db.delete(db_credit_limit)
    db.commit()
    return True
