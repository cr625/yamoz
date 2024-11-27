import enum
import re

import bleach
from blinker import Namespace
from markdown import markdown
from sqlalchemy import Index, case, select
from sqlalchemy.dialects.postgresql import TSVECTOR
from sqlalchemy.ext.hybrid import hybrid_property

from app import db
from app.user.models import User
from config import Config

from .relationship import Relationship

SHOULDER = Config.SHOULDER
NAAN = Config.NAAN


allowed_tags = [
    "a",
    "abbr",
    "acronym",
    "b",
    "blockquote",
    "code",
    "em",
    "i",
    "li",
    "ol",
    "pre",
    "strong",
    "ul",
    "h1",
    "h2",
    "h3",
    "p",
]


def normalize_tag(reference):
    return re.sub("[^\w]+", "-", reference).lower()


class term_class(enum.Enum):
    vernacular = (1, "vernacular")
    canonical = (2, "canonical")
    deprecated = (3, "deprecated")


class status(enum.Enum):
    archived = (1, "archived")
    published = (2, "published")
    draft = (3, "draft")
    deleted = (4, "deleted")


class Term(db.Model):
    __tablename__ = "terms"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    ark_id = db.Column(db.Integer, unique=True, autoincrement=True)
    shoulder = db.Column(db.String(64), default=SHOULDER)
    naan = db.Column(db.String(64), default=NAAN)
    owner_id = db.Column(db.Integer, db.ForeignKey("users.id"))
    created = db.Column(db.DateTime, default=db.func.now())
    modified = db.Column(db.DateTime, default=db.func.now(),
                         onupdate=db.func.now())
    term_string = db.Column(db.Text)
    definition = db.Column(db.Text)
    definition_html = db.Column(db.Text)
    examples = db.Column(db.Text)
    examples_html = db.Column(db.Text)
    concept_id = db.Column(db.String(64))
    status = db.Column("status", db.Enum(status), default=status.published)
    term_class = db.Column("class", db.Enum(term_class),
                           default=term_class.vernacular)

    search_vector = db.Column(TSVECTOR)

    __table_args__ = (
        Index("ix_term_search_vector", search_vector, postgresql_using="gin"),
    )

    # relationships

    termsets = db.relationship(
        "TermSet", secondary="term_sets", back_populates="terms", cascade="all")

    contributor = db.relationship("User", back_populates="terms")

    tags = db.relationship("Tag", secondary="term_tags",
                           back_populates="terms")

    tracks = db.relationship(
        "Track",
        back_populates="term",
        cascade="all, delete-orphan",
    )
    votes = db.relationship(
        "Vote", backref="term", lazy="dynamic", cascade="all, delete-orphan"
    )

    comments = db.relationship("Comment", backref="term", lazy="dynamic")

    # Relationships
    children = db.relationship(
        "Relationship",
        foreign_keys=[Relationship.parent_id],
        backref=db.backref("parent", lazy="joined"),
        lazy="dynamic",
    )
    parents = db.relationship(
        "Relationship",
        foreign_keys=[Relationship.child_id],
        backref=db.backref("child", lazy="joined"),
        lazy="dynamic",
        cascade="all, delete-orphan",
    )

    def add_child_relationship(self, child, predicate):
        child = Relationship(
            parent_id=self.id, child_id=child.id, predicate=predicate)
        child.save()

    @property
    def persistent_id(self):
        return ("https://n2t.net/ark:/{}/{}{}").format(
            self.naan,
            self.shoulder,
            self.ark_id,
        )

    @hybrid_property
    def term_vote(self):
        # return sum(self.votes.vote)
        vote_sum = 0
        for user_vote in self.votes:
            vote_sum += user_vote.vote
        return vote_sum

    @term_vote.expression
    def term_vote(cls):
        return case(
            [
                (
                    select([db.func.sum(Vote.vote)]).where(
                        Vote.term_id == cls.id)
                    != None,
                    select([db.func.sum(Vote.vote)]).where(
                        Vote.term_id == cls.id),
                ),
            ],
            else_=0,
        )

    @property
    def display_score_sum(self):
        stm = select([db.func.sum(Vote.vote)]).where(Vote.term_id == self.id)
        result = db.session.execute(stm).scalar()
        return result

    @hybrid_property
    def score_sum_sql(self):
        stm = select([db.func.sum(Vote.vote)]).where(Vote.term_id == self.id)
        # result = db.session.execute(stm).scalar()
        return stm

    @property
    def vote_total(self):
        # return sum(self.votes.vote)
        vote_sum = 0
        for user_vote in self.votes:
            vote_sum += user_vote.vote
        return vote_sum

    def vote_count(self):
        return self.votes.count()

    @property
    def score(self):
        return self.vote_total  # add weight

    @property
    def votes_up_sum(self):
        votes_up_sum = self.votes.filter_by(vote=1).count()
        return votes_up_sum

    @property
    def votes_down_sum(self):
        # votes_down_sum = self.votes.filter(Vote.vote < 0).count()
        votes_down_sum = self.votes.filter_by(vote=-1).count()
        return -abs(votes_down_sum)

    @property
    def votes_up_count(self):
        return self.votes.filter_by(vote=1).count()

    @property
    def votes_down_count(self):
        return self.votes.filter_by(vote=-1).count()

    @property
    def consensus(self):
        """Calcluate consensus score. This is a heuristic for the percentage
        of the community who finds a term useful. Based on the observation
        that not every user will vote on a given term, user reptuation is
        used to estimate consensus. As the number of voters approaches
        the number of users, the votes become more equitable. (See
        doc/Scoring.pdf for details.

        :param u: Number of up voters.
        :param d: Number of down voters.
        :param t: Number of total users.
        :param U_sum: Sum of up-voter reputation.
        :param D_sum: Sum of down-voter reputation.

        v = u + d
        R = U_sum + D_sum
        return (u + (float(U_sum) / R if R > 0 else 0.0) * (t - v)) / t if v else 0

        """
        u = self.votes_up_count
        d = self.votes_down_count
        t = User.query.count()
        U_sum = self.votes_up_sum
        D_sum = self.votes_down_sum

        v = u + d
        R = U_sum + D_sum
        return (u + (float(U_sum) / R if R > 0 else 0.0) * (t - v)) / t if v else 0

    def get_user_vote(self, current_user):
        user_vote = self.votes.filter_by(user_id=current_user.id).first()
        return user_vote.vote if user_vote else 0

    @property
    def alt_definitions_count(self):
        return (
            db.session.query(db.func.count(Term.id))
            .filter_by(term_string=self.term_string)
            .filter(Term.id != self.id)
            .scalar()
        )

    def is_tracked_by(self, current_user):
        if self.tracks is None:
            return False
        else:
            return current_user.id in [track.user.id for track in self.tracks]

        # return user.id in [track.user.id for track in self.tracks]

    def track(self, current_user):
        if self.is_tracked_by(current_user):
            return False
        else:
            track = Track(user_id=current_user.id, term_id=self.id)
            track.save()
            term_tracked.send(self)

    def untrack(self, current_user):
        if self.is_tracked_by(current_user):
            untrack = Track.query.filter_by(
                user_id=current_user.id, term_id=self.id
            ).first()
            untrack.delete()

    def up_vote(self, current_user):
        vote = self.votes.filter_by(user_id=current_user.id).first()
        if vote is None:
            vote = Vote(user_id=current_user.id, term_id=self.id, vote=1)
        elif vote.vote == 1:
            return False
        else:
            vote.vote = 1
        vote.save()

    def down_vote(self, current_user):
        vote = self.votes.filter_by(user_id=current_user.id).first()
        if vote is None:
            vote = Vote(user_id=current_user.id, term_id=self.id, vote=-1)
        elif vote.vote == -1:
            return False
        else:
            vote.vote = -1
        vote.save()

    def zero_vote(self, current_user):
        vote = self.votes.filter_by(user_id=current_user.id).first()
        if vote is None:
            vote = Vote(user_id=current_user.id, term_id=self.id, vote=0)
        else:
            vote.vote = 0
        vote.save()

    def remove_vote(self, current_user):
        vote_to_remove = self.votes.filter_by(user_id=current_user.id).first()
        if not vote_to_remove is None:
            db.session.delete(vote_to_remove)
            db.session.commit()

    def update(self):
        self.save()
        term_updated.send(self)

    def save(self):
        tags = "" if self.tags is None else " ".join(
            [tag.value for tag in self.tags])
        definition = "" if self.definition is None else self.definition
        examples = "" if self.examples is None else self.examples

        string = definition + " " + examples + " " + tags
        self.search_vector = db.func.to_tsvector("english", string.strip())
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()
        term_deleted.send(self)

    def __repr__(self):
        return "<Term {} |{}>".format(self.term_string, self.concept_id)

    """
    @staticmethod
    def on_changed_definition(target, value, oldvalue, initiator):
        target.definition_html = bleach.linkify(
            bleach.clean(
                markdown(value, output_format="html"), tags=allowed_tags, strip=True
            )
        )

    @staticmethod
    def on_changed_examples(target, value, oldvalue, initiator):
        target.examples_html = bleach.linkify(
            bleach.clean(
                markdown(value, output_format="html"), tags=allowed_tags, strip=True
            )
        )
    """


