from flask import Flask
from .config import Config
from .extensions import db, migrate, bcrypt, cors
from .blueprints.campaigns import campaigns_api_bp, public_api_bp
from .blueprints.reports import reports_bp
from .blueprints.users import users_bp

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    # Initialize extensions
    db.init_app(app)
    migrate.init_app(app, db)
    bcrypt.init_app(app)
    cors.init_app(app, resources={r"/api/*": {"origins": "*"}})

    # Register blueprints
    app.register_blueprint(campaigns_api_bp)
    app.register_blueprint(public_api_bp)
    app.register_blueprint(reports_bp)
    app.register_blueprint(users_bp)

    return app
