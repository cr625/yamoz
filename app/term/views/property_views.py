from app.term import term_blueprint as term
from app.term.models import Term, Tag
from app.term.forms import AddPropertyForm
from flask import render_template, redirect, url_for, flash, request


@term.route("/property", methods=["GET", "POST"])
def index():
    return "property"


def get_terms_with_relationship_tag():
    relationship_terms = Term.query.filter(
        Term.tags.any(Tag.category == "relationship")).all()
    return relationship_terms


@term.route("/property/add/", methods=["GET", "POST"])
def add_property():
    term_list = get_terms_with_relationship_tag()
    choices = [('', 'Select a property')] + \
        [(term.concept_id, term.term_string) for term in term_list]

    property_form = AddPropertyForm()
    property_form.predicate_id.choices = choices

    if property_form.validate_on_submit():
        if property_form.predicate_id.data == '':
            flash("Please select a valid relationship.")
        else:
            flash("Property added")
            return redirect(url_for("term.index"))
    return render_template("property/add_property.jinja", form=property_form)
