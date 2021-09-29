---
sidebar_position: 1
---
# Overview

If you have not already, is is worth looking at the [Precept Overview](../intro.md), which provides a summary of Precept's features.

## Purpose

Precept aims to reduce development time, in three broad areas:

1. by automating a substantial amount of the work currently needed to bind Widgets to data,
1. by providing device aware layouts that simplify the construction of pages in a consistent way across an application
1. by providing Traits (basically styles, but with some behavioural attributes), which enable consistent appearance and behaviour across an application.

Equally important, none of these features actually prevent a developer from direct access to Flutter's immense range of features.

Precept is useful for any app which requires the presentation and editing of data, regardless of how the data is actually presented - whether a standard, boring form, or the slickest, most magical way of presenting data..

## View and Model

Both the view, or presentation layer, and the model, or data, layer are defined by scripts.

### Scripts

A `PScript` and `PSchema` provide a definition of the View and Model layers respectively. 

A `PSchema` is always contained within a `PScript`, and ultimately there is a single `PScript` per app - although that single `PScript` may be created by merging multiple `PScript` instances to support modularity.

Simplistically, Precept acts as an interpreter of the `PScript` in order to provide the app.

The Precept build logic produces pages mapped to routes - and importantly for speed of development - bind automatically to the relevant data and execute the validation defined by the schema.

A `PScript` can be exported / imported as a JSON file via HTTP or any other transport mechanism.

## View

The part of the Widget tree produced by Precept follows the structure of `PScript`.
  
`PPage`, `PPanel`, `PPart` and `PParticle` become instances of `PreceptPage`, `Panel`, `Part` and `Particle` respectively, shown in the [diagram](#diagram) below.

`PreceptPage`, `Panel`, `Part` and `Particle` are known as 'Content' widgets.

The page is built using the `PreceptRouter`, responding to the route mapped to the `PPage`.

The page content is built as Panels or Parts as defined by the `PScript`, with Panels being nestable.

The rest of the build just occurs through the normal Flutter Widget **build** method.

A `ContentBuilder` mixin is used because many of the build methods required are the same across all the 'Content' widgets.

Note that with the exception of `Particle`, all the 'Content' widgets are stateful - the reason for this is covered in the [Data](#data) section.

There is currently only one type of Page, Panel and Part, although that may change.

Particle types are looked up from the `ParticleLibrary`, which also allows you to [register](./libraries.md#registering-with-a-library) your own Particle implementations.

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


