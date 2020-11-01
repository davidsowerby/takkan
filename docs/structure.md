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

A Page also has a one-to-one relationship with a Document (actually represented by an instance `DocumentState`, which holds some meta data as well).

::: tip Note

This does mean that a Page can only display one document.  This can be circumvented by combining documents
in the `Repository` layer.  This was felt to be a reasonable approach, since combining documents would probably require some potentially complex code to retrieve, and transaction handling to update.

:::
  

### Section


### Part
