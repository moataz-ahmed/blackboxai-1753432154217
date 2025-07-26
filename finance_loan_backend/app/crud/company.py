from sqlalchemy.orm import Session
from ..models.company import Company
from ..schemas.company import CompanyCreate, CompanyUpdate
from typing import List, Optional


def get_company(db: Session, company_id: str) -> Optional[Company]:
    """Get company by ID."""
    return db.query(Company).filter(Company.id == company_id).first()


def get_companies(db: Session, skip: int = 0, limit: int = 100, active_only: bool = True) -> List[Company]:
    """Get all companies with pagination."""
    query = db.query(Company)
    if active_only:
        query = query.filter(Company.is_active == True)
    return query.offset(skip).limit(limit).all()


def get_companies_by_category(db: Session, category: str, skip: int = 0, limit: int = 100) -> List[Company]:
    """Get companies by category."""
    return db.query(Company).filter(
        Company.category == category,
        Company.is_active == True
    ).offset(skip).limit(limit).all()


def create_company(db: Session, company: CompanyCreate) -> Company:
    """Create a new company."""
    db_company = Company(
        name=company.name,
        description=company.description,
        logo=company.logo,
        category=company.category
    )
    db.add(db_company)
    db.commit()
    db.refresh(db_company)
    return db_company


def update_company(db: Session, company_id: str, company_update: CompanyUpdate) -> Optional[Company]:
    """Update company information."""
    db_company = get_company(db, company_id)
    if not db_company:
        return None
    
    update_data = company_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_company, field, value)
    
    db.commit()
    db.refresh(db_company)
    return db_company


def delete_company(db: Session, company_id: str) -> bool:
    """Delete a company (soft delete by setting is_active to False)."""
    db_company = get_company(db, company_id)
    if not db_company:
        return False
    
    db_company.is_active = False
    db.commit()
    return True
