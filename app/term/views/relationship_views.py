from flask import flash, redirect, render_template, url_for
from flask_login import current_user, login_required

from app.term import term_blueprint as term
from app.term.forms import AddRelationshipForm
from app.term.models import Ark, Relationship, Tag, Term


@term.route("/relationship", methods=["GET", "POST"])
def display_relation(output):
    return output


def get_terms_with_predicate_tag():
    ontology_terms = Term.query.filter(
        Term.tags.any(Tag.value == "rdfs:predicate")).all()
    return ontology_terms


@term.route("/relationship/add/", methods=["GET", "POST"])
@login_required
def add_relationship():
    term_list = get_terms_with_predicate_tag()
    choices = [('', 'Select a relationship')] + \
        [(term.concept_id, term.term_string) for term in term_list]

    relationship_form = AddRelationshipForm()
    relationship_form.predicate_id.choices = choices

    if relationship_form.validate_on_submit():
        subject = Term.query.filter_by(
            concept_id=relationship_form.subject_id.data).first()
        predicate = Term.query.filter_by(
            concept_id=relationship_form.predicate_id.data).first()
        object = Term.query.filter_by(
            concept_id=relationship_form.object_id.data).first()

        if not subject or not predicate or not object:
            flash("Error: One or more terms could not be found.", "danger")
            return redirect(url_for("term.add_relationship"))

        # Create a new relationship entry
        ark = Ark().create_ark(shoulder="g1", naan="13183")

        new_relationship = Relationship(
            parent_id=subject.id,
            predicate_id=predicate.id,
            child_id=object.id,
            ark_id=ark.id,
            owner_id=current_user.id
        )
        new_relationship.save()

        return subject.term_string + predicate.term_string + object.term_string
    return render_template("relationship/add_relationship.jinja", form=relationship_form)


@term.route("/relationship/edit/<int:relationship_id>", methods=["GET", "POST"])
@login_required
def edit_relationship(relationship_id):
    relationship = Relationship.query.get_or_404(relationship_id)
    term_list = get_terms_with_predicate_tag()
    choices = [('', 'Select a relationship')] + \
        [(term.concept_id, term.term_string) for term in term_list]

    relationship_form = AddRelationshipForm()
    relationship_form.predicate_id.choices = choices

    if relationship_form.validate_on_submit():
        subject = Term.query.filter_by(
            concept_id=relationship_form.subject_id.data).first()
        predicate = Term.query.filter_by(
            concept_id=relationship_form.predicate_id.data).first()
        object = Term.query.filter_by(
            concept_id=relationship_form.object_id.data).first()

        if not subject or not predicate or not object:
            flash("Error: One or more terms could not be found.", "danger")
            return redirect(url_for("term.edit_relationship", relationship_id=relationship_id))

        relationship.parent_id = subject.id
        relationship.predicate_id = predicate.id
        relationship.child_id = object.id
        relationship.save()

        return redirect(url_for("term.display_relationship", relationship_id=relationship_id))

    relationship_form.subject_id.data = relationship.parent.concept_id
    relationship_form.predicate_id.data = relationship.predicate.concept_id
    relationship_form.object_id.data = relationship.child.concept_id

    return render_template("relationship/edit_relationship.jinja", form=relationship_form)


@term.route("/relationship/display/<int:relationship_id>")
def display_relationship(relationship_id):
    relationship = Relationship.query.get_or_404(relationship_id)
    return render_template("relationship/display_relationship.jinja", relationship=relationship)


@term.route("/relationship/delete/<int:relationship_id>", methods=["POST"])
@login_required
def delete_relationship(relationship_id):
    relationship = Relationship.query.get_or_404(relationship_id)
    relationship.delete()
    flash("Relationship deleted.")
    return redirect(url_for("term.list_properties"))


@term.route("/relationship/list/")
def list_properties():
    relationships = Relationship.query.all()
    return render_template("relationship/list_properties.jinja", relationships=relationships)
