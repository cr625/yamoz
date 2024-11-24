from owlready2 import *
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


def list_main_classes(ontology):
    return [cls.name for cls in ontology.classes() if not cls.is_a]


def list_immediate_subclasses(ontology, class_name):
    cls = ontology[class_name]
#    return [subcls.name for subcls in cls.subclasses()]


onto = get_ontology("app/io/import/bfo.owl").load()

if __name__ == "__main__":
    user = get_user_by_email("christopher.b.rauch@gmail.com")
    print("user", user.auth_id)
    print(onto.base_iri)
    # classes = list_all_classes(onto)
    # print("Classes in the ontology:", classes)
    # main_classes = list_main_classes(onto)
    # print("Main classes in the ontology:", main_classes)
    # immediate_subclasses = list_immediate_subclasses(onto, "Entity")
    # print("Immediate subclasses of Entity:", immediate_subclasses)
