---
sidebar_position: 2
---
# Status

The main features of Takkan are listed in the [Overview](intro.md#key-features), and repeated here with a brief summary of their current status.

## Last updated

2021-09-26

## Changes since last update
<body bgcolor="#ffff66">Changes from the last update are highlighted.</body>


## Overview

Documentation has been moved from [VuePress to Docusaurus](../blog/move-to-docusaurus).

Documentation structure has been tidied up a bit.


## Features

## Script

:::tip Feature
*Takkan uses a script (`Script`) to select and display Widgets, and a schema (`Schema`) to define data structure and permissions.*
:::

The structure of both `Script` and `Schema` are now fairly mature, although there may be some additions to come.

Both can be loaded either directly from code.  It is intended that it can also be loaded via REST.  [![task](../docs/images/task.png)](https://gitlab.com/takkan/takkan_client/-/issues/78).


Multiple `Script` instances (including contained `Schema` instances ) can be combined into a single script, making modular construction possible.

Pages containing Panels and Parts are defined by `Script` and assembled automatically.

## Layouts

:::tip Feature
*Various layout schemes are provided*
:::
 
This has not moved from the idea stage.  There is currently only one, simplistic layout available. [![task](../docs/images/task.png)](https://gitlab.com/takkan/takkan_client/-/issues/62).


## Traits

:::tip Feature
Traits (similar to styles) are provided to simplify consistent presentation
:::

An initial set of heading and text Traits have been defined, based on the Flutter's Theme.  [More are needed](https://gitlab.com/takkan/takkan_client/-/issues/71), and a clear, documented mechanism for user defined Traits is also required.

## Schema

:::tip Feature
A schema (`Schema`) defines data structure, roles and permissions.
:::

`Schema` is developed as required across other functionality, but is mostly complete.  There will be additions, but it is hoped that there will be no changes to its present structure.

## Data Bindings

:::tip Feature
*Data Bindings are created automatically, converting data type between model and presentation as needed.*
:::

This is almost complete.  A current document (an instance of `MutableDocument`) is maintained for editing, with data bindings linking from that document to a Widget for display.

Where required the data type is automatically converted - for example to display an integer in a `Text` Widget.

Bindings for some Geo data types [outstanding](https://gitlab.com/takkan/takkan_client/-/issues/45).

## Edit Save Cancel

:::tip Feature
*The Edit / Save / Cancel logic is generated automatically (unless of course an item is read only)*
:::

The logic for this generally works through there is a [bug](https://gitlab.com/takkan/takkan_client/-/issues/52) with keeping the display in sync with the edit state.

There is also a need to [improve the presentation](https://gitlab.com/takkan/takkan_client/-/issues/69) of this feature, and provide the developer with some options.

## Roles control display

:::tip Feature
*Roles defined by the `Schema` are used to hide / show widgets / pages as appropriate. *
:::

Some elements of this are working, but this really needs thorough [testing](https://gitlab.com/takkan/takkan_client/-/issues/70).

## Validation

:::tip Feature
Validation is defined by the schema and executed by the Widgets assembled by the `Script`.
:::

The process for field validation works, but there are very few validation methods provided, and they are limited to [String and integer](https://gitlab.com/takkan/takkan_client/-/issues/72) types.

[Custom validation](https://gitlab.com/takkan/takkan_client/-/issues/72)  support is required.

There is currently no process for [object validation](https://gitlab.com/takkan/takkan_client/-/issues/14). 


## Server side schema generation 
:::tip Feature
A backend schema for Back4App can be generated from `Schema`, complete with roles and validation.
::: 

Work started on generating a schema, but was hindered by discovering that the new Parse Server 4.4.0 validation did not work with Save Triggers.

This has been resolved; and [work can continue](https://gitlab.com/takkan/takkan_back4app_backend/-/issues/4).

## Data Providers
:::tip Feature
Support for Back4App and generic REST APIs are included, others can be added

:::

The design does allow for development of packages for other data providers (eg Firebase), but there is currently no plan to do so.  The focus is on getting everything right for Back4App first.  

## Remote Update
:::tip Feature
An app may be updated remotely by revising `Script`
::: 

It is possible to load one or more `Script` instances from remote sources via HTTP.  These are then merged into a single `Script`.

A version controlled method is required, to ensure that the desire version is in use. [![task](images/task.png)](https://gitlab.com/takkan/takkan_client/-/issues/74)

As there is an instance per Locale, we also need to support locale selection / change. [![task](images/task.png)](https://gitlab.com/takkan/takkan_client/-/issues/75)

Local caching is required, otherwise no offline working can be supported [![task](images/task.png)](https://gitlab.com/takkan/takkan_client/-/issues/76)

## Partial Use
:::tip Feature
Takkan can be used for just part of an app if required
:::

Any pages associated with routes not supported by Takkan pages can be provided via a developer supplied [alternative router](user-guide/partial-use.md#alternate-router) [![task](images/task.png)](https://gitlab.com/takkan/takkan_client/-/issues/80).

This could be further improved by allowing Takkan Panels to be embedded in a non-Takkan page.  This seems possible, but needs looking at properly.  [![task](images/task.png)](https://gitlab.com/takkan/takkan_client/-/issues/77).