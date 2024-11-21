from flask import jsonify
from app.term import term_blueprint as term
from app.term.models import Term


@term.route("/api/<concept_id>")
def get_term_by_concept_id(concept_id):
    term = Term.query.filter_by(concept_id=concept_id).first()
    if term:
        return jsonify({
            "term_string": term.term_string,
            "definition": term.definition
        })
    return jsonify({"error": "Term not found"}), 404
