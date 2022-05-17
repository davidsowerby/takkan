# Precept Script

## Introduction

The Precept Script, `PScript`, defines the presentation of any pages supplied by Precept.
 
It contains one or more [PDataProvider](data-providers.md) instance, which  in turn contain [PSchema](precept-schema.md) instances, to connect presentation to data.

It also uses the [PSchema](precept-schema.md) to define validation, and user permissions. Precept uses these permissions to decide whether or not to enable editing / viewing of data.


:::caution

Although `PSchema` is used to limit access to data in the client, this is mainly for usability.  It should not be seen as security (although it helps a bit).
 
It is better to work on the simple premise that nothing from a client can be trusted, and therefore, validation and access control must be provided by the server - but that's true for any client.

To help with this, a Back4App server-side schema can be generated from `PSchema`.  [![task](../images/idea.svg)](https://gitlab.com/precept1/precept_back4app_backend/-/issues/4) 

:::


## Structure

The table below shows the structure used.  The "definition" column is what the developer provides to configure Precept they want it to be.

The  "Widget" column shows the associated Widget provided by Precept, where there is one.



| Widget   | Definition                                | Description                                                                                                            |  Widget |
|----------|---------------------------------------|----------------------------------------------------------------------------------------------------------------------------|---|
|          | Precept  [:point_right:](#precept)                             | A singleton holding a merged collection of `PScript`, potentially using multiple data sources and backends    | n/a  |
|          | PScript [:point_right:](#pscript) | A collection of PPages and routes                                                               | n/a  |
| Page     | PPage [:point_right:](#page)                                | The outer layout of what the user perceives as a page, identified by route                     | PreceptPage     |
| Panel    | PPanel [:point_right:](#panel)                              | A nestable, arbitrary area of a Page,                               | Panel  |
| Part     | PPart [:point_right:](#part)                                 | Relates to a database field, representing a read / edit pair of Particles | Part  |
| Particle | PParticle [:point_right:](#particle)                         | Defines the attributes of a single read or edit Widget                                              | Particle  |


Combined with the [Schema](./precept-schema.md), the overall structure is depicted below.  


:::tip Note
The diagram does not show all Widgets, just those immediately relevant to the script and the schema.

For more on Widgets, see the [Widget Tree](./widget-tree.md)

::: 

![overview diagram](../images/precept-overview.svg)

## The Precept Process

Using Precept is mostly about configuration.

The upper part of the structure is really just to support routing, multiple scripts and code management.

From [Page](#page) downwards it is about producing Widgets, and that process is discussed in more detail in the [Widget Tree](./widget-tree.md) section.

## Version Control

`PScript` and [PSchema](./precept-schema.md) are version numbered to help ensure consistency, especially when you may have users with different versions.

A version is a simple incrementing integer.

## Dynamic vs Static Data

To be clear, in this context we mean:

- **dynamic** data is data that is taken from a `Query`, and subject to  permissions, may be changed.
- **static** data is defined as part of the `PScript`. Here we are talking about things like descriptive text, notices and images that do not change as a result of a change to data.

Precept defines static data within a `PPart` , and can therefore be changed remotely by [updating](script-management.md) `PScript`.

## Precept

There is a singleton Precept instance which brings together all the JSON inputs for remote configuration of the user interface.

The developer configures one or more `PreceptLoader`s to load `PScript` JSON files, typically from a server.

`Precept` is located in the *precept_client* package.

### Inherited Properties

`PScript` is a tree structure, and every level inherits from `PCommon`.

`PCommon` defines a set of properties which are available to all levels, and if not defined at one level, will use the first value it can find walking up its parent chain.

In effect, this means a value set in a higher level will apply to all lower levels, unless overridden at a lower level.

This is intended to reduce the amount of manual configuration required.

A [PDataProvider](#dataprovider), for example, is often defined high up the tree, because a system will often use one data source for much of its operation.

Some `PCommon` properties are not actually used at all levels.

## PScript

`PScript` and its lower levels are located in the *precept_script* package, as shown in the [dependencies diagram](./installation.md#dependencies).

A `PScript` instance is used to provide a reasonably type-safe declaration of the user interface of an app.

Multiple scripts may be combined into one `Precept` instance, but there must be at least one.

Each `PScript` is loaded by an implementation of `PreceptLoader`, typically from the app's primary backend, but it can be from anywhere.

A `PScript` must contain at least one `PPage`.

A call to `PScript.init()` must be made before using it. 

A call to `PScript.validate()` will check the script for inconsistencies. This automatically calls `init()`.


## Page

A 'route' is a map key for a specific `PPage`.  A route is generally shown as something like */user/home*, but that structure is entirely optional - a path is just a String, with no expectations of structure, so it can be anything you want.

A `PreceptPage` is a representation of what the end user might perceive as a page.  It is typically represented by a Widget containing a Flutter `Scaffold`.

A page displays the elements such as header bars, FAB, footers etc, plus its **children**.

You can create your own [custom pages](./page-types.md#custom-pages).  [:thinking:](https://gitlab.com/precept1/precept-client/-/issues/24)

:::tip
Where you do not want to use Precept to construct a page, simply [use your router](partial-use.md#alternate-router) alongside `PreceptRouter`. 
:::

`PPage` or one of its descendants defines the configuration of the page.

The process of building from a `PScript` configuration is described in the [Widget Tree](./widget-tree.md) section. 

The **content** of a `PPage` is defined by a collection of `PPanel` and / or `PPart`. [:thinking:](https://gitlab.com/precept1/precept-client/-/issues/24)


## Panel

A `Panel` is an arbitrary section of a [page](#page). 

The **content** of a `Panel` is defined by a collection of `PPanel` and / or `PPart`, meaning that Panels can be nested.

 

## Part

A Part relates to a data field, but declares a `PReadParticle`, and optionally a `PEditParticle`.  

`PPart` contains some attributes common to both read and edit `PParticle`s, for example **showCaption** and **caption**.
 
If a `PPart` is declared as read only, it need only declare the **read** property with a `PPartParticle`.
 
`PPart` may also be static, in which case it uses 'data' from the script.  It is therefore read only.

When `PPart` is constructed as a `Part` Widget, if it not read only it also has an `EditState` placed above it in the Widget Tree.

The `EditState` controls the current edit mode, and may also further inhibit editing if the user does not have permissions.

The `Part` references its nearest [Query](#query), which in turn contains a reference to the [schema](./precept-schema.md)

The schema is used to support model-to-view type conversion and validation.


## Particle

A `Particle` is a sub-element of a `Part`.  It represents a data field, but specifically a Widget that is for read mode or edit mode.

There are a number of implementations of `Particle`, which are named according to the Widget that is used for presentation.

The most common, for example, is `TextParticle` to display a `Text` Widget, and `TextBoxParticle` to edit text.

A further example might be where a `PPart` declares a `TextParticle` to display an integer, but a `SpinnerParticle` to
edit.

You can just use pre-defined Particles or define your own and register them with the [ParticleLibrary](./libraries.md#particle-library).


## DataProvider

Configured by `PDataProvider` this defines the backend system to use - there may be more than one in a Precept system.  
For example, most of the data may come from, say, Back4App, but the app may also use one or more public REST APIs for supplementary data. 

`PDataProvider` declares the [schema](./precept-schema.md) to use, which supports type conversion and validation between data and the presentation layer (the [Particle](#particle)).

### Configuration File

A Data Provider will almost certainly require keys of some sort - client key, app key or similar.  These can be declared within the `PScript`,
but we believe it is better to define them in a JSON configuration file held as a Flutter asset, but NOT committed to your VCS.

Although the keys could still be decompiled from the app, this approach is better than declaring them openly. 

#### precept.json

The example below shows the keys and URLs for 4 instances of Back4App (not real keys of course!) and a REST data provider.  

The instance name (test, dev etc) can be set using the 'env' property, or your own naming convention using the 'instanceName' property.

The keys must be exactly those used in headers.

There must always be 2 levels of definition.


``` json
{
  "back4app": {
    "dev": {
      "X-Parse-Application-Id": "xLWKrOqcvber9ovoalO2XFuKQn0NlHPksJV6",
      "X-Parse-Client-Key": "Iqwexbxsnsn0IIxWF01flSxhpJf6FO1gAkQ",
      "serverUrl": "https://parseapi.back4app.com/"
    },
    "test": {
      "applicationId": "test",
      "clientId": "test",
      "serverUrl": "http://localhost:1337/parse/"
    },
    "qa": {
      "applicationId": "RXKWt1tuVRxxaaadsdaaaaaaa39Hc16Qxl2X",
      "clientId": "utsdfdffxxxxxvv6FSwwlTjvxA15Y4Qs",
      "serverUrl": "https://parseapi.back4app.com/"
    },
    "prod": {
      "applicationId": "TfjrHUxxmmiwiwiwwiPFdqGoIdoDDhbSq",
      "clientId": "5kVaamammsmmsmmsmmgtOTb1zcWjE1voJCg",
      "serverUrl": "https://parseapi.back4app.com/"
    }
  },
  "restcountries": {
    "public": {"serverUrl": "https://restcountries.eu/"}
  }
}
}


``` 

## Query

A `PQuery`, in conjunction with a `PDataProvider`, sources the data to be displayed and / or edited.

The query refers back to the closest `PDataProvider` above it in the tree.

A `PQuery` implementation falls into one of these broad categories:

- 'get' and 'getList' use the SDK appropriate to the backend, and return either Futures or Streams.
- 'fetch' and 'fetchList' use calls to Cloud Functions to access the data, and return either Futures or Streams.


See the code documentation for `PQuery` for a detailed list of calls available. 


## Example

A good example of the script structure is the [Kitchen Sink](../developer-guide/medley-app.md) we use for testing.




