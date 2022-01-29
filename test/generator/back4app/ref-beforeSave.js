var validateInteger = require('./integerValidation.js');
var validateString = require('./stringValidation.js');

Parse.Cloud.beforeSave("Issue", (request) => {
  validateInteger.lessThan(request,'weight',100);
  validateInteger.greaterThan(request,'weight',23);
  validateString.longerThan(request,'title',3);
  validateString.shorterThan(request,'title',13);
})

