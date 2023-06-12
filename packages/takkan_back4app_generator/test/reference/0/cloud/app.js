const versionStatus = {'current': 0, 'deprecated': []};

const userCLP = {
    "find": {
        "*": true
    },
    "count": {
        "*": true
    },
    "get": {
        "*": true
    },
    "create": {
        "*": true
    },
    "update": {
        "*": true
    },
    "delete": {
        "*": true
    },
    "addField": {
        "*": true
    },
    "protectedFields": {
        "*": []
    }
};

const roleCLP = {
    "find": {
        "*": true,
        "requiresAuthentication": true
    },
    "count": {
        "*": true,
        "requiresAuthentication": true
    },
    "get": {
        "*": true,
        "requiresAuthentication": true
    },
    "create": {
        "requiresAuthentication": true
    },
    "update": {},
    "delete": {},
    "addField": {},
    "protectedFields": {
        "*": []
    }
};

async function version0() {

    // Create Classes

    const schema = new Parse.Schema('Person');
    schema.addNumber('age', {required: true});
    schema.addNumber('height', {required: false});
    schema.addNumber('siblings', {required: false, defaultValue: 0});
    await schema.save(null, {useMasterKey: true});

    // Update Classes

    // Delete Classes

}

async function appSchemas(version) {

    switch (version) {
        case 0:
            return version0();
        default :
            throw 'Invalid version'
    }
}

module.exports = {
    userCLP: userCLP,
    roleCLP: roleCLP,
    appSchemas: appSchemas,
    versionStatus: versionStatus
};

