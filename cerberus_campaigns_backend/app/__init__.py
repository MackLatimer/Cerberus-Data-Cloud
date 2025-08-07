from flask import Flask
from flask_cors import CORS
from .config import get_config_by_name, current_config_name, Config
from .extensions import init_extensions, db
from .models import (
    DataSource, Person, PartyAffiliationHistory, PersonIdentifier, Address,
    PersonAddress, PersonEmail, PersonPhone, PersonSocialMedia, PersonEmployer,
    PersonPaymentInfo, PersonOtherContact, VoterHistory, SurveyResult,
    PersonRelationship, District, AddressDistrict, Campaign,
    PersonCampaignInteraction, GovernmentBody, Position, Donation,
    PersonMerge, AuditLog, BackupLog, User, Voter
)
from . import models as model_module

from .routes.voters import voters_api_bp, public_api_bp
from .routes.donate import donate_bp

def create_app(config_name_override: str = None) -> Flask:
    """
    Application factory function.
    :param config_name_override: String name of the configuration to use (e.g., 'development', 'production', 'testing').
                                 If None, it's determined by FLASK_ENV or defaults to 'development'.
    :return: Flask application instance.
    """

    effective_config_name = config_name_override if config_name_override is not None else current_config_name

    app = Flask(__name__)
    app.config.from_object(get_config_by_name(effective_config_name))

    CORS(app, resources={
        r"/api/*": {"origins": "*"}
    }, supports_credentials=True)

    init_extensions(app)

    app.register_blueprint(public_api_bp)
    app.register_blueprint(voters_api_bp)
    app.register_blueprint(donate_bp)

    @app.route('/health')
    def health_check():
        return "Backend Healthy!", 200

    @app.shell_context_processor
    def make_shell_context():
        context = {'db': db}
        # Dynamically add all models from model_module to the shell context
        for name in dir(model_module):
            model_class = getattr(model_module, name)
            if isinstance(model_class, type) and hasattr(model_class, '__tablename__'):
                context[name] = model_class
        return context

    print(app.url_map)
    return app
