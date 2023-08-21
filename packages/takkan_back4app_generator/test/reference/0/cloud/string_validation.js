var val = require('validator');

function lengthGreaterThan(request, field, threshold) {
    let value = stringValue(request, field);
    if (value.length > threshold) return;
    throw 'validation';
}

function lengthGreaterThanOrEqualTo(request, field, threshold) {
    let value = stringValue(request, field);
    if (value.length >= threshold) return;
    throw 'validation';
}

function lengthLessThan(request, field, threshold) {
    let value = stringValue(request, field);
    if (value.length < threshold) return;
    throw 'validation';
}

function lengthLessThanOrEqualTo(request, field, threshold) {
    let value = stringValue(request, field);
    if (value.length <= threshold) return;
    throw 'validation';
}

function lengthEqualTo(request, field, threshold) {
    let value = stringValue(request, field);
    if (value.length === threshold) return;
    throw 'validation';
}

function stringValue(request, field) {

  if (!field) {
    throw new Error('Field is required');
  }

  let value = request.object.get(field);

  if (value === undefined) {
    // Check original if updated is undefined
    if (request.original) {
      value = request.original.get(field);
    }

    if (value === undefined) {
      throw new Error('Field ' + field + ' not in object or original');
    }
  }

  return value;

}


module.exports = {
    longerThan,
    shorterThan
};