class Comment(db.Model):
    __tablename__ = "comments"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    owner_id = db.Column(db.Integer, db.ForeignKey("users.id"))
    term_id = db.Column(db.Integer, db.ForeignKey("terms.id"))
    created = db.Column(db.DateTime, default=db.func.now())
    modified = db.Column(db.DateTime, default=db.func.now(),
                         onupdate=db.func.now())
    comment_string = db.Column(db.Text)
    comment_string_html = db.Column(db.Text)

    author = db.relationship("User", backref="author", lazy="joined")

    @staticmethod
    def on_changed_definition(target, value, oldvalue, initiator):
        target.comment_string_html = bleach.linkify(
            bleach.clean(
                markdown(value, output_format="html"), tags=allowed_tags, strip=True
            )
        )

    def save(self):
        db.session.add(self)
        db.session.commit()


class Vote(db.Model):
    __tablename__ = "votes"
    user_id = db.Column(db.Integer, db.ForeignKey(
        "users.id"), primary_key=True)
    term_id = db.Column(db.Integer, db.ForeignKey(
        "terms.id"), primary_key=True)
    vote = db.Column(db.Integer, default=0, nullable=False)

    def save(self):
        db.session.add(self)
        db.session.commit()


"""
Association Tables
"""
tag_table = db.Table(
    "term_tags",
    db.Model.metadata,
    db.Column("tag_id", db.Integer, db.ForeignKey("tags.id")),
    db.Column("term_id", db.Integer, db.ForeignKey("terms.id")),
)

set_table = db.Table(
    "term_sets",
    db.Model.metadata,
    db.Column("set_id", db.Integer, db.ForeignKey("termsets.id")),
    db.Column("term_id", db.Integer, db.ForeignKey("terms.id")),
)


'''
This attaches signals to the Term model. Signals are used to trigger
notifications and actions in response to changes in the database.
'''
term_signals = Namespace()

term_saved = term_signals.signal("term_saved")
term_deleted = term_signals.signal("term_deleted")
term_updated = term_signals.signal("term_updated")
term_commented = term_signals.signal("term_commented")
term_tracked = term_signals.signal("term_tracked")
term_voted = term_signals.signal("term_voted")

"""
DB Event Listeners
"""
# db.event.listen(Term.definition, "set", Term.on_changed_definition)
# db.event.listen(Term.examples, "set", Term.on_changed_examples)
