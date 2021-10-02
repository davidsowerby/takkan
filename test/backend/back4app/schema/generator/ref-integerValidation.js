function isGreaterThan(request, field, param){
  let value=integerValue(request,field);
  if (value > param) return;
  throw 'validation';
}

function isLessThan(request, field, param){
  let value=integerValue(request,field);
  if (value < param) return;
  throw 'validation';
}

function integerValue(request, field){
  return parseInt(request.object.get(field));
}

module.exports = {
  isGreaterThan,
  isLessThan
}

