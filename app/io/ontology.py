import os
from owlready2 import get_ontology

from app.term.models import TermSet, Term, Relationship


class OwlHandler:
    def __init__(self, ontology_location):
        self.ontology_location = ontology_location
        self.onto = get_ontology(self.ontology_location).load()
        self.skos = self.onto.get_namespace(
            "http://www.w3.org/2004/02/skos/core#")

    def get_ontology_terms(self):
        terms = []
        for onto_class in self.onto.classes():
            term_string = onto_class.name
            definition = self.skos.definition[onto_class]
            if definition:
                definition = str(definition)
                definition = definition[2:] if definition.startswith(
                    "['") else definition
                definition = definition[:-
                                        2] if definition.endswith("']") else definition
            examples = self.skos.example[onto_class]
            example_list = "; ".join(examples) if examples else ""
            terms.append({
                "term": term_string,
                "definition": definition,
                "examples": example_list
            })
        return terms


class OntologyClassifier:
    def __init__(self, term_set: TermSet):
        self.term_set = term_set
        self.source_file = self.get_source_file()
        self.terms = self.get_terms()

    def get_source_file(self):
        if self.term_set.source:
            import_dir = os.path.join(os.path.dirname(__file__), 'import')
            source_file_path = os.path.join(import_dir, self.term_set.source)
            if os.path.exists(source_file_path):
                return source_file_path
        return None

    def get_terms(self):
        return Term.query.filter(Term.termsets.contains(self.term_set)).all()

    def refine_ontology(self):
        if self.source_file:
            handler = OwlHandler(self.source_file)
            ontology_terms = handler.get_ontology_terms()
            for term in self.terms:
                for ontology_term in ontology_terms:
                    if term.term_string == ontology_term['term']:
                        term.definition = ontology_term['definition']
                        term.examples = ontology_term['examples']
                        term.save()
            self.create_relationships(handler)

    def create_relationships(self, handler):
        for onto_class in handler.onto.classes():
            term_string = onto_class.name
            parent_classes = onto_class.is_a
            for parent_class in parent_classes:
                if parent_class.name != term_string:
                    child_term = self.find_term_by_string(term_string)
                    parent_term = self.find_term_by_string(parent_class.name)
                    if child_term and parent_term:
                        self.create_relationship(parent_term, child_term)

    def find_term_by_string(self, term_string):
        return Term.query.filter_by(term_string=term_string).first()

    def create_relationship(self, parent_term, child_term):
        relationship = Relationship(
            parent_id=parent_term.id,
            child_id=child_term.id,
            predicate_id=self.get_subclass_predicate_id(),
        )
        relationship.save()

    def get_subclass_predicate_id(self):
        subclass_predicate = Term.query.filter_by(
            term_string='rdfs:subClassOf').first()
        return subclass_predicate.id if subclass_predicate else None
