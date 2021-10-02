var intVal=require ('./integerValidation.js');

Parse.Cloud.beforeSave("Issue", (request) => {
  intVal.isLessThan(request,'weight',100);
  intVal.isGreaterThan(request, 'weight',23);
})
