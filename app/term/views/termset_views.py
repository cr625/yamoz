import os
from flask import (flash, redirect, render_template,
                   send_file, url_for, request)
from flask_login import current_user, login_required

from app.term import term_blueprint as term
from app.term.forms import EmptyForm, AddTagForm, EditTermSetForm, AddSubClassForm
from app.term.models import TermSet, Tag, Term, Ark, Relationship
from app.user.models import User
from app.term.views.list_views import *
from app.term.models.association_tables import termset_relationships

from app.io.ontology import OntologyClassifier


def get_hierarchy_data(term_set_id):
    term_set = TermSet.query.get_or_404(term_set_id)
    classifier = OntologyClassifier(term_set)
    hierarchy = classifier.build_hierarchy()

    # Identify a root node (a node with no incoming edges)
    root = [node for node, degree in hierarchy.in_degree() if degree == 0]
    if not root:
        flash("No root node found for the hierarchy.")
        return redirect(url_for("term.display_termset", term_set_id=term_set_id))

    # Convert the hierarchy to a nested dictionary format
    def build_tree(node):
        children = list(hierarchy.successors(node))
        return {
            "name": node,
            "definition": hierarchy.nodes[node].get('definition', 'No definition available'),
            "children": [build_tree(child) for child in children]
        }
    hierarchy_data = build_tree(root[0])
    return hierarchy_data


def populate_relationships(relationships, term_set):
    for relationship in relationships:
        relationship.parent = Term.query.get(relationship.parent_id)
        relationship.predicate = Term.query.get(relationship.predicate_id)
        relationship.child = Term.query.get(relationship.child_id)
        relationship.owner = User.query.get(relationship.owner_id)
        relationship.ark = Ark.query.get(relationship.ark_id)
        relationship.termset_name = term_set.name
    return relationships


@term.route("/set/list")
def list_termsets():
    term_sets = TermSet.query.order_by(TermSet.name)
    return render_template("termset/list_termsets.jinja", term_sets=term_sets)


@term.route("/set/display/<int:term_set_id>")
def display_termset(term_set_id):
    term_set = TermSet.query.get_or_404(term_set_id)
    tag_form = AddTagForm()
    add_subclass_form = AddSubClassForm()
    tag_form.tag_list.choices = [(tag.id, tag.value)
                                 for tag in Tag.query.order_by(Tag.value).all()]

    hierarchy_data = get_hierarchy_data(term_set_id)

    relationships = populate_relationships(term_set.relationships, term_set)

    return render_template(
        "termset/display_termset.jinja",
        term_set=term_set,
        form=EmptyForm(),
        tag_form=tag_form,
        subclass_form=add_subclass_form,
        relationships=relationships,
        hierarchy=hierarchy_data
    )


@term.route("/set/add_subclass/<int:term_set_id>", methods=["POST"])
@login_required
def add_subclass(term_set_id):
    term_set = TermSet.query.get_or_404(term_set_id)
    add_subclass_form = AddSubClassForm()

    # get the rdfs:subClassOf term
    rdfs_subclass = Term.query.filter_by(term_string="rdfs:subClassOf").first()
    child_term = Term.query.filter_by(
        concept_id=add_subclass_form.child_id.data).first()
    if not child_term:
        flash("Error: Child term not found.")
        return redirect(url_for("term.display_termset", term_set_id=term_set_id, tab="classes"))

    if add_subclass_form.validate_on_submit():
        relationship = Relationship(
            parent_id=add_subclass_form.parent_term_id.data,
            predicate_id=rdfs_subclass.id,
            child_id=child_term.id,
            owner_id=current_user.id,
            ark_id=Ark().create_ark(shoulder="g1", naan="13183").id,
            created=db.func.now(),
            modified=db.func.now()
        )

        # Add the specific tag to the relationship
        subclass_tag = Tag.query.filter_by(value="subclass_added").first()
        if subclass_tag:
            relationship.tags.append(subclass_tag)
        db.session.add(relationship)
        db.session.commit()

        # Append the relationship to the term set
        term_set.relationships.append(relationship)
        db.session.commit()

        # Add the child term to the term set if not already a member
        if child_term not in term_set.terms:
            term_set.terms.append(child_term)
            db.session.commit()

        flash("Subclass added successfully.")
    else:
        # Log form errors
        for field, errors in add_subclass_form.errors.items():
            for error in errors:
                current_app.logger.error(f"Error in {field}: {error}")
        flash("Error: Form validation failed.")

    return redirect(url_for("term.display_termset", term_set_id=term_set_id, tab="classes"))


@term.route("/set/edit/<int:term_set_id>", methods=["GET", "POST"])
@login_required
def edit_termset(term_set_id):
    term_set = TermSet.query.get_or_404(term_set_id)
    form = EditTermSetForm(obj=term_set)

    if form.validate_on_submit():
        form.populate_obj(term_set)
        db.session.commit()
        flash("Term set updated.")
        return redirect(url_for("term.display_termset", term_set_id=term_set_id))
    else:
        if request.method == "POST":
            flash("Error: Form validation failed.")
            for field, errors in form.errors.items():
                for error in errors:
                    flash(
                        f"Error in {getattr(form, field).label.text}: {error}")

    return render_template("termset/edit_termset.jinja", form=form, term_set=term_set)


