from sqlalchemy import Column, Integer, String, Date, Boolean, JSON, TIMESTAMP, Enum, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import JSONB

Base = declarative_base()

class Person(Base):
    __tablename__ = 'persons'

    person_id = Column(Integer, primary_key=True)
    first_name = Column(String(255))
    last_name = Column(String(255))
    date_of_birth = Column(Date)
    gender = Column(Enum('Male', 'Female', 'Non-binary', 'Other', 'Unknown', name='gender_enum'))
    party_affiliation = Column(String(100))
    ethnicity = Column(String(100))
    income_bracket = Column(Enum('Low', 'Middle', 'High', 'Unknown', name='income_bracket_enum'))
    education_level = Column(String(100))
    voter_propensity_score = Column(Integer)
    registration_status = Column(Enum('Active', 'Inactive', 'Purged', name='registration_status_enum'), default='Active')
    status_change_date = Column(Date)
    consent_opt_in = Column(Boolean, default=False)
    duplicate_flag = Column(Boolean, default=False)
    last_contact_date = Column(Date)
    ml_tags = Column(JSONB)
    change_history = Column(JSONB)
    preferred_contact_method = Column(Enum('Email', 'Phone', 'Mail', 'SocialMedia', 'None', name='preferred_contact_method_enum'))
    language_preference = Column(String(50))
    accessibility_needs = Column(String)
    last_updated_by = Column(String(255))
    source_id = Column(Integer, ForeignKey('data_sources.source_id'))
    created_at = Column(TIMESTAMP, default=func.current_timestamp())
    updated_at = Column(TIMESTAMP, default=func.current_timestamp(), onupdate=func.current_timestamp())

    def to_dict(self):
        return {
            "person_id": self.person_id,
            "first_name": self.first_name,
            "last_name": self.last_name,
            "date_of_birth": str(self.date_of_birth) if self.date_of_birth else None,
            "gender": self.gender.value if self.gender else None,
            "party_affiliation": self.party_affiliation,
            "ethnicity": self.ethnicity,
            "income_bracket": self.income_bracket.value if self.income_bracket else None,
            "education_level": self.education_level,
            "voter_propensity_score": self.voter_propensity_score,
            "registration_status": self.registration_status.value if self.registration_status else None,
            "status_change_date": str(self.status_change_date) if self.status_change_date else None,
            "consent_opt_in": self.consent_opt_in,
            "duplicate_flag": self.duplicate_flag,
            "last_contact_date": str(self.last_contact_date) if self.last_contact_date else None,
            "ml_tags": self.ml_tags,
            "change_history": self.change_history,
            "preferred_contact_method": self.preferred_contact_method.value if self.preferred_contact_method else None,
            "language_preference": self.language_preference,
            "accessibility_needs": self.accessibility_needs,
            "last_updated_by": self.last_updated_by,
            "source_id": self.source_id,
            "created_at": str(self.created_at),
            "updated_at": str(self.updated_at),
        }