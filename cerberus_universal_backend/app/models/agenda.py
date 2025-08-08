from ..extensions import db
from sqlalchemy import UniqueConstraint

class Agenda(db.Model):
    __tablename__ = 'agendas'

    id = db.Column(db.Integer, primary_key=True)
    body_id = db.Column(db.Integer, db.ForeignKey('government_bodies.body_id'), nullable=False)
    date = db.Column(db.String, nullable=False)
    pdf_url = db.Column(db.String, nullable=False)
    scraped_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())

    items = db.relationship("AgendaItem", back_populates="agenda")
    government_body = db.relationship("GovernmentBody", back_populates="agendas")

    __table_args__ = (UniqueConstraint('body_id', 'date', 'pdf_url', name='_body_date_url_uc'),)

class AgendaItem(db.Model):
    __tablename__ = 'agenda_items'

    id = db.Column(db.Integer, primary_key=True)
    agenda_id = db.Column(db.Integer, db.ForeignKey('agendas.id'), nullable=False)
    heading = db.Column(db.String)
    file_prefix = db.Column(db.String)
    item_text = db.Column(db.String, nullable=False)
    category = db.Column(db.String)
    created_at = db.Column(db.TIMESTAMP, default=db.func.current_timestamp())

    agenda = db.relationship("Agenda", back_populates="items")

    __table_args__ = (UniqueConstraint('agenda_id', 'item_text', name='_agenda_item_text_uc'),)
