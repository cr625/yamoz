from owlready2 import *
from rdflib import Graph
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

Base = declarative_base()
engine = create_engine('postgresql://postgres:PASS@localhost/yamz-o')
Base.metadata.create_all(engine)
Session = sessionmaker(bind=engine)
session = Session()


class User(Base):
    __tablename__ = 'users'
    __table_args__ = {'autoload': True, 'autoload_with': engine}


class Term(Base):
    __tablename__ = 'terms'
    __table_args__ = {'autoload': True, 'autoload_with': engine}


def get_user_by_email(email):
    return session.query(User).filter_by(email=email).first()


def list_all_classes(ontology):
    return [cls.name for cls in ontology.classes()]


onto = get_ontology("app/io/import/bfo.owl").load()


def get_class_by_name(class_name):
    return onto.search(iri="*{}".format(class_name))[0]


entity_class = onto.search(iri="*Entity")[0]

# Find the class that is a subclass of owl:Thing


def find_class_is_a_thing(ontology):
    for cls in ontology.classes():
        if Thing in cls.is_a:
            return cls
    return None


# Get the class that is a subclass of owl:Thing
class_is_a_thing = find_class_is_a_thing(onto)

if class_is_a_thing:
    print(
        f"The class that is a subclass of owl:Thing is: {class_is_a_thing.name}")
else:
    print("No class found that is a subclass of owl:Thing.")
