var validateInteger = require('./integerValidation.js');
var validateString = require('./stringValidation.js');

Parse.Cloud.beforeSave("Issue", (request) => {
    const requestedSchemaVersion = parseInt(request.params.schema_version);
    switch (requestedSchemaVersion) {
        case 0: {
            validateInteger.lessThan(request, 'weight', 100);
            validateInteger.greaterThan(request, 'weight', 23);
            validateString.longerThan(request, 'title', 3);
            validateString.shorterThan(request, 'title', 13);
            return  'deprecated use 1';
        }
        case 1: {
            validateInteger.lessThan(request, 'weight', 100);
            validateInteger.greaterThan(request, 'weight', 23);
            validateString.longerThan(request, 'title', 3);
            validateString.shorterThan(request, 'title', 13);
            return  '1';
        }
        default:{
            throw 'invalid use 1';
        }
    }
});

