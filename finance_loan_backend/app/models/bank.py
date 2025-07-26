from sqlalchemy import Column, String, Float, Integer, Boolean
from sqlalchemy.orm import relationship
from ..db.database import Base
import uuid


class Bank(Base):
    __tablename__ = "banks"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String, nullable=False)
    code = Column(String, unique=True, nullable=False)
    logo = Column(String, nullable=False)
    interest_rate = Column(Float, nullable=False)
    max_loan_period = Column(Integer, nullable=False)
    is_active = Column(Boolean, default=True)

    # Relationships
    loans = relationship("Loan", back_populates="bank")
    credit_limits = relationship("CreditLimit", back_populates="bank")
