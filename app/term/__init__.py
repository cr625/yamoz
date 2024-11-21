from flask import Blueprint

term_blueprint = Blueprint("term", __name__, template_folder="templates")

from app.term.views.term_views import *
from app.term.views.property_views import *
from app.term.views.tag_views import *
from app.term.views.api_routes import *
