# Application Configuration

## Overview

A configuration file *takkan.json* must be defined in your project root.

The file is a three level configuration file:

- App
- Group
- Instance

An instance enables access to a specific backend instance, defining things like client and application keys.  A group brings related instances together, with some support for staging.

Finally the App level just contains the whole App configuration.

Internally the levels are represented by

- `AppConfig`
- `GroupConfig`
- `InstanceConfig`

AppConfig can be accessed from the global variable `takkan`. 

## Inherited properties

Some properties are inherited.  This means they can be declared at any level, and will be inherited by lower levels, unless overridden.

This feature is only available via `AppConfig`, `GroupConfig` and `InstanceConfig` - the underlying definition is just a JSON file.

This file defines parameter values for such things as client and application keys, along with some supporting information.

It is loaded into a `AppConfig` instance during application start up.

In addition to the keys / values given below, you can provide your own and access the config in code with a call to global variable `takkan`:

``` dart
takkan.getConfig()
```  

There is an [open issue](https://gitlab.com/takkan/takkan_client/-/issues/89) for this to return an [AppConfig] instance, it currently provides a JSON object.

### Inherited Properties

| property           |              | default                          | notes                                                     |
|--------------------|--------------|----------------------------------|-----------------------------------------------------------|
| appName            | String       | MyApp                            |                                                           |  
| type               | String       | 'back4app'                       | the type of 'backend' currently only 'back4app' or 'rest' |
| serverUrl          | String       | "https://parseapi.back4app.com/" |                                                           |
| documentStub       | String       | classes                          | Appended to serverUrl to produce document endpoint        |
| graphqlStub        | String       | graphql                          | Appended to serverUrl to produce GraphQL endpoint         |
| functionStub       | String       | functions                        | Appended to serverUrl to produce cloud functions endpoint |
| documentEndpoint   | String       |                                  | If defined, completely replaces serverUrl+documentStub    |
| graphqlEndpoint    | String       |                                  | If defined, completely replaces serverUrl+graphqlStub     |
| functionEndpoint   | String       |                                  | If defined, completely replaces serverUrl+functionStub    |   


### Group Only Properties

| property         |                | default                            | notes                                                     |
|------------------|----------------|------------------------------------|-----------------------------------------------------------|
| stages           | List of String | empty                              | see 'stages' below                                        |
| staged           | bool           | false | true if 'stages' not empty |                                                           |

### Instance Only Properties

| property           |                                | default                   | notes                                                     |
|--------------------|--------------------------------|---------------------------|-----------------------------------------------------------|
| headers            | List                           |                           | Header keys, declare exactly as used, see example below   |      
| cloudCodeDirectory | String                         | ~/b4a/$appName/$instance  | Used to deploy cloud code.  Must be [set up](https://www.back4app.com/docs/platform/parse-cli) for the purpose              |                                   


## Stages

Very often, the group for your main application you will have multiple instances, or stages, typically something like 'dev', 'test', 'qa' and 'prod'.

Takkan does provide some support for managing these stages.  Once declared as shown below, the current stage can be set by command line parameter when launching a Takkan app, for example, 'stage=test'

The default current stage is the last item declared in 'stages', in this example, 'prod'.



## Example File

```json
{
  "main": {
    "appName" : "Sample App",
    "type" : "back4app",
    "stages": ["dev","test","qa","prod"],
    "serverUrl": "https://parseapi.back4app.com/",
    "dev": {
      "headers": {
        "X-Parse-Application-Id": "dev app id",
        "X-Parse-Client-Key": "dev client key"
      }
    },
    "test": {
      "headers": {
        "X-Parse-Application-Id": "test app id",
        "X-Parse-Client-Key": "test client key"
      },
      "serverUrl": "http://localhost:1337/parse/"
    },
    "qa": {
      "headers": {
        "X-Parse-Application-Id": "qa app id",
        "X-Parse-Client-Key": "qa client key"
      },
    },
    "prod": {
      "headers": {
        "X-Parse-Application-Id": "prod app id",
        "X-Parse-Client-Key": "prod client key"
      },
    }
  },
  "public REST": {
    "type" : "rest",
    "restcountries": {
      "headers": {},
      "documentEndpoint": "https://restcountries.eu/"
    }
  }
}
```

Some points to note from this example:

- the groups are 'main' and 'public REST'
- 'main' has 4 instances, also declared as stages.
- the 'test' stage has a different serverUrl, overriding the one declared at group level
- the public REST, restcountries instance just declares a documentEndpoint.  For generic REST APIs that is all that is required
- A 'headers' section must be defined within an instance even if empty.

Within the 'headers' section, two are used by Takkan for Back4App instances.

Other headers can be added to *takkan.json* and will be passed with all API calls:

| key                    | notes              |
|------------------------|--------------------|
| X-Parse-Application-Id | Back4App appId     |
| X-Parse-Client-Key     | Back4App clientKey |










#### Headers






