# This file makes the 'models' directory a Python package.

# Import all models here to make them easily accessible
# and to ensure they are registered with SQLAlchemy before
# database operations like `db.create_all()` or migrations are run.

from .campaign import Campaign
from .user import User
from .voter import Voter, CampaignVoter
from .interaction import Interaction
from .survey import SurveyQuestion, SurveyResponse
from .donation import Donation # Moved this import here

# You can define an __all__ variable if you want to specify
# what `from .models import *` should import.
__all__ = [
    'Campaign',
    'User',
    'Voter',
    'CampaignVoter',
    'Interaction',
    'SurveyQuestion',
    'SurveyResponse',
    'Donation', # Only the string name here
]

# It's also a good place to import the `db` instance if models need it directly,
# though typically models will import it from `app.extensions`.
# from ..extensions import db
