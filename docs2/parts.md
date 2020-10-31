#  An Introduction to Precept

Flutter is an incredibly flexible and powerful toolset for creating apps on multiple platforms.

Precept attempts to build on that by providing an Application Framework for any app which needs
forms, wizards or even just a consistent layout.

It takes a declarative, JSON based, approach which also enables you to update apps from the server - 
this can be useful when your users are not updating when you want them to!

# Objectives

Precept has the following objectives:

1. Reduce the number of app updates needed, by generating part or all of an app's UI in Flutter using a declarative file sourced from a server.
1. Reduce the amount of effort needed to code page layouts, forms and wizards, by using simplified declarations and re-usable elements.
1. Allow the developer unfettered access to all of Flutter's extensive capabilities
1. Support multiple backends (for example Parse Server, Firebase)
1. Be Open Source for ever

# Overview

Precept takes a structured approach, proving elements above the level of Widgets.  This structure is declared in one or more JSON files,
which is interpreted at run time by Precept code (there's nothing special about Precept code - it's just Flutter / Dart).

## Structure

This is a brief outline of the structure - each element is described in more detail in the Tutorial and in the code.

### Precept Model

### Component

### Route

A route is what it usually is - just a String identifier.  How you use it is up to you, but typically it 
will be something like "user/home".

### Page

A page is what the user perceives as a page on screen, and has a one-to-one relationship with a Route.
You can use the page types provided by Precept or create your own.  Both can be declared in precept files.  

### Section


### Part
