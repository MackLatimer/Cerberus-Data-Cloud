from flask import Blueprint, request, jsonify
from ..extensions import db
from ..models import Agenda, AgendaItem, GovernmentBody, Subscription
from ..utils.security import verify_webhook_signature
import json

agendas_bp = Blueprint('agendas_bp', __name__)

@agendas_bp.route('/search', methods=['GET'])
def search():
    filter_mapping = {
        'category': AgendaItem.category,
        'heading': AgendaItem.heading,
    }
    query = db.session.query(AgendaItem).join(Agenda).join(GovernmentBody)

    keyword = request.args.get('keyword', '').strip()
    municipality_name = request.args.get('municipality') if request.args.get('municipality', '').lower() not in ['all', ''] else None
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')

    if start_date:
        query = query.filter(Agenda.date >= start_date)
    if end_date:
        query = query.filter(Agenda.date <= end_date)
    if municipality_name:
        query = query.filter(GovernmentBody.body_name == municipality_name)

    for wix_filter_name, db_column in filter_mapping.items():
        value = request.args.get(wix_filter_name)
        if value and value.lower() not in ['all', '']:
            query = query.filter(db_column == value)

    if keyword:
        search_term = '%' + keyword + '%'
        keyword_search_fields = [GovernmentBody.body_name, AgendaItem.category, AgendaItem.heading, AgendaItem.item_text]
        query = query.filter(db.or_(*[field.ilike(search_term) for field in keyword_search_fields]))

    results = query.order_by(Agenda.date.desc(), GovernmentBody.body_name, AgendaItem.id).all()

    items = [{
        'id': item.id,
        'heading': item.heading,
        'file_prefix': item.file_prefix,
        'item_text': item.item_text,
        'category': item.category,
        'municipality': item.agenda.government_body.body_name,
        'date': item.agenda.date,
        'pdf_url': item.agenda.pdf_url
    } for item in results]

    return jsonify(items)

@agendas_bp.route('/subscribe', methods=['POST'])
def subscribe():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON payload"}), 400

    email = data.get('email')
    filter_settings = data.get('filter_settings')

    if not email or not filter_settings or not isinstance(filter_settings, dict):
        return jsonify({"error": "Email and valid filter_settings (JSON object) are required"}), 400

    subscription = Subscription.query.filter_by(email=email).first()
    if subscription:
        subscription.filter_settings = filter_settings
        subscription.active = True
    else:
        subscription = Subscription(email=email, filter_settings=filter_settings)
        db.session.add(subscription)

    db.session.commit()

    return jsonify({"message": "Subscription successful!"}), 201

@agendas_bp.route('/webhook/order_canceled', methods=['POST'])
@verify_webhook_signature
def order_canceled():
    data = request.get_json()
    if not data or 'data' not in data or 'email' not in data['data']:
        return jsonify({"error": "Invalid payload"}), 400

    email = data['data']['email']
    subscription = Subscription.query.filter_by(email=email).first()
    if subscription:
        subscription.active = False
        db.session.commit()

    return jsonify({"message": "Subscription deactivated"}), 200

@agendas_bp.route('/webhook/order_renewed', methods=['POST'])
@verify_webhook_signature
def order_renewed():
    data = request.get_json()
    if not data or 'data' not in data or 'email' not in data['data']:
        return jsonify({"error": "Invalid payload"}), 400

    email = data['data']['email']
    subscription = Subscription.query.filter_by(email=email).first()
    if subscription:
        subscription.active = True
        db.session.commit()

    return jsonify({"message": "Subscription reactivated"}), 200

@agendas_bp.route('/municipalities', methods=['GET'])
def get_municipalities():
    # Fetch all distinct government bodies, ordered by name.
    municipalities = GovernmentBody.query.order_by(GovernmentBody.body_name).all()
    return jsonify([{'id': m.body_id, 'name': m.body_name} for m in municipalities])

@agendas_bp.route('/categories', methods=['GET'])
def get_categories():
    categories = db.session.query(AgendaItem.category).filter(AgendaItem.category != None, AgendaItem.category != '').distinct().all()
    return jsonify([c[0] for c in categories])

@agendas_bp.route('/headings', methods=['GET'])
def get_headings():
    headings = db.session.query(AgendaItem.heading).filter(AgendaItem.heading != None, AgendaItem.heading != '').distinct().all()
    return jsonify([h[0] for h in headings])
