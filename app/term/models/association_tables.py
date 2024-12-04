from app import db

termset_relationships = db.Table(
    "termset_relationships",
    db.Column("relationship_id", db.Integer,
              db.ForeignKey("relationships.id")),
    db.Column("termset_id", db.Integer, db.ForeignKey("termsets.id")),

)
