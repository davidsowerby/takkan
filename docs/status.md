# Status

The main features of Precept are listed in the [Overview](intro.md#key-features), and repeated here with a brief summary of their current status.

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
*Precept uses a script (`PScript`) to select and display Widgets, and a schema (`PSchema`) to define data structure and permissions.*
:::

The structure of both `PScript` and `PSchema` are now fairly mature, although there may be some additions to come.

Both can be loaded either directly from code, or via http.

Multiple `PScript` instances (inclduing contained `PSchema` instances ) can be combined into a single script, making modular construction possible.

Pages containing Panels and Parts are defined by `PScript` and assembled automatically.

## Layouts

:::tip Feature
*Various layout schemes are provided*
:::
 
This has not moved from the idea stage.  There is currently only one, simplistic layout available.  [Open issue](https://gitlab.com/precept1/precept_client/-/issues/62).


## Traits

:::tip Feature
Traits (similar to styles) are provided to simplify consistent presentation
:::

An initial set of heading and text Traits have been defined, based on the Flutter's Theme.  [More are needed](https://gitlab.com/precept1/precept_client/-/issues/71), and a clear, documented mechanism for user defined Traits is also required.

## Schema

:::tip Feature
A schema (`PSchema`) defines data structure, roles and permissions.
:::

`PSchema` is developed as required across other functionality, but is mostly complete.  There will be additions, but it is hoped that there will be no changes to its present structure.

## Data Bindings

:::tip Feature
*Data Bindings are created automatically, converting data type between model and presentation as needed.*
:::

This is almost complete.  A current document (ab instance of `MutableDocument`) is maintained for editing, with data bindings linking from that document to a Widget for display.

Where required the data type is automatically converted - for example to display an integer in a `Text`.

Bindings for some Geo data types [outstanding](https://gitlab.com/precept1/precept_client/-/issues/45).

## Edit Save Cancel

:::tip Feature
*The Edit / Save / Cancel logic is generated automatically (unless of course an item is read only)*
:::

The logic for this generally works through there is a [bug](https://gitlab.com/precept1/precept_client/-/issues/52) with keeping the display in sync with the edit state.

There is also a need to [improve the presentation](https://gitlab.com/precept1/precept_client/-/issues/69) of this feature, and provide the developer with some options.

## Roles control display

:::tip Feature
*Roles defined by the `PSchema` are used to hide / show widgets / pages as appropriate. *
:::

Some elements of this are working, but this really needs thorough [testing](https://gitlab.com/precept1/precept_client/-/issues/70).

## Validation

:::tip Feature
Validation is defined by the schema and executed by the Widgets assembled by the `PScript`.
:::

The process for field validation works, but there are very few validation methods provided, and they are limited to String and integer types.

Custom validation support is required.

There is currently no process for object validation.

There is an [open issue](https://gitlab.com/precept1/precept_client/-/issues/72) for these.

## Server side schema generation 
:::tip Feature
A backend schema for Back4App can be generated from `PSchema`, complete with roles and validation.
::: 

Work started on generating a schema, but was hindered by discovering that the new Parse Server 4.4.0 validation does not work with Save Triggers.

Back4App have this as an issue, but [work can continue](https://gitlab.com/precept1/precept_back4app_backend/-/issues/4) by generating explicit validation code.

## Data Providers
:::tip Feature
Support for Back4App and generic REST APIs are included, others can be added

:::

The design does allow for development of packages for other data providers (eg Firebase), but there is currently no plan to do so.  The focus is on getting everything right for Back4App first.  

## Remote Update
:::tip Feature
An app may be updated remotely by revising `PScript`
::: 

It is possible to load one or more `PScript` instances from remote sources via HTTP.  These are then merged into a single `PScript`.

A version controlled method is required, to ensure that the desire version is in use. [Issue](https://gitlab.com/precept1/precept_client/-/issues/74)

As there is an instance per Locale, we also need to support locale selection / change. [Issue](https://gitlab.com/precept1/precept_client/-/issues/75)

Local caching is required, otherwise no offline working can be supported [Issue](https://gitlab.com/precept1/precept_client/-/issues/76)

## Partial Use
:::tip Feature
Precept can be used for just part of an app if required
:::

Any pages associated with routes not supported by Precept pages can be provided via a developer supplied alternative router.

This could be further improved by allowing Precept Panels to be embedded in a non-Precept page.  This seems possible, but needs looking at properly. [Issue](https://gitlab.com/precept1/precept_client/-/issues/77)