from flask import Blueprint, request, jsonify
from .auth import token_required
from ..models import Campaign
from ..extensions import db

campaigns_api_bp = Blueprint('campaigns_api_bp', __name__, url_prefix='/api/v1/campaigns')

@campaigns_api_bp.route('/', methods=['POST'])
@token_required
def create_campaign(current_user):
    """Creates a new campaign for the logged-in user."""
    data = request.get_json()
    if not data or not data.get('name'):
        return jsonify({'message': 'Campaign name is required'}), 400

    new_campaign = Campaign(
        name=data['name'],
        description=data.get('description'),
        user_id=current_user.id
    )
    db.session.add(new_campaign)
    db.session.commit()

    return jsonify(new_campaign.to_dict()), 201

@campaigns_api_bp.route('/', methods=['GET'])
@token_required
def get_campaigns(current_user):
    """Returns all campaigns associated with the logged-in user."""
    campaigns = Campaign.query.filter_by(user_id=current_user.id).all()
    return jsonify([campaign.to_dict() for campaign in campaigns])

@campaigns_api_bp.route('/<int:campaign_id>', methods=['GET'])
@token_required
def get_campaign(current_user, campaign_id):
    """Returns a single campaign if it belongs to the user."""
    campaign = Campaign.query.filter_by(id=campaign_id, user_id=current_user.id).first_or_404()
    return jsonify(campaign.to_dict())

@campaigns_api_bp.route('/<int:campaign_id>', methods=['PUT'])
@token_required
def update_campaign(current_user, campaign_id):
    """Updates a campaign."""
    campaign = Campaign.query.filter_by(id=campaign_id, user_id=current_user.id).first_or_404()
    data = request.get_json()

    campaign.name = data.get('name', campaign.name)
    campaign.description = data.get('description', campaign.description)
    db.session.commit()

    return jsonify(campaign.to_dict())