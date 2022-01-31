// initialises the Precept server side framework:
// - creates a 'sysadmin' role
// It should only be possible to run this once - https://gitlab.com/precept1/precept_back4app_server/-/issues/2
Parse.Cloud.define("initPrecept", async (request) => {
    await initRoles();
    return 'success';
});

// Returns the roles allocated to the current user
// Not specific to Precept, just useful
Parse.Cloud.define('userRoles', async (request) => {
    const query = new Parse.Query(Parse.Role).equalTo('users', request.user);
    return await query.find({useMasterKey: true});
});


// sets up the roles required by Precept
async function initRoles() {
    const sysadmin = new Parse.Object("_Role");
    sysadmin.set("name", "sysadmin");
    sysadmin.setACL(new Parse.ACL());
    await sysadmin.save(null, {useMasterKey: true});
}






