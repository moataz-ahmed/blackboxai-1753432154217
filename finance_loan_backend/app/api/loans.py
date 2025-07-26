from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..core.deps import get_current_active_user
from ..db.database import get_db
from ..crud import loan as crud_loan, credit_limit as crud_credit_limit
from ..schemas.loan import LoanCreate, LoanResponse, LoanStatusUpdate
from ..models.user import User

router = APIRouter()


@router.post("/", response_model=LoanResponse)
def create_loan(
    loan: LoanCreate,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Create a new loan request."""
    # Check if user has sufficient credit limit
    available_credit = crud_credit_limit.get_available_credit(
        db, current_user.id, loan.bank_id, loan.company_id
    )
    
    if loan.amount > available_credit:
        raise HTTPException(
            status_code=400,
            detail=f"Loan amount exceeds available credit limit of {available_credit}"
        )
    
    try:
        db_loan = crud_loan.create_loan(db=db, loan=loan, user_id=current_user.id)
        return db_loan
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/", response_model=List[LoanResponse])
def read_user_loans(
    skip: int = 0,
    limit: int = 100,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get current user's loans."""
    loans = crud_loan.get_user_loans(db, user_id=current_user.id, skip=skip, limit=limit)
    return loans


@router.get("/statistics")
def get_loan_statistics(
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get loan statistics for current user."""
    stats = crud_loan.get_loan_statistics(db, user_id=current_user.id)
    return stats


@router.get("/{loan_id}", response_model=LoanResponse)
def read_loan(
    loan_id: str,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get loan by ID."""
    db_loan = crud_loan.get_loan(db, loan_id=loan_id)
    if db_loan is None:
        raise HTTPException(status_code=404, detail="Loan not found")
    
    # Check if loan belongs to current user
    if db_loan.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    return db_loan


@router.put("/{loan_id}/status", response_model=LoanResponse)
def update_loan_status(
    loan_id: str,
    status_update: LoanStatusUpdate,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Update loan status (for admin use - in real app, this would be admin-only)."""
    db_loan = crud_loan.get_loan(db, loan_id=loan_id)
    if db_loan is None:
        raise HTTPException(status_code=404, detail="Loan not found")
    
    # For demo purposes, allowing user to update their own loan status
    # In production, this should be admin-only
    if db_loan.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    updated_loan = crud_loan.update_loan_status(db, loan_id, status_update)
    if not updated_loan:
        raise HTTPException(status_code=404, detail="Loan not found")
    
    # If loan is approved, update credit limit
    if status_update.status == "approved":
        crud_credit_limit.update_used_credit(
            db, updated_loan.user_id, updated_loan.bank_id, 
            updated_loan.company_id, updated_loan.amount
        )
    
    return updated_loan


@router.delete("/{loan_id}")
def delete_loan(
    loan_id: str,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Delete a loan (only if pending)."""
    db_loan = crud_loan.get_loan(db, loan_id=loan_id)
    if db_loan is None:
        raise HTTPException(status_code=404, detail="Loan not found")
    
    # Check if loan belongs to current user
    if db_loan.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    success = crud_loan.delete_loan(db, loan_id)
    if not success:
        raise HTTPException(
            status_code=400, 
            detail="Cannot delete loan. Only pending loans can be deleted."
        )
    
    return {"message": "Loan deleted successfully"}
