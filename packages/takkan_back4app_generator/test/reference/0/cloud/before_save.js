const b4a = require('../../b4a_schema.js');
const validateInteger = require('./integer_validation.js');

// Default schema_version is provided, otherwise data cannot be updated from the Back4App Dashboard
// To validate what might be a partial update, we check original if present
Parse.Cloud.beforeSave('Person', (request) => {
  if (!request.params.schema_version) {
    throw 'schema_version is required';
  }

  const requestedSchemaVersion = parseInt(request.params.schema_version);

  try {
    switch (requestedSchemaVersion) {
      case 0: {
        validateInteger.greaterThan("age", 0);
        validateInteger.lessThan("age", 100);
        validateInteger.greaterThan("height", 0);
        validateInteger.greaterThan("siblings", -1);
        request.success();
      }
      default: {
        throw 'invalid schema_version. Use one of: 0';
      }
    }
  } catch (error) {
    response.status(400);
    response.error('Bad Request');
  }
});