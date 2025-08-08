from ..extensions import db

class Person(db.Model):
    __tablename__ = 'persons'

    person_id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(255))
    last_name = db.Column(db.String(255))
    date_of_birth = db.Column(db.Date)
    gender = db.Column(db.Enum('Male', 'Female', 'Non-binary', 'Other', 'Unknown', name='gender_enum'))
    party_affiliation = db.Column(db.String(100))
    ethnicity = db.Column(db.String(100))
    income_bracket = db.Column(db.Enum('Low', 'Middle', 'High', 'Unknown', name='income_bracket_enum'))
    education_level = db.Column(db.String(100))
    voter_propensity_score = db.Column(db.Integer)
    registration_status = db.Column(db.Enum('Active', 'Inactive', 'Purged', name='registration_status_enum'), default='Active')
    status_change_date = db.Column(db.Date)
    consent_opt_in = db.Column(db.Boolean, default=False)
    duplicate_flag = db.Column(db.Boolean, default=False)
    last_contact_date = db.Column(db.Date)
    ml_tags = db.Column(db.JSON)
    change_history = db.Column(db.JSON)
    preferred_contact_method = db.Column(db.Enum('Email', 'Phone', 'Mail', 'SocialMedia', 'None', name='preferred_contact_method_enum'))
    language_preference = db.Column(db.String(50))
    accessibility_needs = db.Column(db.String)
    last_updated_by = db.Column(db.String(255))
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_persons_source_id'),
    )

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