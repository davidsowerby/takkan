# Takkan Schema

## Introduction

The Takkan Schema describes the data structure, data types, validation and permissions of the application.  

In conjunction with the [Takkan Script](takkan-script.md) it provides information to support:

- selection of display dependent ondata type,
- show / hide controls depending on user access rights
- enable / disable editing depending on user access rights,
- the same validation logic on both client and server (by using [server schema generation](server-side.md))

## Structure

Takkan has an objective to support multiple backends.  That presents a potential problem with terminology, since the backend could be any variation of NoSQL, RDBMS and possibly other things to.

The terminology used by the Schema is incredibly simple, and it is up to an implementation of `BackendDelegate` to translate that for a specific backend.


| Term      | Description                                                    |
|-----------|----------------------------------------------------------------|
| Schema   | A schema definition                                            |
| PDocument | Equivalent to a JSON document                                  |
| PField    | Abstract, database field, sub-classed for different data types |                                                                                                  | Field     | Field |


When combined with the [Takkan Script](takkan-script.md), the overall structure depicted in the diagram below:

:::tip Note
This does not show all Widgets, just those immediately relevant to the script and the schema.

For more on Widgets, see the [Widget Tree](./widget-tree.md)

::: 


![overview diagram](../images/takkan-overview.svg)

## Implementation

The schema is interpreted to suit a specific architecture by a `BackendDelegate` implementation.

Takkan itself does not care how or where the data is stored, provided it comes back in the form declared by the `Schema`.

`PField` comes in a number of different implementations, representing different data types.

An additional `PField` type is `PPointer`, which describes a relationship to one or more other `PDcouments`, using `DocumentId`s
 
This covers 1-n relationships, while a nested document can of course only be 1-1.

When a `PPointer` has more than one target is becomes equivalent to a Back4App (Parse Server) Relation, but it is up to the `BackendDelegate` implementation to determine that.


## Version Control

[Script](takkan-script.md) and `Schema` are version numbered to help ensure consistency.

A version is a simple incrementing integer.

## Schema

The schema is provided by the *takkan_script* package, as shown in the [dependencies diagram](./installation.md#dependencies).

Multiple schema JSON files can be loaded via the `Takkan` instance. There needs to be at least one schema, unless the app is completely static.

A `PDocument` (the schema for a specific document type) is declared within a `PQuery`, and merged into a single `Schema` by `Takkan`.

There are options to allow pre-loading or on-demand loading. [:thinking:](https://gitlab.com/takkan/precept-client/-/issues/25)

Each `PDocument` is loaded by an implementation of `TakkanLoader`, typically from the app's primary backend, but it can be from anywhere.


## PDocument

This is the equivalent of, and represented by a nestable JSON document, regardless of how simple or complex it is.  

From a Takkan point of view, it is something which would be retrieved from a data source to display as a [Page](takkan-script.md#page), [Panel](takkan-script.md#panel) or [Part](takkan-script.md#part).


## PField

A `PField` is an abstract class representing a "database" field, and also includes a `PPointer` which declares a relationship with one or more other documents.
 
It is used by a Takkan Script Particle [PParticle](takkan-script.md#particle).


### Implementations

There are 3 broad categories of `PField`:

- Simple field, for example `PInteger`, `PString` - the usual primitive types, plus some additional types, including `PPointer`, `PGeoPosition`
- List field, for example `PListInteger`, `PListBoolean`.  These cover all the simple fields, plus there is a specific implementation of `PGeoRegion`, which a list of `PPosition` but considered to make up a geographic region.
- Select field, for example `PSelectString`.  This defines one or more values to be picked from a set of options.  Currently this requires the options to be declared in the `Script`


