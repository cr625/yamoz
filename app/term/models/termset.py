
from app import db


class TermSet(db.Model):
    __tablename__ = "termsets"
    id = db.Column(db.Integer, primary_key=True)
    ark_id = db.Column(db.Integer, db.ForeignKey(
        "arks.id"), nullable=True, unique=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=True)
    source = db.Column(db.Text)
    name = db.Column(db.Text)
    description = db.Column(db.Text)
    created = db.Column(db.DateTime, default=db.func.now())
    updated = db.Column(db.DateTime, default=db.func.now(),
                        onupdate=db.func.now())

    terms = db.relationship(
        "Term",
        secondary="term_sets",
        back_populates="termsets",
        order_by="Term.term_string",
        single_parent=True,
        cascade="all, delete-orphan",
    )

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()
