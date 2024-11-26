from owlready2 import get_ontology


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


# Example usage:
handler = OwlHandler("app/io/import/bfo.owl")
terms = handler.get_ontology_terms()
for term in terms:
    print(term)
