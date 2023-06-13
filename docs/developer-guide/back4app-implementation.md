# Back4App Implementation

## Client Side

Code: *takkan_back4app_client* package.

Contains implementation for [DataProvider](data-providers.md).


## Server Side

Code package: Javascript with Dart tests, *takkan_back4app_generator* package.


- Copies the file *framework.js*, which provides some essential functions for Takkan.  *framework.js* is held in the *takkan_back4app_generator* package.
This file is intended not to change very much.
- Generates a server schema and various Javascript cloud functions from its application [Schema](./schemas.md).  These cover validation, roles, permissions Class Level Permissions and the server schema
- A Back4App instance may also be used as a [store](./store.md) for `Script` and `Schema` versions 


:::tip Note
There is a slight difference in terminology here - for Back4App, every instance is an 'app'.  For Takkan, an app may have a dev, test, qa and prod instance (for example),
each of which would be a separate Back4App 'app'.
:::

## Setting up an app

Every Back4App instance used with a Takkan client needs to be initialised.  The *takkan_orchestrator* package provides management of the Takkan aspects of Back4App instances.

When mason is used to start a Takkan project, two apps are created:

- A skeleton end user app, 'MyApp'
- An 'orchestrator' app, 'MyApp_Orchestrator', which incorporates the *takkan_orchestrator* and *takkan_back4app_generator* packages.


## Version Deploy and Update

Our goal is to set up a Back4App instance from a Takkan [Schema](./schemas.md).

It is possible to modify the server schema via the Back4App API, but this requires having access to the Master Key outside the server.

This is is not recommended, and Takkan reduces this risk by using an authenticated role instead.

Initial deployment and an update deployment are slightly different in process, but both are conducted by a [Takkan administrator](https://gitlab.com/takkan/takkan_design/-/issues/44), using the [Orchestrator](./orchestrator.md).


### Configuration

A local deployment directory is specified by *takkan.json* property 'serverCodePath'.  

The layout of files within its directory is determined by an implementation of `ServerCodeStructure`. 

### Initial Deployment Process

1. all the server code files are generated into a local deployment directory specified.  
1. the server code files are deployed to the Back4App instance using the Back4App CLI command `b4a deploy`.
1. the Back4App instance is initialised using by invoking cloud function 'initTakkan' to create base roles and classes (including the administrator role).
1. a [Takkan Store](#takkan_store) is [created](#creating-a-takkan-store).
1. the `Schema` is uploaded to the [Takkan Store](./store.md).

The version may now be considered 'released'.

### Update Deployment Process

When a system is already up and running we need to update the server code in a specific order to avoid mis-matches between clients and server,

:::danger
This process relies on a schema being backward compatible.  If it is not, data loss may occur.  

However, if you understand and accept the impact on your data, the process will work.
:::

1. the server schema only is generated into the local deployment directory.
1. if *framework.js* has changed (a hopefully rare event), that will also be added to the deployment directory.
1. these files are deployed to the Back4App instance, using the Back4App CLI command `b4a deploy`
1. cloud function 'applyServerSchema' is invoked.
1. when the schema has updated, the rest of the server code is then generated from the Takkan `Schema`.
1. this updated code is deployed using the Back4App CLI command `b4a deploy`
1. the `Schema` is uploaded to the [Takkan Store](./store.md).

The version may now be considered 'released'.

When client requests arrive now, they will be notified that a new version is [available](./schemas.md#client-feedback).

### Creating a Takkan Store

There is a reserved group in *takkan.json* named 'takkan_store', which defines the properties for the cloud instance nominated to hold `Schema` and `Script` instances.

If the group does not exist, it is assumed that the first declared instance configuration in the 'main' group is to be used as a store.

:::tip Note
For initialization to work, a Back4App instance is expected to be clean.  If you want to re-use an instance, the Takkan framework includes a 'resetInstance' cloud function.
However, to avoid embarrassing mistakes, this function will only execute if this Back4App instance has an environment variable 'resettable=true'.  

To set the environment variable you will need access to the Back4App dashboard.
:::

## Server Code Directory Structure

```yaml
app.js
framework.js
classes/{class}/api.js
               /triggers.js
               /functions.js
config
schema
validation

                                                                                  |
```


## Notes for Developers

Random but hopefully useful notes for anyone developing with or for Back4App server code for Takkan 

### Getting the Schema

This gets the whole schema

``` javascript
    const s = await new Parse.Schema('_User').get();

```

The following gets the whole schema *except* the CLP.  A bit odd!


``` javascript
    const s = await new Parse.Schema('_User');

```

**BUT:**

*purge* and *delete* only work with :

``` javascript
    const s = await new Parse.Schema('MyClass');

```

### Schema Save vs Update

Save will reject if the schema name already exists.

Update really is just that.



