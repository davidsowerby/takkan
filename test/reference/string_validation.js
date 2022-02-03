var val = require('validator');

function longerThan(request, field, threshold) {
    let value = stringValue(request, field);
    if (value.length > threshold) return;
    throw 'validation';
}

function shorterThan(request, field, threshold) {
    let value = stringValue(request, field);
    if (value.length < threshold) return;
    throw 'validation';
}

function stringValue(request, field) {
    return request.object.get(field);
}

module.exports = {
    longerThan,
    shorterThan
}