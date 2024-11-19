from app.term import term_blueprint as term
from app.term.forms import AddPropertyForm
from flask import render_template, redirect, url_for, flash, request

@term.route("/property", methods=["GET", "POST"])
def index():
    return "property"


@term.route("/property/add/", methods=["GET", "POST"])
def add_property():
    property_form = AddPropertyForm()
    if property_form.validate_on_submit():
        flash("Property added")
        return redirect(url_for("term.index"))
    return render_template("property/create_property.jinja", form=property_form)
