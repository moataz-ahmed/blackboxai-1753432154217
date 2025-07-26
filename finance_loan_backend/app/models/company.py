from sqlalchemy import Column, String, Boolean, DateTime
from sqlalchemy.orm import relationship
from ..db.database import Base
from datetime import datetime
import uuid


class Company(Base):
    __tablename__ = "companies"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String, nullable=False)
    description = Column(String, nullable=False)
    logo = Column(String, nullable=False)
    category = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    loans = relationship("Loan", back_populates="company")
    credit_limits = relationship("CreditLimit", back_populates="company")
