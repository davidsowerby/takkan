---
sidebar_position: 1
---
# Overview

When I started using [Flutter](https://flutter.dev/) I found it to be an incredibly flexible and powerful framework for creating compelling user interfaces.

On the other hand, I found connecting to data repetitive - so I decided to try and improve on that.

The result is something (currently at Proof of Concept stage) which I believe substantially reduces development time for any Flutter project which connects Widgets to data.

:::caution Status

This documentation is written as though certain functionality already exists, even though that it may still be in development.

That's just because it is often easier to capture ideas, document them, and then produce the functionality:

- Tap ![status](images/status.svg) to see the current status, or :point_right: to get more detail about the feature.


:::

## Key Features

For each feature, tap the ![status](images/status.svg) icon for the latest status, or :point_right: for more detail.

1. Precept uses a script (`PScript`) to defined the presentation of Widgets.[![status](images/status.svg)](status.md#script)[:point_right:](user-guide/precept-script.md)
1. Traits (similar to styles) are provided to simplify consistent presentation.[![status](images/status.svg)](status.md#traits) [:point_right:](user-guide/traits.md)
1. Various layout schemes are provided[![status](images/status.svg)](status.md#layouts) [:point_right:](user-guide/layouts.md)
1. A schema (`PSchema`) defines data structure, roles and permissions.[![status](images/status.svg)](status.md#schema) [:point_right:](user-guide/layouts.md)
1. Data bindings are created automatically, converting data type between model and presentation as needed.[![status](images/status.svg)](status.md#data-bindings) [:point_right:](./user-guide/data-bindings.md)
1. The Edit / Save / Cancel logic is generated automatically (unless an item is read only).[![status](images/status.svg)](status.md#edit-save-cancel) [:point_right:](./user-guide/edit-save-cancel.md)
1. Roles defined by the `PSchema` are used to hide / show widgets / pages as appropriate. [![status](images/status.svg)](status.md#roles-control-display) [:point_right:](./user-guide/roles-control-display.md)
1. Validation is defined by the schema and executed by the Widgets assembled by the `PScript`. [![status](images/status.svg)](status.md#validation) [:point_right:](./user-guide/validation.md)
1. A backend schema for Back4App can be generated from `PSchema`, complete with roles and validation.[![status](images/status.svg)](status.md#server-side-schema-generation) [:point_right:](./user-guide/server-side-schema-generation.md)
1. Support for Back4App and generic REST APIs are included, others can be added![progress](images/wip.svg)  
1. An app may be updated remotely by revising `PScript`![progress](images/wip.svg) 
1. Precept can be used for just part of an app if required




:::tip Feedback
There is a lot more work to do, but I would love to hear your opinion - is this project something you might use when it reaches production ready status?

Even better, is it something you would like to contribute to? Whatever your view, I really would be grateful for feedback -  just raise an issue (preferably with a 'feedback' label) in the [precept_client](https://gitlab.com/precept1/precept_client) project.
:::

## Monitoring Progress

Sources:

- [status page](./status.md)
- [blog](../../blog)
- [issues](https://gitlab.com/precept1/precept_client),




