from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class LoanBase(BaseModel):
    bank_id: str
    company_id: str
    amount: float
    duration_months: int


class LoanCreate(LoanBase):
    pass


class LoanUpdate(BaseModel):
    status: Optional[str] = None
    rejection_reason: Optional[str] = None


class LoanResponse(LoanBase):
    id: str
    user_id: str
    interest_rate: float
    monthly_payment: float
    total_amount: float
    status: str
    request_date: datetime
    approval_date: Optional[datetime] = None
    rejection_date: Optional[datetime] = None
    rejection_reason: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True


class LoanStatusUpdate(BaseModel):
    status: str  # pending, approved, rejected, processing, completed
    rejection_reason: Optional[str] = None
