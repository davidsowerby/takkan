# Schema

The application schema, represented by a single instance of `Schema` is a fundamental part of Takkan. 

## Scope

The `Schema` comprises a number of `Document` definitions, each relating to a database entity.  For Back4App, this means a `Document` equates to a Class.

Each `Document` defines field types and names, validation rules, roles, permissions and queries.

On the client, this information is used to control access to display elements which may require permission, and data validation prior to submission to the server.

The same `Schema` is used to generated cloud functions for validation and queries, plus the Back4App server schema and Class Level Permissions.  

This means that even a hacked client will still have to pass server validation, and as a by-product, also creates a REST API without additional effort.

It also means that the client and server side schemas will always be in sync. 

## Composability

The single application `Schema` instance may start out as a collection of `Schema` instances, but are merged into one application schema at a specific version. 

For example, you may have a `Document` which defines an address in a standard, consistent way, and you want to use it in different applications.  

This can be composed into any application `Schema` which uses addresses.
 

## Version Management

Each `Schema` holds a version number - a simple incrementing integer.  It also optionally contains a label which may be something like '2.12.2-alpha'.

A 'Schema` defines at least a 'current' version, and may also define 'supported' versions.  

### Client feedback

Every call to a generated cloud function must carry a param *schema_version* to identify the requested version.

The returned result then incorporates a client update flag indicating one of:

- no client update required, *schema_version* is up to date,
- recommend a background update, the *schema_version* is supported but not the current version
- require an immediate client update, the *schema_version* is not supported


There is an [outstanding issue](https://gitlab.com/takkan/takkan_back4app_generator/-/issues/6) to look at using notifications instead of, or maybe in conjunction with the above process. The mechanism for this would be backend specific.

## Version update process

For [Back4App](back4app-implementation.md#version_deploy_and_update)


### Validation Code

The concept used by Takkan is straightforward:

- Server validation code is generated with a switch statement, using a case for each version of schema supported.
- Only one version is considered 'current'
- Any number of versions may be 'supported'
- all other versions are considered 'invalid'

In the event of the requested version not being current, the client is [notified](#client-feedback). 

Version status (of both `Script` and `Schema`) can be accessed by a call to server function 'versionStatus'.


### Server Schema

Modifying the server schema is obviously a potentially hazardous task, and one that needs careful security.

The process used by the Back4App implmentation is described [here](./back4app-implementation.md#process). 

## Security

A good starting point is not to trust anything coming from the client, hence the need server side validation code.

However, by generating the server code we also have to consider any unintentional openings this may create.

All generated code has to be deployed using the Back4App CLI, which in turn requires your Back4App account key.

It is possible to update the server schema via the Back4App REST API, but that would require holding the master key outside the server.

To avoid this, the server schema is actually defined in Javascript, and the code deployed in the same way.  

There is an option to either run that code as part of deployment, or allow it to be run later.  The user triggering its execution must hold the 'sysadmin' role. 

## Development and Release Process

### Mobile and Desktop Apps

The intention is to support these scenarios:

#### Backward Compatible 

The latest schema version is backward compatible, and the client may continue operating with the previous version until the new one is downloaded and updated on the client. 

This is the preferred method. For this, the latest version is 'current', any other allowable versions 'deprecated', everything else 'invalid'.  

A call to a deprecated version will trigger a background update, but will continue processing, with little or no interruption to the user.


#### Immediate Change

For example, an error in a schema may need to be update urgently (hopefully not, but these things happen!).

If an immediate change is required, all except the current version are considered 'invalid'.

When a client makes a call it will be passed a status message indicating that a new version must be downloaded.

The client pauses user interaction until it has downloaded the new schema and refreshed to accept the changes. 

This runs a higher risk of hitting a [bottleneck](#bottleneck), plus of course it impacts the user far more.

## Not Compatible 

For a major structural change, there may be some data reorganisation required as well.  This really can only be achieved by closing access to the app for a 'maintenance window'.

At the moment there is no Precep support for this, but there is an [open issue](https://gitlab.com/takkan/takkan_design/-/issues/6) to consider it.  

#### Bottleneck
There is the risk of a bottleneck with potentially every client trying to download a schema update at the same time.

Potential mitigation includes:

- Advance notice - make the updated schema available for download before actually activating.  This is assisted by deprecating versions, allowing a background update.
- 'batching' the update requests by some selection criteria, when a version is deprecated.
- Storing the application schema on a different Back4App instance (or even somewhere else altogether) to reduce the bottleneck.
- "diffing" schema changes, so only the changes need to be downloaded, reducing network load.

There is an [open issue](https://gitlab.com/takkan/takkan_design/-/issues/7) to consider these.

### Web

Obviously there is no need to update clients, so activation will occur as the server activates a new version.

## Tracking data

The methods used the server uses to manage versions varies depending on the backend provider.

Back4App is the only [implementation](back4app-implementation.md#server-side-framework-classes) so far.

                                                                                             
## Testing

Use Back4App instance *takkan-framework-test*

### Steps

TBD

### Process Test:

1. Prepare server 
1. Upload Script with Schema
1. Activate script and schema version as immediate
1. Start up a client
1. Ensure client loads the script and schema
1. Upload an updated Schema
1. Activate schema short while ahead (say 5 seconds)
1. After 5 seconds, check that client is using revised schema
1. Upload an updated Script
1. Activate script short while ahead (say 5 seconds)
1. After 5 seconds, check that client is using revised script


