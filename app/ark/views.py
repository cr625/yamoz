from flask import redirect, url_for, render_template

from app.ark import ark_blueprint as ark


@ark.route("/")
@ark.route(":/99152/<concept_id>")
@ark.route("/99152/<concept_id>")
@ark.route("/<concept_id>")
def index(concept_id=None):
    if concept_id is None:
        return render_template("ark/index.jinja")
    return redirect(url_for("term.display_term", concept_id=concept_id))


@ark.route("/13183/<concept_id>")
def show_relations():
    pass
