function greaterThan(request, field, param){
  let value=integerValue(request,field);
  if (value > param) return;
  throw 'validation';
}

function lessThan(request, field, param){
  let value=integerValue(request,field);
  if (value < param) return;
  throw 'validation';
}

function integerValue(request, field){
  return parseInt(request.object.get(field));
}

module.exports = {
  greaterThan,
  lessThan
}

