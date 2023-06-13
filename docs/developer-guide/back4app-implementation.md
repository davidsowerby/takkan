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

### Process

A [Takkan administrator](https://gitlab.com/takkan/takkan_design/-/issues/44), using the [Orchestrator](./orchestrator.md), goes through these steps:  


1. the server schema is generated into a local directory. *framework.js*  is copied into the directory if this is the first deployment.  The local directory is specified by specified by *takkan.json* property 'serverCodePath'.
1. the server schema is deployed to the Back4App instance, with  *framework.js* if required, using the Back4App CLI command `b4a deploy`
1. depending on whether this is an initial deployment, or update:
    - for initial deployment:
        - cloud function 'initTakkan' is invoked to create base roles and classes
        - cloud function 'initStore' is invoked if this instance acts as a [Takkan Store](./store.md) 
    - for updates:
        - cloud function 'applyServerSchema' is invoked
1. the rest of the server code is then generated from the Takkan `Schema` and deployed using the Back4App CLI command
1. the [Takkan Store](./store.md) is updated with any changes to the `Schema`.

The version may now be considered 'released'.


:::tip Note
For initialization to work, a Back4App instance is expected to be clean.  If you want to re-use an instance, the Takkan framework includes a 'resetInstance' cloud function.
However, to avoid embarrassing mistakes, this function will only execute if this Back4App instance has an environment variable 'resettable=true'
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



