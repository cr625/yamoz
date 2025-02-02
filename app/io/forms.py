from flask_wtf import FlaskForm
from flask_wtf.file import FileAllowed, FileField, FileRequired
from wtforms import StringField, SubmitField, TextAreaField, SelectField
from wtforms.validators import DataRequired, Length


class DataFileUploadForm(FlaskForm):
    name = StringField("Name Import", validators=[DataRequired()])
    description = TextAreaField("Describe Import")
    data_file = FileField(
        "data_file",
        validators=[FileRequired(), FileAllowed(
            ["csv", "json", "owl"], "CSV, JSON or OWL are supported.")]
    )

    # tag_list = SelectField("Tag", choices=[], default="set")
    new_tag = StringField("Set Tag")

    submit = SubmitField("Upload")


class EmptyForm(FlaskForm):
    submit = SubmitField("Submit")
