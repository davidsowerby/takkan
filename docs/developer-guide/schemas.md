# Schema Management

The application schema, defined by instances of `Schema` are an integral part of Takkan.  

Although multiple instances of `Schema` may be used to define an application, they are merged into one collection of `PDocument`s to form the application schema. 

There are multiple elements which need to be kept in sync to ensure consistency:

1. `Schema` itself drives client side presentation and validation, enabling view and edit according to data type and user roles.    
1. As any client code is inherently insecure, server side validation code double checks data validation before saving.
1. Server side code creates and updates the Back4App server schema to create or modify Classes.

## Scope of Schema

There are two major components to the application schema:

1. The validation code
1. The server schema 

## Version Management

Inevitably, a schema will need to change as an application is developed or extended.  

Each `Schema` holds a version number - a simple incrementing integer.  It also optionally contains a label which may be something like '2.12.2-alpha'

### Validation Code

The concept used by Takkan is straightforward:

- Server validation code is generated with a switch statement, using a case for each version of schema supported.
- Only one version is considered 'current'
- Any number of versions may be 'deprecated'
- all other versions are considered 'invalid'

These are defined within the generated code, from the current and previous versions of `Schema`. Version status (of both script and schema) can be accessed by a call to server function 'versionStatus'.

The current version from the client is included with all calls to the server. This allows 3 different responses:

- The client version is also the server current version.  Data is returned as normal, and no further action is required
- The client version is marked as deprecated on the server.  Data is returned as normal, together with a 'deprecated' message.  The client downloads the current schema version and updates in the background.
- The client version is invalid (it is either out of date or has never been issued).  No data is returned, and the client must download the current version in order to continue.

### Server Schema

It is possible to update the server schema via the Back4App REST API, but that would require holding the master key outside the server.

To avoid this, the server schema is actually defined in Javascript, and the code deployed in the same way as the validation code.

This, however, means that the schema update code must be executed before the schema is applied to the server.

## Deployment

Schema code has to be executed before the server schema is actually updated.  This means that if validation and schema code were deployed together, here could easily be a situation where the server schema and server validation code do not match.
 
To avoid this, deployment is actually in 2 stages:

1. Deploy server schema update code, with validation code unchanged
1. Apply server schema updates
1. Deploy validation code

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

Use Back4App instance *precept-framework-test*

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


