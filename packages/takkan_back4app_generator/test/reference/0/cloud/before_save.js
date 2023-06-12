var validateInteger = require('./integer_validation.js');

Parse.Cloud.beforeSave("Person", (request) => {
    const requestedSchemaVersion = parseInt(request.params.schema_version);
    switch (requestedSchemaVersion) {
        case 0: {
            validateInteger.lessThan(request, 'age', 100);
            validateInteger.greaterThan(request, 'age', 0);
            return 'success';
        }
        default: {
            throw 'invalid use 0';
        }
    }
});

