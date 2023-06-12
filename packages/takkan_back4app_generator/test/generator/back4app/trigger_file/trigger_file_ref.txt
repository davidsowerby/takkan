const b4a = require('../../b4a_schema.js');

// Default schema_version is provided, otherwise data cannot be updated from the Back4App Dashboard
// To validate what might be a partial update, we check original if present
Parse.Cloud.beforeSave('Person', (request) => {
    const schema_version = (request.params) ? (request.params.schema_version) ? parseInt(request.params.schema_version) : b4a.schemaVersion : b4a.schemaVersion;

    switch (schema_version) {
        case 2: {
            const firstNameProp = request.object.get('firstName') ?? ((request.original) ? request.original.get('firstName') : null);
            if (firstNameProp == null) throw 'validation firstName';
            const firstName = firstNameProp;
            if (!(firstName.length > 1)) throw 'validation firstName';

            const ageProp = request.object.get('age') ?? ((request.original) ? request.original.get('age') : null);
            if (ageProp == null) throw 'validation age';
            const age = parseInt(ageProp);
            if (!(age > 0)) throw 'validation age';
            if (!(age < 128)) throw 'validation age';

            const heightProp = request.object.get('height') ?? ((request.original) ? request.original.get('height') : null);
            if (heightProp != null) {
                const height = parseInt(heightProp);
                if (!(height > 0)) throw 'validation height';
                if (!(height < 300)) throw 'validation height';
            }

            break;
        }

        case 1: {
            const firstNameProp = request.object.get('firstName') ?? ((request.original) ? request.original.get('firstName') : null);
            if (firstNameProp == null) throw 'validation firstName';

            const ageProp = request.object.get('age') ?? ((request.original) ? request.original.get('age') : null);
            if (ageProp == null) throw 'validation age';
            const age = parseInt(ageProp);
            if (!(age > 0)) throw 'validation age';
            if (!(age < 128)) throw 'validation age';

            const heightProp = request.object.get('height') ?? ((request.original) ? request.original.get('height') : null);
            if (heightProp != null) {
                const height = parseInt(heightProp);
                if (!(height > 0)) throw 'validation height';
                if (!(height < 300)) throw 'validation height';
            }

            break;
        }

        case 0: {
            const ageProp = request.object.get('age') ?? ((request.original) ? request.original.get('age') : null);
            if (ageProp == null) throw 'validation age';
            const age = parseInt(ageProp);
            if (!(age > 0)) throw 'validation age';
            if (!(age < 100)) throw 'validation age';

            const heightProp = request.object.get('height') ?? ((request.original) ? request.original.get('height') : null);
            if (heightProp != null) {
                const height = parseInt(heightProp);
                if (!(height > 0)) throw 'validation height';
            }

            const siblingsProp = request.object.get('siblings') ?? ((request.original) ? request.original.get('siblings') : null);
            if (siblingsProp != null) {
                const siblings = parseInt(siblingsProp);
                if (!(siblings > -1)) throw 'validation siblings';
            }

            break;
        }

        default: {
            throw 'Invalid version requested';
        }
    }
});

