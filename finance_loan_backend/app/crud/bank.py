from sqlalchemy.orm import Session
from ..models.bank import Bank
from ..schemas.bank import BankCreate, BankUpdate
from typing import List, Optional


def get_bank(db: Session, bank_id: str) -> Optional[Bank]:
    """Get bank by ID."""
    return db.query(Bank).filter(Bank.id == bank_id).first()


def get_bank_by_code(db: Session, code: str) -> Optional[Bank]:
    """Get bank by code."""
    return db.query(Bank).filter(Bank.code == code).first()


def get_banks(db: Session, skip: int = 0, limit: int = 100, active_only: bool = True) -> List[Bank]:
    """Get all banks with pagination."""
    query = db.query(Bank)
    if active_only:
        query = query.filter(Bank.is_active == True)
    return query.offset(skip).limit(limit).all()


def create_bank(db: Session, bank: BankCreate) -> Bank:
    """Create a new bank."""
    db_bank = Bank(
        name=bank.name,
        code=bank.code,
        logo=bank.logo,
        interest_rate=bank.interest_rate,
        max_loan_period=bank.max_loan_period
    )
    db.add(db_bank)
    db.commit()
    db.refresh(db_bank)
    return db_bank


def update_bank(db: Session, bank_id: str, bank_update: BankUpdate) -> Optional[Bank]:
    """Update bank information."""
    db_bank = get_bank(db, bank_id)
    if not db_bank:
        return None
    
    update_data = bank_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_bank, field, value)
    
    db.commit()
    db.refresh(db_bank)
    return db_bank


def delete_bank(db: Session, bank_id: str) -> bool:
    """Delete a bank (soft delete by setting is_active to False)."""
    db_bank = get_bank(db, bank_id)
    if not db_bank:
        return False
    
    db_bank.is_active = False
    db.commit()
    return True
