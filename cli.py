import click
from flask_sqlalchemy import SQLAlchemy

from app import create_app
from app.admin.user import *
from app.admin.term import *

app = create_app()
app.app_context().push()

# db = SQLAlchemy(app)


@click.group()
def cli():
    pass


@click.command()
@click.argument("email")
def setsuperuser(email):
    set_superuser(email)


cli.add_command(setsuperuser)


if __name__ == "__main__":
    cli()
