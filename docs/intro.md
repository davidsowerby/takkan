---
sidebar_position: 1
---
# Overview

[Flutter](https://flutter.dev/) is an incredibly flexible and powerful framework for creating compelling user interfaces.

However, I found connecting to data repetitive - so I decided to try and improve on that.

The result is something (currently at Proof of Concept stage) which I believe substantially reduces development time for any Flutter project which connects Widgets to data.

## Purpose

Takkan aims to reduce development time, in these broad areas:

1. by automating a substantial amount of the work currently needed to bind Widgets to data,
1. by providing device aware layouts that simplify the construction of pages in a consistent way across an application,
1. by providing Traits (basically styles, but with some behavioural attributes), which enable consistent appearance and behaviour across an application.
1. by defining a schema, which can be used to control presentation epedning on data type and user permissions, and generate server side validation code. 

Equally important, none of these features actually prevent a developer from direct access to Flutter's immense range of features.

Takkan is useful for any app which requires the presentation and editing of data, regardless of how the data is actually presented - whether a standard, boring form, or the slickest, most magical way of presenting data.


:::caution Status

This documentation is written as though functionality already exists, even though it may still be in development.

That's just because it is often easier to capture ideas, document them, and then produce the functionality.

Tap ![status](images/status.svg) to see the current status, or :point_right: to get more detail about the feature.


:::

## Key Features

For each feature, tap the ![status](images/status.svg) icon for the latest status, or :point_right: for more detail.

1. Takkan uses a script (`Script`) to defined the presentation of Widgets.[![status](images/status.svg)](status.md#script)[:point_right:](user-guide/precept-script.md)
1. Traits (similar to styles) are provided to simplify consistent presentation.[![status](images/status.svg)](status.md#traits) [:point_right:](user-guide/traits.md)
1. Various layout schemes are provided[![status](images/status.svg)](status.md#layouts) [:point_right:](user-guide/layouts.md)
1. A schema (`Schema`) defines data structure, roles and permissions.[![status](images/status.svg)](status.md#schema) [:point_right:](user-guide/layouts.md)
1. Data bindings are created automatically, converting data type between model and presentation as needed.[![status](images/status.svg)](status.md#data-bindings) [:point_right:](./user-guide/data-bindings.md)
1. The Edit / Save / Cancel logic is generated automatically (unless an item is read only).[![status](images/status.svg)](status.md#edit-save-cancel) [:point_right:](./user-guide/edit-save-cancel.md)
1. Roles defined by the `Schema` are used to hide / show widgets / pages as appropriate. [![status](images/status.svg)](status.md#roles-control-display) [:point_right:](./user-guide/roles-control-display.md)
1. Validation is defined by the schema and executed by the Widgets assembled by the `Script`. [![status](images/status.svg)](status.md#validation) [:point_right:](./user-guide/validation.md)
1. A backend schema for Back4App can be generated from `Schema`, complete with roles and validation.[![status](images/status.svg)](status.md#server-side-schema-generation) [:point_right:](user-guide/server-side.md)
1. Support for Back4App and generic REST APIs are included, others can be added. [![status](images/status.svg)](status.md#data-providers) [:point_right:](./user-guide/data-providers.md)
1. An app may be updated remotely by revising `Script`.[![status](images/status.svg)](status.md#remote-update) [:point_right:](./user-guide/script-management.md#remote-update)
1. Takkan can be used for just part of an app if required.[![status](images/status.svg)](status.md#partial-use) [:point_right:](./user-guide/partial-use.md)
1. An app can be code generated to avoid any performance loss from interpreting `Script`




:::tip Feedback
There is a lot more work to do, but I would love to hear your opinion - is this project something you might use when it reaches production ready status?

Even better, is it something you would like to contribute to? Whatever your view, I really would be grateful for feedback -  just raise an issue (preferably with a 'feedback' label) in the [takkan_client](https://gitlab.com/precept1/takkan_client) project.
:::

## Monitoring Progress

Sources:

- [status page](./status.md)
- [blog](../../blog)
- [issues](https://gitlab.com/precept1/takkan_client)