@term.route("/set/delete/<int:term_set_id>", methods=["POST"])
@login_required
def delete_term_set(term_set_id):
    term_set = TermSet.query.get_or_404(term_set_id)
    if term_set.user_id == current_user.id or current_user.is_administrator:
        db.session.delete(term_set)
        db.session.commit()
        flash("Term set deleted.")
    else:
        flash("You are not authorized to delete this term set.")
    return redirect(url_for("term.list_termsets"))


@term.route("/set/add_tag/<int:term_set_id>", methods=["POST"])
@login_required
def add_tag_to_term_set(term_set_id):
    term_set = TermSet.query.get_or_404(term_set_id)
    tag_form = AddTagForm()
    tag_form.tag_list.choices = [('', 'Select a tag')] + [(tag.id, tag.value)
                                                          for tag in Tag.query.order_by(Tag.value).all()]

    if tag_form.validate_on_submit():
        if tag_form.tag_list.data == '':
            flash("Please select a valid tag.")
        else:
            tag = Tag.query.get(tag_form.tag_list.data)
            if tag:
                if tag not in term_set.tags:
                    term_set.tags.append(tag)
                    db.session.commit()
                    flash("Tag added.")
                else:
                    flash("Tag already exists in the term set.")
            else:
                flash("Invalid tag selected.")
    return redirect(url_for("term.display_termset", term_set_id=term_set_id))


@term.route("/set/remove_tag/<int:term_set_id>/<int:tag_id>", methods=["POST"])
@login_required
def remove_tag_from_term_set(term_set_id, tag_id):
    form = EmptyForm()
    term_set = TermSet.query.get_or_404(term_set_id)
    tag = Tag.query.get_or_404(tag_id)
    if tag in term_set.tags:
        term_set.tags.remove(tag)
        db.session.commit()
        flash("Tag removed.")
    else:
        flash("Tag not found in term set.")
    return redirect(url_for("term.display_termset", term_set_id=term_set_id))


@term.route("/set/download_file/<filename>", methods=["GET"])
@login_required
def download_file(filename):
    import_dir = os.path.join(current_app.root_path, 'io', 'import')
    file_path = os.path.join(import_dir, filename)

    # Log the file path for debugging
    current_app.logger.debug(f"Looking for file at: {file_path}")

    if os.path.exists(file_path):
        return send_file(file_path, as_attachment=True)
    else:
        flash("File not found.")
        return redirect(url_for("term.list_terms"))


@term.route("/set/classify_ontology/<int:term_set_id>")
@login_required
def classify_ontology(term_set_id):
    term_set = TermSet.query.get_or_404(term_set_id)
    classifier = OntologyClassifier(term_set)
    relationships = classifier.create_relationships()

    # Fetch term strings for relationships
    new_relationships = populate_relationships(relationships, term_set)

    flash("OntologyClassifier completed.")
    return render_template("termset/list_relations.jinja", relationships=new_relationships)


@term.route("/set/relationships/<int:term_set_id>")
@login_required
def list_termset_relationships(term_set_id):
    term_set = TermSet.query.get_or_404(term_set_id)
    relationships = term_set.relationships

    relationships = populate_relationships(relationships, term_set)

    return render_template("termset/list_relations.jinja", relationships=relationships)


@term.route("/set/classes/display/<int:term_set_id>")
def display_classes(term_set_id):
    term_set = TermSet.query.get_or_404(term_set_id)
    hierarchy_data = get_hierarchy_data(term_set_id)

    return render_template("termset/display_classes.jinja", hierarchy=hierarchy_data, term_set=term_set)


@term.route("/set/copy/<int:term_set_id>", methods=["POST"])
@login_required
def copy_termset(term_set_id):
    original_term_set = TermSet.query.get_or_404(term_set_id)
    new_term_set = TermSet(
        name=f"Copy of {original_term_set.name}",
        description=original_term_set.description,
        source=original_term_set.source,
        user_id=current_user.id,
        created=db.func.now(),
        updated=db.func.now()
    )
    db.session.add(new_term_set)
    db.session.commit()

    # Copy tags
    for tag in original_term_set.tags:
        new_term_set.tags.append(tag)

    # Copy terms
    for term in original_term_set.terms:
        new_term_set.terms.append(term)

    db.session.commit()
    flash("Term set copied successfully.")
    return redirect(url_for("term.edit_termset", term_set_id=new_term_set.id))


@term.route("/set/simple/<int:term_set_id>")
def display_simple_termset(term_set_id):
    term_set = TermSet.query.get_or_404(term_set_id)

    return render_template(
        "termset/display_simple_termset.jinja",
        term_set=term_set,
    )
