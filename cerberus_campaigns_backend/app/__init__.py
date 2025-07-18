from flask import Flask
from .config import get_config_by_name, current_config_name, Config # Import Config for type hinting if needed
from .extensions import init_extensions, db # db needed for shell context
from . import models as model_module # Import the models module

# Import Blueprints
from .routes.voters import voters_api_bp, public_api_bp
from .api_routes import api_bp
# from .routes.main import main_bp # Example, if you have one
# from .routes.auth import auth_bp # Example, for authentication routes
# from .routes.campaigns import campaigns_api_bp # Example, for campaign routes

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

    # Initialize extensions
    init_extensions(app)

    # Register Blueprints
    app.register_blueprint(public_api_bp) #url_prefix is defined in the blueprint
    app.register_blueprint(voters_api_bp) #url_prefix is defined in the blueprint
    app.register_blueprint(api_bp, url_prefix='/api/v1')
    # Example:
    # from .routes.main import main_bp
    # app.register_blueprint(main_bp)

    # from .routes.auth import auth_bp
    # app.register_blueprint(auth_bp, url_prefix='/auth')

    # from .routes.campaigns import campaigns_api_bp
    # app.register_blueprint(campaigns_api_bp, url_prefix='/api/v1/campaigns')


    # Simple default route for now (can be removed if main_bp provides '/')
    @app.route('/health')
    def health_check():
        return "Backend Healthy!", 200

    # Shell context for flask cli
    # Makes db and models available in `flask shell` without explicit imports
    @app.shell_context_processor
    def make_shell_context():
        context = {'db': db}
        # Add all models from the models module to the shell context
        if hasattr(model_module, '__all__'):
            for name in model_module.__all__:
                model_class = getattr(model_module, name, None)
                if model_class: # Ensure it's actually found
                    context[name] = model_class
        else:
            # Fallback if __all__ is not defined, try to add common ones or inspect module
            # This part might need adjustment based on how models are structured
            common_models = ['User', 'Campaign', 'Voter', 'Interaction'] # Add more as needed
            for model_name in common_models:
                model_class = getattr(model_module, model_name, None)
                if model_class:
                    context[model_name] = model_class
        return context

    return app
