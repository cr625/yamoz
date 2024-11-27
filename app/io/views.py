from flask import flash, redirect, render_template, request, send_file, url_for
from flask_login import current_user, login_required

from app import db
from app.io import io_blueprint as io
from app.io.data import *
from app.io.forms import DataFileUploadForm, EmptyForm
from app.term.models import Ark, Tag, TermSet


@io.route("/upload", methods=["GET", "POST"])
@login_required
def import_document():
    form = DataFileUploadForm()
    # form.tag_list.choices = [(t.id, t.value)
    #                         for t in Tag.query.order_by(Tag.value)]

    if form.validate_on_submit():
        imported_terms = None
        uploaded_file = form.data_file.data
        set_name = form.name.data
        set_description = form.description.data
        owner_id = current_user.id

        new_tag = None
        if form.new_tag.data:
            new_tag = Tag.query.filter_by(
                category="set", value=form.new_tag.data).first()
            if not new_tag:
                new_tag = Tag(value=form.new_tag.data, category="set")
                db.session.add(new_tag)
                db.session.commit()
                db.session.refresh(new_tag)

        if uploaded_file.filename.endswith(".json"):
            imported_terms = process_json_upload(uploaded_file)
        elif uploaded_file.filename.endswith(".csv"):
            imported_terms = process_csv_upload(uploaded_file)
        elif uploaded_file.filename.endswith(".owl"):
            imported_terms = process_owl_upload(uploaded_file)
        else:
            flash("File type not supported", "danger")
            return redirect(url_for('io.import_document'))

        if imported_terms:
            term_set = TermSet(
                source=uploaded_file.filename,
                description=set_description,
                user_id=owner_id,
                name=set_name,
                ark_id=Ark().create_ark(shoulder="g1", naan="13183").id
            )
            term_set.save()
            db.session.refresh(term_set)

            imported_termset = import_term_dict(
                imported_terms, term_set, new_tag)

        return render_template("io/display_import.jinja", selected_terms=imported_termset.terms)

    else:
        # Debugging: Print form errors
        for field, errors in form.errors.items():
            for error in errors:
                flash(
                    f"Error in the {getattr(form, field).label.text} field - {error}", "danger")

    return render_template("io/import_document.jinja", form=form)


@io.route("/export", methods=["GET", "POST"])
def export_page():
    return render_template("io/export.jinja")


@io.route("/export/terms", methods=["GET", "POST"])
def export_term_results():
    search_terms = request.args.get("search_terms")
    response = export_term_dict(search_terms)
    return response

###
# json test routes


def process_json_upload(data_file):
    json_dataframe = pandas.read_json(data_file)
    return json_dataframe["Terms"]


@io.route("/upload/display", methods=["GET", "POST"])
def display_import():
    dir = os.getcwd()
    data_file = os.path.join(dir, 'uploads', 'data',
                             'ESA Space Weather Glossary.json')
    term_data = process_json_upload(data_file)
    return render_template("io/display_import.jinja", selected_terms=term_data)


@io.route("/upload/helio", methods=["GET", "POST"])
@login_required
def import_helio_document():
    form = DataFileUploadForm()
    form.tag_list.choices = [t.value for t in Tag.query.order_by(Tag.value)]
    if form.validate_on_submit():
        uploaded_file = form.data_file.data
        set_name = form.name.data
        set_description = form.description.data
        owner_id = current_user.id
        tag = Tag.query.filter_by(value=form.tag_list.data).first()
        new_set = TermSet(
            user_id=owner_id,
            source="upload",
            name=set_name,
            description=set_description,
        )
        new_set.save()
        db.session.refresh(new_set)
        if (uploaded_file.filename.endswith(".json")):
            term_dict = process_json_upload(uploaded_file)
        else:
            term_dict = process_csv_upload(uploaded_file)
        term_set = import_helio_term_dict(term_dict, new_set, tag)
        term_list = term_set.terms
        return render_template(
            "io/import_results.jinja",
            selected_terms=term_list,
            title=set_name,
            description=set_description,
            form=EmptyForm(),
        )
    return render_template("io/import_helio_document.jinja", form=form)
