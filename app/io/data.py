import json
import os
from urllib import request
from app.io.ontology import OwlHandler
import pandas
from app import db
from app.term.helpers import get_ark_id
from app.term.models import Term, TermSet
from app.user.models import User
from flask import Response, current_app, make_response, request
from flask_login import current_user
from werkzeug.utils import secure_filename

base_dir = os.path.abspath(os.path.dirname(__file__))


def save_data_file(data_file):
    import_dir = os.path.join(base_dir, "import")
    if not os.path.exists(import_dir):
        os.makedirs(import_dir)
    filename = secure_filename(data_file.filename)
    file_path = os.path.join(import_dir, filename)
    data_file.save(file_path)
    return file_path, filename


def process_csv_upload(data_file):
    file_path, file_name = save_data_file(data_file)
    csv_dataframe = pandas.read_csv(file_path)
    return csv_dataframe.to_dict(orient="records"), file_name


def process_json_upload(data_file):
    file_path, file_name = save_data_file(data_file)
    json_dataframe = pandas.read_json(file_path)
    return json_dataframe["Terms"], file_name


def process_owl_upload(data_file):
    file_path, file_name = save_data_file(data_file)
    handler = OwlHandler(file_path)
    terms = handler.get_ontology_terms()
    return terms, file_name


def import_term_dict(term_dict, term_set, new_tag):
    for term in term_dict:
        term_string = term["term"]
        definition = term["definition"]
        examples = term["examples"]

        ark_id = get_ark_id()
        shoulder = current_app.config["SHOULDER"]
        naan = current_app.config["NAAN"]
        ark = shoulder + str(ark_id)
        owner_id = current_user.id

        new_term = Term(
            ark_id=ark_id,
            shoulder=shoulder,
            naan=naan,
            owner_id=owner_id,
            term_string=term_string,
            definition=definition,
            examples=examples,
            concept_id=ark,
        )
        db.session.add(new_term)
        db.session.commit()
        db.session.refresh(new_term)
        if new_tag:
            new_term.tags.append(new_tag)
        term_set.terms.append(new_term)
    term_set.save()
    return term_set


def import_helio_term_dict(term_dict, term_set, tag):
    for term in term_dict:
        term_string = term["Term"]
        definition = term["Definition"]

        ark_id = get_ark_id()
        shoulder = current_app.config["SHOULDER"]
        naan = current_app.config["NAAN"]
        ark = shoulder + str(ark_id)
        owner_id = current_user.id

        new_term = Term(
            ark_id=ark_id,
            shoulder=shoulder,
            naan=naan,
            owner_id=owner_id,
            term_string=term_string,
            definition=definition,
            concept_id=ark,
        )
        db.session.add(new_term)
        new_term.tags.append(tag)  # might have to do after refresh
        db.session.commit()
        db.session.refresh(new_term)

        term_set.terms.append(new_term)
        term_set.save()
    return term_set


def export_term_dict(search_terms=None) -> Response:
    if (search_terms is None):
        term_list = (
            db.session.query(Term)
            .with_entities(
                Term.id,
                Term.term_string,
                Term.definition,
                Term.examples,
                Term.ark_id,
                Term.owner_id,
            )
            .all()
        )
    else:
        term_list = (
            db.session.query(Term)
            .with_entities(
                Term.id,
                Term.term_string,
                Term.definition,
                Term.examples,
                Term.ark_id,
                Term.owner_id,
            )
            .filter(Term.search_vector.match(search_terms))
            .all()
        )
    df_export_terms = pandas.DataFrame.from_records(
        term_list,
        columns=["id", "term_string", "definition",
                 "examples", "ark_id", "owner_id"],
    )
    csv_list = df_export_terms.to_csv(index=False, header=True)
    output = make_response(csv_list)
    output.headers["Content-Disposition"] = "attachment; filename=terms.csv"
    output.headers["Content-Type"] = "text/csv"
    return output


def export_terms():
    file_path = os.path.join(base_dir, "export/terms.json")
    with open(file_path, "w") as write_file:
        terms = Term.query.all()
        export_terms = []
        for term in terms:
            owner_id = term.owner_id
            owner = User.query.filter_by(id=owner_id).first()
            export_terms.append(
                {
                    # "id": term.id,
                    "concept_id": term.concept_id,
                    "owner_id": owner_id,
                    "owner": owner,
                    "created": term.created,
                    "modified": term.modified,
                    "term_string": term.term_string,
                    "definition": term.definition,
                    "examples": term.examples,
                    # "tsv": term.tsv,
                }
            )
        json.dump(export_terms, write_file, indent=4,
                  sort_keys=True, default=str)
