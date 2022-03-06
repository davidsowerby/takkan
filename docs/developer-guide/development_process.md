# Development Process 

There are quite a few moving parts in Precept. In order to keep these parts synchronised, these are the broad principles  to follow: 

## Reference App
A reference application called Medley provides multiple versions of an app and attempts to cover as many features as possible. 

It uses a `PScript` and `PSchema` defined in *precept_script* as top level properties `medleyScript` and `medleySchema` respectively. 

The Medley app, script and schema should be  the first choice for testing where possible. 

## Development Process

If we imagine that the purpose of Precept was to produce the Medley app, we simply use a process that mirrors what we would expect a developer to use to developing their own app based on Precept.

This has the obvious advantage that we can also test the process, and document it for other developers to use.

### Database instances

When we refer to database instances here, we are limited to Back4App, as the only supported backend so far.

When we refer to an instance - let's say 'test' - we mean a Back4App (or local Parse Server) configured for the role of 'Test' server.

These instances are provided by scripted builds to enable multiple concurrent instances of 'Test' with a known initial state.

### Lifecycle

The conventional lifecycle is followed:

- dev, test, qa, prod

All have an initial state of the most recently deployed version of Medley.

Usage:

| instance | purpose                                            | initial state*                                                                                                                                                |
|----------|----------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| dev      | unit testing, experiments                          | Some specimen data. A 'reset' function, so that it can be reset to scratch and redeployed                                                                                            |
| test     | server side code testing, non-UI functional testing | Some meaningful data. Has a 'reset' function, so that it can be reset to scratch and redeployed                                                                                               |
| qa       | UI Functional Testing,  automated and/ or manual   | A small but representative set of data.  A 're-baseline' function to reset data to start point between tests.                                                                                          |
| prod     | production Medley, available as demo               | A good set of data. A 're-baseline' function to clean out random data entered by those using the demo |  


* 'functions' are Cloud Functions which, in a controlled way, enable an appropriate level of reset.  Back4App Environment variables are used to stop, for example, the production version from being accidentally reset completely.
 
:::tip Note
Currently only Back4App is supported. References to database instances here therefore relate to Back4App.
:::


## Deployment

The _precept_dev_app_ is used to link to the Medley app, generate server code and deploy to the selected database instance.

Data ... by code or JSON? What about relationships?


 