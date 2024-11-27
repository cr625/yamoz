from rdflib import URIRef
from sqlalchemy.ext.hybrid import hybrid_property

from app import db


class Relationship(db.Model):
    __tablename__ = "relationships"
    id = db.Column(db.Integer, primary_key=True)
    ark_id = db.Column(db.Integer, db.ForeignKey("arks.id"), nullable=True)
    owner_id = db.Column(db.Integer, db.ForeignKey("users.id"))
    created = db.Column(db.DateTime, default=db.func.now())
    modified = db.Column(db.DateTime, default=db.func.now(),
                         onupdate=db.func.now())
    parent_id = db.Column(
        db.Integer, db.ForeignKey("terms.id"), nullable=False)
    child_id = db.Column(db.Integer, db.ForeignKey("terms.id"), nullable=False)
    predicate_id = db.Column(
        db.Integer, db.ForeignKey("terms.id"), nullable=False)
    namespace = db.Column(db.String(128), nullable=True)
    timestamp = db.Column(db.DateTime, default=db.func.now())

    # Establish relationships
    predicate = db.relationship(
        "Term", foreign_keys=[predicate_id], backref="relationships_as_predicate")

    ark = db.relationship("Ark", foreign_keys=[
                          ark_id], backref="relationships")

    @hybrid_property
    def ark_concept_id(self):
        if self.ark:
            return self.ark.concept_id
        return None

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    def get_predicate_uri(self):
        if self.namespace:
            return URIRef(f"{self.namespace}{self.predicate.term_string}")
        return URIRef(self.predicate.term_string)

    def __repr__(self):
        return f"<Relationship {self.parent_id} {self.predicate.term_string} {self.child_id}>"
