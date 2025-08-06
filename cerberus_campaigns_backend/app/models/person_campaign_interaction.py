from ..extensions import db

class PersonCampaignInteraction(db.Model):
    __tablename__ = 'person_campaign_interactions'

    interaction_id = db.Column(db.Integer, primary_key=True)
    person_id = db.Column(db.Integer, db.ForeignKey('persons.person_id', ondelete='CASCADE', use_alter=True), nullable=False)
    campaign_id = db.Column(db.Integer, db.ForeignKey('campaigns.campaign_id', ondelete='CASCADE', use_alter=True), nullable=False)
    interaction_type = db.Column(db.Enum('ContactForm', 'Donation', 'Endorsement', 'Volunteer', 'Other', name='interaction_type_enum'))
    interaction_date = db.Column(db.Date)
    amount = db.Column(db.DECIMAL(10,2))
    follow_up_needed = db.Column(db.Boolean, default=False)
    details = db.Column(db.JSON)
    confidence_score = db.Column(db.Integer, default=100)
    source_id = db.Column(db.Integer, db.ForeignKey('data_sources.source_id'))
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())