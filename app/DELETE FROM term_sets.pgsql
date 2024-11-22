DELETE FROM term_sets
USING terms
WHERE term_sets.term_id = terms.id
AND terms.definition = '';
