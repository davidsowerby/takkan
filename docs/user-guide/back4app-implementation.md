# Back4App Implementation

## Client Side
The Back4App client side implementation contains implementations for [DataProvider](data-providers.md) and `PDataProvider`.

## Server Side

The Back4App server-side implementation provides a simple framework - a few Back4App Classes and cloud functions - needed to make Precept work.

They are primarily there to enable the use of a single schema for both client and server side, through the use of [server side schema generation](server-side-schema-generation.md).

### Cloud Functions

- **initPrecept** creates the Back4App Classes used to manage 
- **initScriptClasses** prepares Back4App to accept instances of `PScript` and `PSchema`, and needs to be invoked only on a Back4App instance that will be used to store them.

### Initialise Server Instance

[See](../tutorial/prepare-back4app.md)



### Classes

Precept uses these classes:

| Class               | Purpose                                                                                          |
|---------------------|--------------------------------------------------------------------------------------------------|
| PreceptState        | Only ever has one row. Records the current version of client (PSchema), server and framework schemas in use. |
| PreceptStateHistory | A history of changes to PreceptState                                                             |


The framework schema is a rather grand title for ensuring changes to this simple Class structure can be managed, if they are ever needed.

Note that server schema is considered to **include validation code functions**, so there is currently no situation where the `PSchema` and server schemas should be operating at a different version.
 
Their versions are recorded separately just in case that ever needs to change.  

### Functions

#### initPrecept

When a blank Back4App instance is first created, some preparation is needed to enable Precept to work.

The function code is uploaded from a client using the *initFramework* function provided by the *precept_back4app_backend* package.

:::tip Note

There is an [outstanding issue](https://gitlab.com/precept1/precept_back4app_client/-/issues/7) to look at restructuring the *precept_back4app_backend* package.
:::









