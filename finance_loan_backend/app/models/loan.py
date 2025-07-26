from sqlalchemy import Column, String, Float, Integer, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from ..db.database import Base
from datetime import datetime
import uuid


class Loan(Base):
    __tablename__ = "loans"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False)
    bank_id = Column(String, ForeignKey("banks.id"), nullable=False)
    company_id = Column(String, ForeignKey("companies.id"), nullable=False)
    amount = Column(Float, nullable=False)
    interest_rate = Column(Float, nullable=False)
    duration_months = Column(Integer, nullable=False)
    monthly_payment = Column(Float, nullable=False)
    total_amount = Column(Float, nullable=False)
    status = Column(String, default="pending")  # pending, approved, rejected, processing, completed
    request_date = Column(DateTime, default=datetime.utcnow)
    approval_date = Column(DateTime, nullable=True)
    rejection_date = Column(DateTime, nullable=True)
    rejection_reason = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="loans")
    bank = relationship("Bank", back_populates="loans")
    company = relationship("Company", back_populates="loans")
