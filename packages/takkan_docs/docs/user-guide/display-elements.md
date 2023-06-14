# Display Elements

Takkan considers display elements in broad terms - things such as text, images, navigation components.  These are still Widgets,
but composed at a higher level than the Flutter provided Widgets.

## Content and Traits

Regardless of the type of display element, we consider two aspects as:

- content: what is displayed
- trait: how it is displayed, in terms of style and behaviour

A [Trait](traits.md) promotes consistency across an app, through consistent presentation and behaviour of a Widget.


## Text

A typical page will have a mixture of requirements:

- Some text is "static".  It does not change (except in multi-language apps, described in [Internationalization](#internationalization)).
- Some text is dynamic.  It is retrieved from a database, REST API or other sources, and of course will change.  The underlying data type may vary, but the presentation is often text.
- Some text is combination of static and dynamic.  For example, a display of "Hello David" may be a static "Hello" and a dynamic value of the user's name.


Takkan uses an approach similar to a typical Word Processor, by describing text elements as things like "Heading1", "Title" etc.

This may be best illustrated with an example:

### Example

You wish to display the following text. 

"Hello David. You have 5 messages"

Heading3 will give us the appearance we want.  The entry in the Script for this would be:

```
Heading3(
  property: 'count',
  staticData: 'Hello {#user.name}. You have {} messages',
),
```
 
The first parameter "{#user.name}" references the TakkanUser object, but only if the user is logged in.  It will return a "?" if the user cannot be identified.

There are two objects accessible this way, the user object and a system object.  The latter currently just gives you access to the system date but will be expanded.

Note the '#' before these objects.

The second parameter, "{}" refers to the value defined through the 'property' property, in this case the 'count' field of the document.   
 
It will be possible to [use a path](https://gitlab.com/takkan/takkan_client/-/issues/86) to access any element of a document.

## Selectors

A DatePicker or number Spinner are good examples of selectors.

 
## Internationalization

## Defining Traits