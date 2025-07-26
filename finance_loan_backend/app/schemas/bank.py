from pydantic import BaseModel
from typing import Optional


class BankBase(BaseModel):
    name: str
    code: str
    logo: str
    interest_rate: float
    max_loan_period: int


class BankCreate(BankBase):
    pass


class BankUpdate(BaseModel):
    name: Optional[str] = None
    logo: Optional[str] = None
    interest_rate: Optional[float] = None
    max_loan_period: Optional[int] = None
    is_active: Optional[bool] = None


class BankResponse(BankBase):
    id: str
    is_active: bool

    class Config:
        from_attributes = True
