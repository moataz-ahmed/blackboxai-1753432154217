from sqlalchemy import Column, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from ..db.database import Base
from datetime import datetime
import uuid


class CreditLimit(Base):
    __tablename__ = "credit_limits"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False)
    bank_id = Column(String, ForeignKey("banks.id"), nullable=False)
    company_id = Column(String, ForeignKey("companies.id"), nullable=False)
    total_limit = Column(Float, nullable=False)
    used_limit = Column(Float, default=0.0)
    available_limit = Column(Float, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="credit_limits")
    bank = relationship("Bank", back_populates="credit_limits")
    company = relationship("Company", back_populates="credit_limits")
