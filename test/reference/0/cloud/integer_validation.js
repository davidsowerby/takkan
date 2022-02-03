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
    return parseInt(request.object.get(field));
}

module.exports = {
    greaterThan,
    lessThan
};

