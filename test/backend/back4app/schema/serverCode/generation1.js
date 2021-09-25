Parse.Cloud.beforeSave("Issue", (request) => {
// do any additional beforeSave logic here
},{
  fields: {
    weight : {
      options: [
        weight => {return weight > 0;},
        weight => {return weight < 10;}
      ],
      error: 'validation'
    }
  }
});
