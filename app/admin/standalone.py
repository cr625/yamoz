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
