from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..core.deps import get_current_active_user
from ..db.database import get_db
from ..crud import credit_limit as crud_credit_limit
from ..schemas.credit_limit import CreditLimitResponse, CreditLimitCreate, CreditLimitUpdate
from ..models.user import User

router = APIRouter()


@router.get("/", response_model=List[CreditLimitResponse])
def read_user_credit_limits(
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get current user's credit limits."""
    credit_limits = crud_credit_limit.get_user_credit_limits(db, user_id=current_user.id)
    return credit_limits


@router.get("/available")
def get_available_credit(
    bank_id: str,
    company_id: str,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get available credit for specific bank and company."""
    available_credit = crud_credit_limit.get_available_credit(
        db, current_user.id, bank_id, company_id
    )
    return {"available_credit": available_credit}


@router.get("/{credit_limit_id}", response_model=CreditLimitResponse)
def read_credit_limit(
    credit_limit_id: str,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get credit limit by ID."""
    db_credit_limit = crud_credit_limit.get_credit_limit(db, credit_limit_id=credit_limit_id)
    if db_credit_limit is None:
        raise HTTPException(status_code=404, detail="Credit limit not found")
    
    # Check if credit limit belongs to current user
    if db_credit_limit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    return db_credit_limit


@router.post("/", response_model=CreditLimitResponse)
def create_credit_limit(
    credit_limit: CreditLimitCreate,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Create a new credit limit (admin functionality for demo)."""
    # Check if credit limit already exists for this combination
    existing_limit = crud_credit_limit.get_credit_limit_by_user_bank_company(
        db, credit_limit.user_id, credit_limit.bank_id, credit_limit.company_id
    )
    if existing_limit:
        raise HTTPException(
            status_code=400,
            detail="Credit limit already exists for this user, bank, and company combination"
        )
    
    db_credit_limit = crud_credit_limit.create_credit_limit(db=db, credit_limit=credit_limit)
    return db_credit_limit


@router.put("/{credit_limit_id}", response_model=CreditLimitResponse)
def update_credit_limit(
    credit_limit_id: str,
    credit_limit_update: CreditLimitUpdate,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Update credit limit information (admin functionality for demo)."""
    db_credit_limit = crud_credit_limit.get_credit_limit(db, credit_limit_id)
    if not db_credit_limit:
        raise HTTPException(status_code=404, detail="Credit limit not found")
    
    # For demo purposes, allowing user to update their own credit limit
    # In production, this should be admin-only
    if db_credit_limit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    updated_credit_limit = crud_credit_limit.update_credit_limit(
        db, credit_limit_id, credit_limit_update
    )
    if not updated_credit_limit:
        raise HTTPException(status_code=404, detail="Credit limit not found")
    
    return updated_credit_limit


@router.delete("/{credit_limit_id}")
def delete_credit_limit(
    credit_limit_id: str,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Delete a credit limit (admin functionality for demo)."""
    db_credit_limit = crud_credit_limit.get_credit_limit(db, credit_limit_id)
    if not db_credit_limit:
        raise HTTPException(status_code=404, detail="Credit limit not found")
    
    # For demo purposes, allowing user to delete their own credit limit
    # In production, this should be admin-only
    if db_credit_limit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    success = crud_credit_limit.delete_credit_limit(db, credit_limit_id)
    if not success:
        raise HTTPException(status_code=404, detail="Credit limit not found")
    
    return {"message": "Credit limit deleted successfully"}
