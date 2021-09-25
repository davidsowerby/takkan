# Status

The main features of Precept are listed in the [Overview](intro.md#key-features), and repeated here with a brief summary of their current status.

## Last updated

2021-09-23

## Changes since last update
<body bgcolor="#ffff66">Changes from the last update are highlighted.</body>


## Features

## Script

:::tip Feature
*Precept uses a script (`PScript`) to select and display Widgets, and a schema (`PSchema`) to define data structure and permissions.*
:::

The structure of both `PScript` and `PSchema` are now fairly mature, although there may be some additions to come.

Both can be loaded either directly from code, or via http.

Multiple `PScript` instances (inclduing contained `PSchema` instances ) can be combined into a single script, making modular construction possible.

Pages containing Panels and Parts are defined by `PScript` and assembled automatically.

## Layout Schemes

:::tip Feature
*Various layout schemes are provided*
:::
 
This has not moved from the idea stage.  There is currently only one, very simple layout available.  [Open issue](https://gitlab.com/precept1/precept_client/-/issues/62).

## Schema


## Data Connections

:::tip Feature
*Data connections are created automatically, converting data type between model and presentation as needed.*
:::

This is almost complete.  A current document is maintained for editing, with data bindings linking from that document to a Widget for display.

Where required (for example to display an integer in a `Text`), the data type is automatically converted.

Bindings for some Geo data types [outstanding](https://gitlab.com/precept1/precept_client/-/issues/45).

## Edit Save Cancel

:::tip Feature
*The Edit / Save / Cancel logic is generated automatically (unless of course an item is read only)*
:::

The logic for this generally works through there is a [bug](https://gitlab.com/precept1/precept_client/-/issues/52) with keeping the display in sync withthe edit state.

There is also a need to [improve the presentation](https://gitlab.com/precept1/precept_client/-/issues/69) of this feature, and provide the developer with some options.

## Roles control display

:::tip Feature
*Roles defined by the `PSchema` are used to hide / show widgets / pages as appropriate. *
:::

Some elements of this are working, but this really needs thorough [testing](https://gitlab.com/precept1/precept_client/-/issues/70).

