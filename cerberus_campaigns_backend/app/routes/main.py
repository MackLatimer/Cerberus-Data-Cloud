from flask import Blueprint, jsonify

main_bp = Blueprint('main_bp', __name__)

@main_bp.route('/')
def index():
    """Welcome route for the API."""
    return jsonify({"message": "Welcome to the Cerberus Campaigns API"}), 200