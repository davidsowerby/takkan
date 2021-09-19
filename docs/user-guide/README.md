# Introduction to Precept

[Flutter](https://flutter.dev/) is a great tool for building User Interfaces, and is incredibly flexible.

The downside of that flexibility is the amount of repetitive coding it can entail.  

Precept aims to reduce that effort for common use cases, while taking nothing away.

:::tip

In some places, this documentation is written as though certain functionality already exists.  

That's just because it is often easier to capture ideas, document them, and then produce the functionality.

Where that is the case, a :thinking: is shown, linked to an open issue

A :point_right: just means "see details" but looks prettier :smiley_cat:

:::

## Precept Objectives

Precept aims to achieve the following

1. Provide a framework to make Flutter development even faster
1. Combine presentation, data, validation and permissions in a consistent structure[:point_right:](#view-and-model)
1. Provide remote (server based) update to reduce the need for App updates [:point_right:](#reduce-app-updates)
1. Support multiple backends (one authenticator but multiple data providers) [:point_right:](#backend-providers)
1. Support sharing of parts of a Precept definition between Precept apps [:point_right:](#sharing-definitions)
1. Allow developers to override elements of Precept where required [:point_right:](#overriding-precept)
1. Allow developers full access to Flutter functionality, while using Precept for any or all of the app [:point_right:](#access-to-flutter)
1. Be Open Source forever [:point_right:](#open-source)

## Status

A dedicated [status page](../status.md) describes the current progress of the project.

## Overview

Precept functionality is centred around a script for presentation, (`PScript`), and a script to define an associated schema (`PSchema`).

The schema includes validation and permissions rules.

These both produce JSON files, which can be loaded from a server.

These script files can be combined, allowing different parts of an app to be specified separately.
  
Within the client, the JSON files are converted to objects, and combined into a singleton `Precept` object.

Access to your Cloud Provider - (Back4App or Firebase for example) - is managed by a combination of an `Authenticator` class, with a `AuthenticatorDelegate` specific to the given Cloud Provider.

Your app will probably use the same Cloud Provider for much of its data, but may of course use other sources of data.  These are all represented by `DataProvider` instances, each with their own schema.

It is hoped that the Schema definition will also be used to generate / maintain the server side schema.  :crossed_fingers:

The [Precept Script](./precept-script.md) and [Precept Schema](./precept-schema.md) sections provide more detail on script structure.

## View and Model

Precept provides full Forms support, but is actually about any app which requires the presentation and editing of data, regardless of how the data is actually presented.

As a Framework, Precept simplifies the setting up of user login, and provides a simple structure for viewing and editing data.  

A `PScript` and `PSchema` provide a definition of the View and Model layers respectively.  

These are combined with by the Precept build logic to produce forms and data presentation - and importantly for speed of development - bind automatically to the relevant data and provide validation defined by the schema.

Creation of the JSON definition files is done in a way any Flutter developer would recognise.

Field [:thinking:](https://gitlab.com/precept1/precept-client/-/issues/13) and object level [:thinking:](https://gitlab.com/precept1/precept-client/-/issues/14) validation are supported, and defined by the `Schema` .  

The Schema could also be used to define the server side schema and validation, to ensure consistency.:crossed_fingers:

Precept also provides forms with edit / save/ cancel functionality, and different ways to present the data.  For example, an integer might be presented in a TextField, or a spinner.


## Reduce App updates

Both `PScript` and `PSchema` provide a JSON representation, and can be loaded from a remote source to the client, thus enabling updates without the user actually updating the app.

This does not help much with Web development but is primarily aimed at mobile apps, where users are typically unreliable in keeping their apps up to date.

Updating is managed either by server notification, or polling from the client. [:thinking:](https://gitlab.com/precept1/precept-client/-/issues/10)

  

## Sharing Definitions

As an alternative to sharing packages (which requires a client update), parts of a Precept definition may be shared. 


## Backend Providers

There are a number of alternatives for providing backend services - Back4App and Firebase to name a couple.  They provide potentially many services, but Precept concentrates on:

- Authentication
- Persistence (Database of some sort)

Initial development concentrates on Back4App, but is written in a way which will allow alternative implementations of `BackendDelegate`.

An app generally uses one primary data source, but may also consume data from elsewhere, often a REST API.  Generic support is provided for this to integrate with Precept.

Different parts of a page may use different data sources.

## Overriding Precept

There are occasions where a developer may wish to modify the behaviour of Precept for a specific use case.  Precept uses [get_it](https://pub.dev/packages/get_it) to inject implementations.

This dependency injection allows the developer to replace some parts of Precept if they so wish, and as a bonus, makes testing easier. 

## Access to Flutter

Precept intends to make life easier, and Flutter is so flexible it would be inappropriate to prevent the developer from using its full power.

All Precept 'pages' are based on routes, and the `PreceptRouter` can pass any unrecognised routes to the developer's own router.

It is entirely feasible therefore to just use Precept for forms and nothing else - or to migrate an existing app gradually.  

## Open Source

It is.  It always will be.


