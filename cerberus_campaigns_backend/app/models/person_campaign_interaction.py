from ..extensions import db

class PersonCampaignInteraction(db.Model):
    __tablename__ = 'person_campaign_interactions'

    interaction_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, nullable=False)
    campaign_id = db.Column(db.Integer, nullable=False)
    user_id = db.Column(db.Integer, nullable=False)
    interaction_type = db.Column(db.Enum('ContactForm', 'Donation', 'Endorsement', 'Volunteer', 'Other', name='interaction_type_enum'))
    interaction_date = db.Column(db.Date)
    amount = db.Column(db.DECIMAL(10,2))
    follow_up_needed = db.Column(db.Boolean, default=False)
    details = db.Column(db.JSON)
    confidence_score = db.Column(db.Integer, default=100)
    source_id = db.Column(db.Integer)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    __table_args__ = (
        db.ForeignKeyConstraint(['person_id'], ['persons.person_id'], name='fk_person_campaign_interactions_person_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['campaign_id'], ['campaigns.campaign_id'], name='fk_person_campaign_interactions_campaign_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['user_id'], ['users.user_id'], name='fk_person_campaign_interactions_user_id'),
        db.ForeignKeyConstraint(['source_id'], ['data_sources.source_id'], name='fk_person_campaign_interactions_source_id'),
    )