function greaterThan(request, field, threshold) {
    let value = integerValue(request, field);
    if (value > threshold) return;
    throw 'validation';
}

function lessThan(request, field, threshold) {
    let value = integerValue(request, field);
    if (value < threshold) return;
    throw 'validation';
}

function integerValue(request, field) {

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

  return parseInt(value);

}

module.exports = {
    greaterThan,
    lessThan
};

