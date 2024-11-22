document.addEventListener('DOMContentLoaded', function () {
    console.log(typeof marked); // Verify that marked is loaded

    const subjectField = document.getElementById('subjectId');
    const predicateField = document.getElementById('predicateId');
    const objectField = document.getElementById('objectId');

    subjectField.addEventListener('input', () => fetchTermData(subjectField, 'subject'));
    predicateField.addEventListener('input', () => fetchTermData(predicateField, 'predicate'));
    objectField.addEventListener('input', () => fetchTermData(objectField, 'object'));
});

function fetchTermData(field, fieldName) {
    const conceptID = field.value;
    if (conceptID.length > 4) {
        fetch(`/term/api/${conceptID}`)
            .then(response => response.json())
            .then(data => {
                if (data.term_string && data.definition) {
                    const termStringElement = document.getElementById(`${fieldName}_term_string`);
                    termStringElement.innerHTML = `<a href="/term/ark/${conceptID}">${data.term_string}</a>`;
                    document.getElementById(`${fieldName}_definition`).innerHTML = marked(data.definition);
                } else {
                    document.getElementById(`${fieldName}_term_string`).innerHTML = '';
                    document.getElementById(`${fieldName}_definition`).innerHTML = '';
                }
            })
            .catch(error => console.error('Error fetching term data:', error));
    } else {
        document.getElementById(`${fieldName}_term_string`).innerHTML = '';
        document.getElementById(`${fieldName}_definition`).innerHTML = '';
    }
}