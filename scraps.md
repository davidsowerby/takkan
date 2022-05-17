# Scraps

Bits of text that have been moved but might just come in handy




## View

The part of the Widget tree produced by Takkan follows the structure of `Script`.
  
`PPage`, `PPanel`, `PPart` and `PParticle` become instances of `TakkanPage`, `Panel`, `Part` and `Particle` respectively, shown in the [diagram](#diagram) below.

`TakkanPage`, `Panel`, `Part` and `Particle` are known as 'Content' widgets.

The page is built using the `TakkanRouter`, responding to the route mapped to the `PPage`.

The page content is built as Panels or Parts as defined by the `Script`, with Panels being nestable.

The rest of the build just occurs through the normal Flutter Widget **build** method.

A `ContentBuilder` mixin is used because many of the build methods required are the same across all the 'Content' widgets.

Note that with the exception of `Particle`, all the 'Content' widgets are stateful - the reason for this is covered in the [Data](#data) section.

There is currently only one type of Page, Panel and Part, although that may change.

Particle types are looked up from the `ParticleLibrary`, which also allows you to [register](./libraries.md#registering-with-a-library) your own Particle implementations.

Takkan also provides forms with edit / save/ cancel functionality, and different ways to present the data.  For example, an integer might be presented in a TextField, or a spinner.
## Reduce App updates

Both `Script` and `Schema` provide a JSON representation, and can be loaded from a remote source to the client, thus enabling updates without the user actually updating the app.

This does not help much with Web development but is primarily aimed at mobile apps, where users are typically unreliable in keeping their apps up to date.

Updating is managed either by server notification, or polling from the client. [:thinking:](https://gitlab.com/takkan/precept-client/-/issues/10)

  

## Sharing Definitions

As an alternative to sharing packages (which requires a client update), parts of a Takkan definition may be shared. 


## Backend Providers

There are a number of alternatives for providing backend services - Back4App and Firebase to name a couple.  They provide potentially many services, but Takkan concentrates on:

- Authentication
- Persistence (Database of some sort)

Initial development concentrates on Back4App, but is written in a way which will allow alternative implementations of `BackendDelegate`.

An app generally uses one primary data source, but may also consume data from elsewhere, often a REST API.  Generic support is provided for this to integrate with Takkan.

Different parts of a page may use different data sources.

## Overriding Takkan

There are occasions where a developer may wish to modify the behaviour of Takkan for a specific use case.  Takkan uses [get_it](https://pub.dev/packages/get_it) to inject implementations.

This dependency injection allows the developer to replace some parts of Takkan if they so wish, and as a bonus, makes testing easier. 

## Access to Flutter

Takkan intends to make life easier, and Flutter is so flexible it would be inappropriate to prevent the developer from using its full power.

All Takkan 'pages' are based on routes, and the `TakkanRouter` can pass any unrecognised routes to the developer's own router.

It is entirely feasible therefore to just use Takkan for forms and nothing else - or to migrate an existing app gradually.  

## Open Source

It is.  It always will be.


