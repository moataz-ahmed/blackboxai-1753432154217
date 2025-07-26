from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class CreditLimitBase(BaseModel):
    bank_id: str
    company_id: str
    total_limit: float


class CreditLimitCreate(CreditLimitBase):
    user_id: str


class CreditLimitUpdate(BaseModel):
    total_limit: Optional[float] = None
    used_limit: Optional[float] = None
    available_limit: Optional[float] = None


class CreditLimitResponse(CreditLimitBase):
    id: str
    user_id: str
    used_limit: float
    available_limit: float
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
