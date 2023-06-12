var val = require('validator');

function alpha(request, field, param){
  let value=stringValue(request,field);
  if (val.isAlpha(param)) return;
  throw 'validation';
}

function contains(request, field, param){
  let value=stringValue(request,field);
  if (val.contains(param)) return;
  throw 'validation';
}

function lengthEquals(request, field, param){
  let value=stringValue(request,field);
  if (value.length === param) return;
  throw 'validation';
}

function lengthGreaterThan(request, field, param){
  let value=stringValue(request,field);
  if (value.length > param) return;
  throw 'validation';
}

function lengthLessThan(request, field, param){
  let value=stringValue(request,field);
  if (value.length < param) return;
  throw 'validation';
}

function stringValue(request, field){
  return request.object.get(field);
}

module.exports = {
  alpha,
  contains,
  lengthEquals,
  lengthGreaterThan,
  lengthLessThan
}