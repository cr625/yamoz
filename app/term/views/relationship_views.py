from app.term import term_blueprint as term


@term.route("/relationship", methods=["GET", "POST"])
def relationship():
    return "relationship"
