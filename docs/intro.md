---
sidebar_position: 1
---
# Overview

[Flutter](https://flutter.dev/) is, IMO, incredibly flexible and powerful in creating compelling user interfaces.

On the other hand, I found connecting to data a bit repetitive and boring, so I decided to try and improve on that.

That resulted in something (currently at Proof of Concept stage) which I believe substantially reduces development time for any Flutter project which connects Widgets to data.

There is a lot more work to do, but I would love to hear your opinion - is this project something you might use when it reaches production ready status?

Even better, is it something you would like to contribute to?

:::caution

In some places, this documentation is written as though certain functionality already exists, even though that is not yet the case.  

That's just because it is often easier to capture ideas, document them, and then produce the functionality:

- ![idea](images/idea.svg) indicates that so far, this is just an idea, but is linked to an open issue.
- ![progress](images/wip.svg) indicates that work has started and will link to something describing the current status (usually an issue).
- :point_right: just means "see details" but looks prettier :smiley_cat:


:::

## Key Features

For each feature, tap the ![status](images/status.svg) icon for the latest status, or :point_right: for more detail.

1. Precept uses a script (`PScript`) to defined the presentation of Widgets.[![status](images/status.svg)](status.md#script)[:point_right:](user-guide/precept-script.md)
1. Traits (think 'styles') simplify consistent presentation.
1. Various layout schemes are provided ![idea](images/idea.svg)
1. A schema (`PSchema`) defines data structure, roles and permissions.[![status](images/status.svg)](status.md#schema)
1. Data connections are created automatically, converting data type between model and presentation as needed.![progress](images/wip.svg) 
1. The Edit / Save / Cancel logic is generated automatically (unless an item is read only).
1. Roles defined by the `PSchema` are used to hide / show widgets / pages as appropriate. 
1. Validation is defined by the schema and executed by the Widgets assembled by the `PScript`.
1. A backend schema for Back4App can be generated from `PSchema`, complete with roles and validation.![progress](images/wip.svg) 
1. Support for Back4App and generic REST APIs are included - the design does allow for development of packages for other data providers (eg Firebase)  ![progress](images/wip.svg)  
1. An app may be updated remotely by revising `PScript`![progress](images/wip.svg) 
1. Precept can be used for just part of an app if required

## Monitoring Progress

Sources:

- [status page](./status.md)
- [blog](../../blog)
- [issues](https://gitlab.com/precept1/precept_client),




