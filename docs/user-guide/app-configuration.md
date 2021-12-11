# Application Configuration

## precept.json

This file defines parameter values for such things as client and application keys, along with some supporting information.

It is loaded into a `AppConfig` instance during application start up.

In addition to the keys / values given below, you can provide your own and access the config in code with a call to global variable `precept`:

``` dart
precept.getConfig()
```  

There is an [open issue](https://gitlab.com/precept1/precept_client/-/issues/89) for this to return an [AppConfig] instance, it currently provides a JSON object.



### File structure

The file is divided into multiple segments, with each segment divided into instances.  For example:

```json
{
  "back4app": {
    "dev": {
      "headers": {
        "X-Parse-Application-Id": "a real app id",
        "X-Parse-Client-Key": "a real client key"
      },
      "serverUrl": "https://parseapi.back4app.com/"
    },
    "test": {
      "headers": {
        "X-Parse-Application-Id": "test",
        "X-Parse-Client-Key": "test"
      },
      "serverUrl": "http://localhost:1337/parse/"
    },
    "qa": {
      "headers": {
        "X-Parse-Application-Id": "a real app id",
        "X-Parse-Client-Key": "a real client key"
      },
      "serverUrl": "https://parseapi.back4app.com/"
    },
    "prod": {
      "headers": {
        "X-Parse-Application-Id": "a real app id",
        "X-Parse-Client-Key": "a real client key"
      },
      "serverUrl": "https://parseapi.back4app.com/"
    }
  },
  "public REST": {
    "restcountries": {
      "headers": {},
      "serverUrl": "https://restcountries.eu/"
    }
  }
}

```

In this case, the segments are 'back4app' and 'public REST'.


Typically, within the main application you will have multiple instances, in this example 'dev', 'test', 'qa' and 'prod'.

Each of these is an 'instance' and is represented by `InstanceConfig`.

Each instance has a number of parameters, or you may add your own and access the values via:

``` dart
precept.getConfig()
```  

### Instance Params

The parameters defined and used by Precept:

#### Core parameters

| key                | default                        | notes                                                                                                 |
|--------------------|--------------------------------|-------------------------------------------------------------------------------------------------------|
| headers            | n/a                            | Automatically included in API calls as headers, see below                                             |  
| type               | generic REST                   | 2 types supported 'generic REST' and 'back4app'.  Set automatically if segment is 'back4app'          |
| serverUrl          | https://parseapi.back4app.com/ | url to the server.  For Back4App, can be overridden in a call to lib/backend/back4app/cloud/init.dart |
| restEndpoint       | classes                        | Appended to the serverUrl to provide the base url for REST calls                                      |
| graphqlEndpoint    | graphql                        | Appended to the serverUrl to provide the GraphQL endpoint                                             |
| cloudCodeDirectory | ~/b4a/$appName/$instance       | The local (workstation) directory used to sync code to Back4App*                                      |
| appName            | MyApp                          |                                                                                                       |                           |


* This must be [set up](https://www.back4app.com/docs/platform/parse-cli) for the purpose 

#### Headers

A 'headers' section must be defined within an instance even if empty.

Within the 'headers' section, two are used by Precept for Back4App instances.

Other headers can be added to *precept.json* and will be passed with all API calls:

| key                    | notes              |
|------------------------|--------------------|
| X-Parse-Application-Id | Back4App appId     |
| X-Parse-Client-Key     | Back4App clientKey |


Note that headers can also be added on a case by case basis when defining a `PDataProvider`


