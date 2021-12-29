// Make an entry in PreceptStateHistory
Parse.Cloud.afterSave("PreceptState", (request) => {
const preceptState=request.object;
var objectJSON = preceptState.toJSON();
delete objectJSON.objectId; // to force new object
var historyState = new Parse.Object( "PreceptStateHistory" );
historyState.set( objectJSON );
historyState.save(null,{ useMasterKey: true });
})

Parse.Cloud.beforeSave("PScript", (request) => {

})
