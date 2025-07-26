from fastapi import APIRouter, Request, Form, Depends, HTTPException, status
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session
from typing import Optional
import uuid

from .core.config import settings
from .db.database import get_db
from .crud import user as crud_user, loan as crud_loan, bank as crud_bank, company as crud_company, credit_limit as crud_credit_limit
from .schemas.user import UserCreate
from .schemas.bank import BankCreate
from .schemas.company import CompanyCreate
from .schemas.credit_limit import CreditLimitCreate
from .schemas.loan import LoanStatusUpdate

router = APIRouter()
templates = Jinja2Templates(directory="app/templates")

# Simple session storage (in production, use proper session management)
admin_sessions = set()

def get_admin_session(request: Request):
    """Check if admin is authenticated"""
    session_id = request.cookies.get("admin_session")
    if not session_id or session_id not in admin_sessions:
        raise HTTPException(status_code=302, headers={"Location": "/admin/login"})
    return session_id

# Authentication Routes
@router.get("/admin/login", response_class=HTMLResponse)
async def admin_login_page(request: Request, error: Optional[str] = None):
    """Display admin login page"""
    return templates.TemplateResponse("admin/login.html", {
        "request": request,
        "error": error
    })

@router.post("/admin/login")
async def admin_login(
    request: Request,
    email: str = Form(...),
    password: str = Form(...)
):
    """Process admin login"""
    if email == settings.admin_email and password == settings.admin_password:
        session_id = str(uuid.uuid4())
        admin_sessions.add(session_id)
        
        response = RedirectResponse(url="/admin/dashboard", status_code=302)
        response.set_cookie(key="admin_session", value=session_id, httponly=True)
        return response
    else:
        return templates.TemplateResponse("admin/login.html", {
            "request": request,
            "error": "Invalid email or password"
        })

@router.get("/admin/logout")
async def admin_logout(request: Request):
    """Admin logout"""
    session_id = request.cookies.get("admin_session")
    if session_id in admin_sessions:
        admin_sessions.remove(session_id)
    
    response = RedirectResponse(url="/admin/login", status_code=302)
    response.delete_cookie(key="admin_session")
    return response

# Dashboard
@router.get("/admin/dashboard", response_class=HTMLResponse)
async def admin_dashboard(
    request: Request,
    session: str = Depends(get_admin_session),
    db: Session = Depends(get_db)
):
    """Admin dashboard with statistics"""
    try:
        # Get statistics
        from .models.user import User
        from .models.bank import Bank
        from .models.company import Company
        from .models.loan import Loan
        
        total_users = db.query(User).count()
        total_banks = db.query(Bank).count()
        total_companies = db.query(Company).count()
        total_loans = db.query(Loan).count()
        
        pending_loans = db.query(Loan).filter(Loan.status == "pending").count()
        approved_loans = db.query(Loan).filter(Loan.status == "approved").count()
        rejected_loans = db.query(Loan).filter(Loan.status == "rejected").count()
        
        # Recent loans
        recent_loans = db.query(Loan).order_by(Loan.created_at.desc()).limit(5).all()
        
        return templates.TemplateResponse("admin/dashboard.html", {
            "request": request,
            "total_users": total_users,
            "total_banks": total_banks,
            "total_companies": total_companies,
            "total_loans": total_loans,
            "pending_loans": pending_loans,
            "approved_loans": approved_loans,
            "rejected_loans": rejected_loans,
            "recent_loans": recent_loans
        })
    except Exception as e:
        return templates.TemplateResponse("admin/dashboard.html", {
            "request": request,
            "error": f"Error loading dashboard: {str(e)}"
        })

# Loan Management
@router.get("/admin/loans", response_class=HTMLResponse)
async def admin_loans(
    request: Request,
    session: str = Depends(get_admin_session),
    db: Session = Depends(get_db),
    status_filter: Optional[str] = None
):
    """List all loans"""
    try:
        from .models.loan import Loan
        
        query = db.query(Loan)
        if status_filter:
            query = query.filter(Loan.status == status_filter)
        
        loans = query.order_by(Loan.created_at.desc()).all()
        
        return templates.TemplateResponse("admin/loans.html", {
            "request": request,
            "loans": loans,
            "status_filter": status_filter
        })
    except Exception as e:
        return templates.TemplateResponse("admin/loans.html", {
            "request": request,
            "error": f"Error loading loans: {str(e)}",
            "loans": []
        })

# Customer Management
@router.get("/admin/customers", response_class=HTMLResponse)
async def admin_customers(
    request: Request,
    session: str = Depends(get_admin_session),
    db: Session = Depends(get_db)
):
    """List all customers"""
    try:
        from .models.user import User
        
        customers = db.query(User).order_by(User.created_at.desc()).all()
        
        return templates.TemplateResponse("admin/customers.html", {
            "request": request,
            "customers": customers
        })
    except Exception as e:
        return templates.TemplateResponse("admin/customers.html", {
            "request": request,
            "error": f"Error loading customers: {str(e)}",
            "customers": []
        })

# Bank Management
@router.get("/admin/banks", response_class=HTMLResponse)
async def admin_banks(
    request: Request,
    session: str = Depends(get_admin_session),
    db: Session = Depends(get_db)
):
    """List all banks"""
    try:
        from .models.bank import Bank
        
        banks = db.query(Bank).order_by(Bank.name).all()
        
        return templates.TemplateResponse("admin/banks.html", {
            "request": request,
            "banks": banks
        })
    except Exception as e:
        return templates.TemplateResponse("admin/banks.html", {
            "request": request,
            "error": f"Error loading banks: {str(e)}",
            "banks": []
        })

# Company Management
@router.get("/admin/companies", response_class=HTMLResponse)
async def admin_companies(
    request: Request,
    session: str = Depends(get_admin_session),
    db: Session = Depends(get_db)
):
    """List all companies"""
    try:
        from .models.company import Company
        
        companies = db.query(Company).order_by(Company.name).all()
        
        return templates.TemplateResponse("admin/companies.html", {
            "request": request,
            "companies": companies
        })
    except Exception as e:
        return templates.TemplateResponse("admin/companies.html", {
            "request": request,
            "error": f"Error loading companies: {str(e)}",
            "companies": []
        })

# Credit Limit Management
@router.get("/admin/credit-limits", response_class=HTMLResponse)
async def admin_credit_limits(
    request: Request,
    session: str = Depends(get_admin_session),
    db: Session = Depends(get_db)
):
    """List all credit limits"""
    try:
        from .models.credit_limit import CreditLimit
        
        credit_limits = db.query(CreditLimit).order_by(CreditLimit.created_at.desc()).all()
        
        return templates.TemplateResponse("admin/credit_limits.html", {
            "request": request,
            "credit_limits": credit_limits
        })
    except Exception as e:
        return templates.TemplateResponse("admin/credit_limits.html", {
            "request": request,
            "error": f"Error loading credit limits: {str(e)}",
            "credit_limits": []
        })
