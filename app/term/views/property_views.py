from app.term import term_blueprint as term

from flask import render_template, redirect, url_for, flash, request

@term.route("/property", methods=["GET", "POST"])
def index():
    return "property"


@term.route("/property/create/", methods=["GET", "POST"])
def create_property():
    return render_template("property/create_property.jinja")
