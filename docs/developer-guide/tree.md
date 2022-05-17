# Takkan Tree

`Script` is a tree structure, but is irregular in the sense that child nodes may be declared as lists, maps or individual properties.

The structure is designed to make the script easy for a developer to complete, but makes traversing the tree rather more complicated than usual.

## Walking the Tree

To overcome this irregular structure, every `TakkanItem` defines or inherits a `children` property, which explicitly declares which properties either are, or contain children.

A task specific sub-class of `Walker` can then be used to traverse the tree, either setting or collecting information as it goes.

`InitWalker` is an example of setting values, `ValidationWalker` an example of collecting information.

## Visitor Pattern

The `TakkanItem.walk` method uses the same mechanism, so the children need only be defined once, but in effect follows the standard visitor pattern, where it is the visitors which collect the information required.