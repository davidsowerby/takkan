# Precept Schema

## Introduction

The Precept Schema describes the data structure, data types, validation and permissions.  

It supports the [Precept Script](precept-script.md) by providing data type information, validation, and user permissions.

On the client side, the Schema is not about security, but usability.

One day the Precept Schema will also be used to create the server side schema and permissions :crossed_fingers:

:::caution

**Security**

The Precept client does not provide security.  It is designed with the simple premise that nothing from a client can be trusted.

If you want proper security, validation and access control must be provided by the server - but that's true for any client.

:::

## Structure

Precept has an objective to support multiple backends.  That presents a potential problem with terminology, since the backend could be any variation of NoSQL, RDBMS and possibly other things to.

The terminology used by the Schema is incredibly simple, and it is up to an implementation of `BackendDelegate` to translate that for a specific backend.


| Term      | Description                                                    |
|-----------|----------------------------------------------------------------|
| PSchema   | A schema definition                                            |
| PDocument | Equivalent to a JSON document                                  |
| PField    | Abstract, database field, sub-classed for different data types |                                                                                                  | Field     | Field |


When combined with the [Precept Script](./precept-script.md), the overall structure depicted in the diagram below:

::: tip Note
This does not show all Widgets, just those immediately relevant to the script and the schema.

For more on Widgets, see the [Widget Tree](./widget-tree.md)

::: 


![overview diagram](../images/precept-overview.svg)

## Implementation

The schema is interpreted to suit a specific architecture by a `BackendDelegate` implementation.

Precept itself does not care how or where the data is stored, provided it comes back in the form declared by the `PSchema`.

`PField` comes in a number of different implementations, representing different data types.

An additional `PField` type is `PPointer`, which describes a relationship to one or more other `PDcouments`, using `DocumentId`s
 
This covers 1-n relationships, while a nested document can of course only be 1-1.

When a `PPointer` has more than one target is becomes equivalent to a Back4App (Parse Server) Relation, but it is up to the `BackendDelegate` implementation to determine that.


## Version Control

[PScript](./precept-script.md) and `PSchema` are version numbered to help ensure consistency.

A version is a simple incrementing integer.

## PSchema

The schema is provided by the *precept_script* package, as shown in the [dependencies diagram](./installation.md#dependencies).

Multiple schema JSON files can be loaded via the `Precept` instance. There needs to be at least one schema, unless the app is completely static.

A `PDocument` (the schema for a specific document type) is declared within a `PQuery`, and merged into a single `PSchema` by `Precept`.

There are options to allow pre-loading or on-demand loading. [:thinking:](https://gitlab.com/precept1/precept-client/-/issues/25)

Each `PDocument` is loaded by an implementation of `PreceptLoader`, typically from the app's primary backend, but it can be from anywhere.


## PDocument

This is the equivalent of, and represented by a nestable JSON document, regardless of how simple or complex it is.  

From a Precept point of view, it is something which would be retrieved from a data source to display as a [Page](./precept-script.md#page), [Panel](./precept-script.md#panel) or [Part]((./precept-script.md#part)).


## PField

A `PField` is an abstract class representing a "database" field, and also includes a `PPointer` which declares a relationship with one or more other documents.
 
It is used by a Precept Script Particle [PParticle](./precept-script.md#particle).


### Implementations

There are 3 broad categories of `PField`:

- Simple field, for example `PInteger`, `PString` - the usual primitive types, plus some additional types, including `PPointer`, `PGeoPosition`
- List field, for example `PListInteger`, `PListBoolean`.  These cover all the simple fields, plus there is a specific implementation of `PGeoRegion`, which a list of `PPosition` but considered to make up a geographic region.
- Select field, for example `PSelectString`.  This defines one or more values to be picked from a set of options.  Currently this requires the options to be declared in the `PScript`


