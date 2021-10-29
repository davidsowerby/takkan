---
slug: validation-schema-generate
title: Validation and Schema Generation
description: Improved validation, automatic Back4App schema generation
authors: david
date: 2021-10-12
tags: [precept, freezed, validation, back4app]
---

## Validations

Part of the challenge with Precept is to make sure that defining an application remains simple, and clear.

With the help of the [freezed](https://pub.dev/packages/freezed) package, field validations are now defined clearly, for example:

``` dart {7-10}
final schema = PSchema(name: 'kitchenSink', documents: {
  'Account': PDocument(
    fields: {
      'category': PString(
        validations: [
          VString.longerThan(2),
          VString.shorterThan(5),
        ],
      ),
    },
  ),
});

```


## Back4App Schema

I am using the term 'schema' loosely here.  The intention is that Precept automates the process of setting up the backend of an application from the same definition provided for the front end.

This means generating a real Back4App schema, but also requires the generation of Javascript validation code for the `beforeSave` methods of Back4App classes.

Both the real Back4App schema and the and validation code can now be generated automatically, although the range of validations currently defined is extremely small.

Next step is to look at whether dart2js can improve the way this is done.

### Deployment

Deployment of the schema is critical as changing any backend schema can easily break the whole app if done incorrectly.

A schema update will also need to be synchronised with validation code deployment, so that there is no mis-match between schema and validation.

I am not sure yet whether that can be achieved without at least some delay between the two steps, so may need conditional code to get round it.

By "conditional"  I mean the validation code would need to detect the schema version, and provide alternative validation if required.

At the moment, the generated validation code does not do that.