from flask import flash, redirect, render_template, url_for
from flask_login import login_required

from app.term import term_blueprint as term
from app.term.forms import AddPropertyForm
from app.term.models import Ark, Relationship, Tag, Term


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


@term.route("/property/edit/<int:relationship_id>", methods=["GET", "POST"])
@login_required
def edit_property(relationship_id):
    relationship = Relationship.query.get_or_404(relationship_id)
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
            return redirect(url_for("term.edit_property", relationship_id=relationship_id))

        relationship.parent_id = subject.id
        relationship.predicate_id = predicate.id
        relationship.child_id = object.id
        relationship.save()

        return redirect(url_for("term.display_property", relationship_id=relationship_id))

    property_form.subject_id.data = relationship.parent.concept_id
    property_form.predicate_id.data = relationship.predicate.concept_id
    property_form.object_id.data = relationship.child.concept_id

    return render_template("property/edit_property.jinja", form=property_form)


@term.route("/property/display/<int:relationship_id>")
def display_property(relationship_id):
    relationship = Relationship.query.get_or_404(relationship_id)
    return render_template("property/display_property.jinja", relationship=relationship)


@term.route("/property/delete/<int:relationship_id>", methods=["POST"])
@login_required
def delete_property(relationship_id):
    relationship = Relationship.query.get_or_404(relationship_id)
    relationship.delete()
    flash("Relationship deleted.")
    return redirect(url_for("term.list_properties"))


@term.route("/property/list/")
def list_properties():
    relationships = Relationship.query.all()
    return render_template("property/list_properties.jinja", relationships=relationships)
