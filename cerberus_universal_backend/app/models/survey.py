from ..extensions import db
from .shared_mixins import TimestampMixin

class SurveyQuestion(db.Model):
    __tablename__ = 'survey_questions'

    question_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    campaign_id = db.Column(db.Integer, nullable=True)
    question_text = db.Column(db.Text, nullable=False)
    question_type = db.Column(db.String(50), nullable=False)
    possible_answers = db.Column(db.JSON, nullable=True)

    created_at = db.Column(db.DateTime(timezone=True), server_default=db.func.now())

    campaign = db.relationship('Campaign', back_populates='survey_questions')
    responses = db.relationship('SurveyResponse', back_populates='question', lazy='dynamic', cascade="all, delete-orphan")

    __table_args__ = (
        db.ForeignKeyConstraint(['campaign_id'], ['campaigns.campaign_id'], name='fk_survey_questions_campaign_id', ondelete='CASCADE'),
    )

    def __repr__(self):
        return f"<SurveyQuestion '{self.question_text[:30]}...' (ID: {self.question_id})>"

    def to_dict(self):
        return {
            'question_id': self.question_id,
            'campaign_id': self.campaign_id,
            'question_text': self.question_text,
            'question_type': self.question_type,
            'possible_answers': self.possible_answers,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }

class SurveyResponse(db.Model):
    __tablename__ = 'survey_responses'

    response_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    interaction_id = db.Column(db.Integer, nullable=True)
    voter_id = db.Column(db.Integer, nullable=False, index=True)
    question_id = db.Column(db.Integer, nullable=False, index=True)

    response_value = db.Column(db.Text, nullable=True)
    response_values = db.Column(db.JSON, nullable=True)

    responded_at = db.Column(db.DateTime(timezone=True), server_default=db.func.now())

    interaction = db.relationship('Interaction', back_populates='survey_responses')
    voter = db.relationship('Voter', back_populates='survey_responses')
    question = db.relationship('SurveyQuestion', back_populates='responses')

    __table_args__ = (
        db.ForeignKeyConstraint(['interaction_id'], ['interactions.interaction_id'], name='fk_survey_responses_interaction_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['voter_id'], ['voters.voter_id'], name='fk_survey_responses_voter_id', ondelete='CASCADE'),
        db.ForeignKeyConstraint(['question_id'], ['survey_questions.question_id'], name='fk_survey_responses_question_id', ondelete='CASCADE'),
    )

    def __repr__(self):
        return f"<SurveyResponse ID: {self.response_id} (Voter: {self.voter_id}, Question: {self.question_id})>"

    def to_dict(self):
        return {
            'response_id': self.response_id,
            'interaction_id': self.interaction_id,
            'voter_id': self.voter_id,
            'question_id': self.question_id,
            'response_value': self.response_value,
            'response_values': self.response_values,
            'responded_at': self.responded_at.isoformat() if self.responded_at else None
        }
