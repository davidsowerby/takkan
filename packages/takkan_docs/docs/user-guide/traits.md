# Traits

A [Trait](traits.md) promotes consistency across an app, whether that is the style of presentation, or the behaviour of a Widget.

It builds on Flutter's extensive Theme structure, so any changes made to a theme will be reflected in any defined Traits.

When you compose a Takkan Script, each Part contains a Trait name. The Takkan client looks up the Trait from the Library, and uses it when building the Widget for that Part.

You can use the in-built Trait names, or very simply redefine the implementation of the trait name.  

You will be able to [add your own](#defining-traits) trait names and implementations.