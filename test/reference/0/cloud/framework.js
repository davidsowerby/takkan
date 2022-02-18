const app = require('./app.js');

// initialises the Precept server side framework:
// - creates a 'sysadmin' role
// - sets up the sysadmin role required by Precept
// - secures User and Role classes as defined by app.userCLP and app.roleCLP
Parse.Cloud.define("initPrecept", async (request) => {
    const roleQuery = new Parse.Query('_Role');
    roleQuery.equalTo("name", "sysadmin");
    const roles = await roleQuery.find({useMasterKey: true});
    if (roles.length === 0) {
        const sysadmin = new Parse.Object("_Role");
        sysadmin.set("name", "sysadmin");
        sysadmin.setACL(new Parse.ACL());
        await sysadmin.save(null, {useMasterKey: true});
        await updateCLP('_User', app.userCLP);
        await updateCLP('_Role', app.roleCLP);
        return 'success';
    }
    return "Call ignored. Delete the sysadmin role manually if you want to reset";

});

// Applies a specific version of [appSchemas] as new server schema
// params:
// 'version':version to apply
Parse.Cloud.define("applyServerSchema", async (request) => {
    const version = parseInt(request.params.version);
    await app.appSchemas(version);
    return await Parse.Schema.all();
});

// Returns the roles allocated to the current user
// Not specific to Precept, just useful
Parse.Cloud.define('userRoles', async (request) => {
    const query = new Parse.Query(Parse.Role).equalTo('users', request.user);
    return await query.find({useMasterKey: true});
});


Parse.Cloud.define('versionStatus', async (request) => {
    return app.versionStatus;
});


// HIGHLY DANGEROUS.
//
// Resets the Back4App instance.
// 'reset' state:
// - all users and roles deleted
// - CLP for User and Role classes are at Back4App defaults (public and requiresAuth respectively)
// Executes only if this Back4App instance has an environment variable 'resettable=true'
// Test use only
Parse.Cloud.define('resetInstance', async (request) => {
    if (!isResettable()) {
        return 'Cannot be reset';
    }
    await updateCLP('_User', CLPPublic);
    await updateCLP('_Role', CLPRequiresAuth);
    return await clearAllClasses();
});

async function clearAllClasses() {
    const schemas = await Parse.Schema.all();
    const purgedClasses = [];
    const deletedClasses = [];
    for (var i = 0; i < schemas.length; i++) {
        const className = schemas[i]['className'];

        purgedClasses.push(className);
        const schema = await new Parse.Schema(className);
        await schema.purge();
        if (className !== '_User' && className !== '_Role') {
            await schema.delete();
            deletedClasses.push(className);
        }

    }
    return {'status': 'success', 'purged classes': purgedClasses, 'deleted classes':deletedClasses};
}

Parse.Cloud.define('isResettable', async (request) => {
    return isResettable();
});

function isResettable() {
    const resettable = process.env.resettable;
    return resettable === 'true';

}

async function updateCLP(className, clp) {
    const currentSchema = await new Parse.Schema(className);
    currentSchema.setCLP(clp);
    await currentSchema.update();
}

// params:
// {'className':class name}
Parse.Cloud.define('getSchema', async (request) => {
    const className = request.params.className;
    return await new Parse.Schema(className).get();
});

const CLPPublic = {
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
const CLPRequiresAuth = {
    "find": {"*": true, "requiresAuthentication": true},
    "count": {"*": true, "requiresAuthentication": true},
    "get": {"*": true, "requiresAuthentication": true},
    "create": {"requiresAuthentication": true},
    "update": {},
    "delete": {},
    "addField": {},
    "protectedFields": {"*": []}
};







