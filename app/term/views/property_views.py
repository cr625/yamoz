from app.term import term_blueprint as term
from app.term.models import Term, Tag, Relationship, Ark
from app.term.forms import AddPropertyForm
from flask import render_template, redirect, url_for, flash, request
from flask_login import login_required


@term.route("/property", methods=["GET", "POST"])
def display_relation(output):
    return output


def get_terms_with_predicate_tag():
    ontology_terms = Term.query.filter(
        Term.tags.any(Tag.value == "rdfs:predicate")).all()
    return ontology_terms


@term.route("/property/add/", methods=["GET", "POST"])
@login_required
def add_property():
    term_list = get_terms_with_predicate_tag()
    choices = [('', 'Select a property')] + \
        [(term.concept_id, term.term_string) for term in term_list]

    property_form = AddPropertyForm()
    property_form.predicate_id.choices = choices

    if property_form.validate_on_submit():
        subject = Term.query.filter_by(
            concept_id=property_form.subject_id.data).first()
        predicate = Term.query.filter_by(
            concept_id=property_form.predicate_id.data).first()
        object = Term.query.filter_by(
            concept_id=property_form.object_id.data).first()

        if not subject or not predicate or not object:
            flash("Error: One or more terms could not be found.", "danger")
            return redirect(url_for("term.add_property"))

        # Create a new relationship entry
        ark = Ark().create_ark(shoulder="g1", naan="13183")

        new_relationship = Relationship(
            parent_id=subject.id,
            predicate_id=predicate.id,
            child_id=object.id,
            ark_id=ark.id
        )
        new_relationship.save()

        return subject.term_string + predicate.term_string + object.term_string
    return render_template("property/add_property.jinja", form=property_form)
