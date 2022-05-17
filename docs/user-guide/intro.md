---
sidebar_position: 1
---


# Overview

If you have not already, is is worth looking at the [Takkan Overview](../intro.md), which provides a summary of Takkan's features.

:::caution

This document is written as though functionality exists, even when it is still in development.  Linked tasks can be viewed via the icons. 

:::


## View and Model

Both the view, or presentation layer, and the model, or data, layer are defined by scripts.

## Scripts

A `Script` provide a definition of what is to be displayed.  Within it, there are also definitions for [Data Providers](data-providers.md).  "Data Providers" is a general term for anything you might get data from. It could be your main application backend or a public REST API.

Ultimately there is a single `Script` per app - although that single `Script` may be created by merging multiple `Script` instances to support modularity.

Simplistically, Takkan acts as an interpreter of the `Script` in order to provide the app itself.



### Loading Scripts

The scripts themselves can be loaded using a `RestLoader` [![task](../images/task.png)](https://gitlab.com/precept1/takkan_client/-/issues/78) to retrieve the script from server, or a `DirectLoader`.

A `DirectLoader` just takes a locally defined variable and loads it - useful during development to avoid having to push the script to a server and then call it back again.

Scripts are generally cached locally to enable offline working.  [![task](../images/task.png)](https://gitlab.com/precept1/takkan_client/-/issues/76) This does depend on the device the app is running on. 


### Version Control


Since changing a script changes functionality, scripts have versions to keep control.  [![task](../images/task.png)](https://gitlab.com/precept1/takkan_client/-/issues/74) 


### Internationalization

Takkan takes a slightly different approach to supporting multiple Locales. Instead of using a translation routine on the client, a script holds the appropriate I18N patterns as part of the script - a different script instance for each supported Locale.

This reduces the amount of translation needed on the client, although interpolation [![task](../images/task.png)](https://gitlab.com/precept1/takkan_client/-/issues/79) of values, where required, can still only be carried out on the client.  [![task](../images/task.png)](https://gitlab.com/precept1/takkan_client/-/issues/75) 

## Pages, Panels and Parts

`Script` defines `PPage` instances.  A `PPage` instance contains `PPanel` and `PPart` instances.  A `PPanel` may contain further `PPanel` instances, or `PPart` instances.

A `PPart` is simply a pair of Widgets, one for reading and one for editing data.  This supports the generation of automatic [Edit-Save-Cancel](edit-save-cancel.md) logic. 


## The Build Process

`Script` defines pages mapped to routes (where a route is just a String identifier).  The route may be generated automatically from the data being displayed, or explicitly declared as a route-page mapping.

When a `TakkanPage` is constructed it assembles its Panels and Parts as defined by `Script`.  In doing so, it also creates [data bindings](data-bindings.md) from the resultant Widgets to the data held in the [DocumentCache](document-cache.md).  The bindings also trigger any [validation](validation.md) defined by `Schema`.

The data is identified by the `PDataProvider` and `Schema` associated with the page.  


## Use with non-Takkan pages

One of Takkan's primary objectives is not to get in the way of the developer wanting to use Flutter directly.

Takkan offers two ways of merge Takkan and non-Takkan parts of an app.


1. The `TakkanRouter` configuration, `TakkanRouterConfig`, allows for an [alternate router](partial-use.md#alternate-router) 

1. Takkan Panels can be embedded in any page.  [![task](../images/idea.svg)](https://gitlab.com/precept1/takkan_client/-/issues/77) 