from flask import Blueprint

campaigns_api_bp = Blueprint('campaigns_api', __name__, url_prefix='/api/v1/campaigns')
public_api_bp = Blueprint('public_api', __name__, url_prefix='/api/v1')

from . import routes
