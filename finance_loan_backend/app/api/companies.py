from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..core.deps import get_current_active_user
from ..db.database import get_db
from ..crud import company as crud_company
from ..schemas.company import CompanyResponse, CompanyCreate, CompanyUpdate
from ..models.user import User

router = APIRouter()


@router.get("/", response_model=List[CompanyResponse])
def read_companies(
    skip: int = 0,
    limit: int = 100,
    active_only: bool = True,
    category: str = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Get all companies."""
    if category:
        companies = crud_company.get_companies_by_category(
            db, category=category, skip=skip, limit=limit
        )
    else:
        companies = crud_company.get_companies(
            db, skip=skip, limit=limit, active_only=active_only
        )
    return companies


@router.get("/{company_id}", response_model=CompanyResponse)
def read_company(
    company_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Get company by ID."""
    db_company = crud_company.get_company(db, company_id=company_id)
    if db_company is None:
        raise HTTPException(status_code=404, detail="Company not found")
    return db_company


@router.post("/", response_model=CompanyResponse)
def create_company(
    company: CompanyCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Create a new company (admin functionality for demo)."""
    db_company = crud_company.create_company(db=db, company=company)
    return db_company


@router.put("/{company_id}", response_model=CompanyResponse)
def update_company(
    company_id: str,
    company_update: CompanyUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Update company information (admin functionality for demo)."""
    updated_company = crud_company.update_company(db, company_id, company_update)
    if not updated_company:
        raise HTTPException(status_code=404, detail="Company not found")
    return updated_company


@router.delete("/{company_id}")
def delete_company(
    company_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Delete a company (soft delete - admin functionality for demo)."""
    success = crud_company.delete_company(db, company_id)
    if not success:
        raise HTTPException(status_code=404, detail="Company not found")
    return {"message": "Company deactivated successfully"}
