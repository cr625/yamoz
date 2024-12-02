from flask import (flash, redirect, render_template, url_for)
from flask_login import current_user, login_required

from app.term import term_blueprint as term
from app.term.forms import *
from app.term.models import *
from app.term.views.list_views import *
from app.term.views.tag_views import create_tag
from app.utilities import *


@term.route("/set/list")
def list_term_sets():
    term_sets = TermSet.query.order_by(TermSet.name)
    return render_template("term/list_term_sets.jinja", term_sets=term_sets)


@term.route("/set/display/<int:term_set_id>")
def display_term_set(term_set_id):
    term_set = TermSet.query.get_or_404(term_set_id)
    tag_form = AddTagForm()
    tag_form.tag_list.choices = [(tag.id, tag.value)
                                 for tag in Tag.query.order_by(Tag.value).all()]
    return render_template(
        "term/display_term_set.jinja",
        term_set=term_set,
        form=EmptyForm(),
        tag_form=tag_form,
    )


@term.route("/set/edit/<int:term_set_id>", methods=["GET", "POST"])
@login_required
def edit_term_set(term_set_id):
    term_set = TermSet.query.get_or_404(term_set_id)
    form = EditTermSetForm(obj=term_set)
    tag_form = AddTagForm()

    if form.validate_on_submit():
        form.populate_obj(term_set)
        db.session.commit()
        flash("Term set updated.")
        return redirect(url_for("term.display_term_set", term_set_id=term_set_id))

    return render_template("term/edit_term_set.jinja", form=form, term_set=term_set, tag_form=tag_form)


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
    return redirect(url_for("term.list_term_sets"))


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
    return redirect(url_for("term.display_term_set", term_set_id=term_set_id))


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
    return redirect(url_for("term.display_term_set", term_set_id=term_set_id))
