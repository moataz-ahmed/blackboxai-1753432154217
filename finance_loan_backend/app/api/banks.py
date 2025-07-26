from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..core.deps import get_current_active_user
from ..db.database import get_db
from ..crud import bank as crud_bank
from ..schemas.bank import BankResponse, BankCreate, BankUpdate
from ..models.user import User

router = APIRouter()


@router.get("/", response_model=List[BankResponse])
def read_banks(
    skip: int = 0,
    limit: int = 100,
    active_only: bool = True,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Get all banks."""
    banks = crud_bank.get_banks(db, skip=skip, limit=limit, active_only=active_only)
    return banks


@router.get("/{bank_id}", response_model=BankResponse)
def read_bank(
    bank_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Get bank by ID."""
    db_bank = crud_bank.get_bank(db, bank_id=bank_id)
    if db_bank is None:
        raise HTTPException(status_code=404, detail="Bank not found")
    return db_bank


@router.post("/", response_model=BankResponse)
def create_bank(
    bank: BankCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Create a new bank (admin functionality for demo)."""
    # Check if bank code already exists
    existing_bank = crud_bank.get_bank_by_code(db, code=bank.code)
    if existing_bank:
        raise HTTPException(
            status_code=400,
            detail="Bank with this code already exists"
        )
    
    db_bank = crud_bank.create_bank(db=db, bank=bank)
    return db_bank


@router.put("/{bank_id}", response_model=BankResponse)
def update_bank(
    bank_id: str,
    bank_update: BankUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Update bank information (admin functionality for demo)."""
    updated_bank = crud_bank.update_bank(db, bank_id, bank_update)
    if not updated_bank:
        raise HTTPException(status_code=404, detail="Bank not found")
    return updated_bank


@router.delete("/{bank_id}")
def delete_bank(
    bank_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Delete a bank (soft delete - admin functionality for demo)."""
    success = crud_bank.delete_bank(db, bank_id)
    if not success:
        raise HTTPException(status_code=404, detail="Bank not found")
    return {"message": "Bank deactivated successfully"}
