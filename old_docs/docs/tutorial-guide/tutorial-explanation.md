# Detailed Tutorial

A detailed step by step guide to developing a Takkan app. IF you prefer, there is also
a [brief version](tutorial.md)

:::caution

**Early Stage Development**

Takkan is at Proof of Concept stage, and it has bugs and missing functionality. It is hoped that
this tutorial and accompanying video will generate enough interest to push the project forward even faster to remedy these limitations.
:::

## Assumptions

You are using Android Studio (with apologies to anyone using any other IDE).

## Prior knowledge

It would be helpful but not essential to have some knowledge of:

- Flutter
- GraphQL

## Conventions

Steps that requires an action from you are marked with a bullet point or a symbol:

- Do something

:arrow_forward: Restart the app  (using either run or debug)

:zap:  Hot reload the app

:white_check_mark: Check something has happened

### Import statements

**import** statements may be shown with sample code. The IDE will usually find the imports, but not
always. Place imports at the top of the file

## Install the Package

// TODO

## Create a new App

- Create a new App in Android Studio, File | New | New Flutter Project

:arrow_forward: Run the app

:white_check_mark:  Make sure it works.

## Step 01 - Hello World

Now we know that the environment is set up correctly, we can prepare a Takkan app.

We'll construct the equivalent of a "Hello World" app, and then explain how it has been set up.

### Replace generated example

- Completely replace the contents of *main.dart* with:

<<< ../takkan_tutorial/lib/main.dart


- delete the test file *widget_test.dart*
- create folder *lib/app/config*
- create file *lib/app/config/takkan.dart*
- paste the following into *lib/app/config/takkan.dart*:

```dart
import 'package:takkan_script/common/script/common.dart';
import 'package:takkan_script/part/navigation.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/part/text.dart';


final myScript = Script(
  name: 'Tutorial',
  pages: {
    '/': Page(
      title: 'Home Page',
      content: [
        PText(
          readTraitName: PText.title,
          isStatic: IsStatic.yes,
          staticData: 'Takkan',
        ),
        PNavButton(
          staticData: 'OK',
          route: 'chooseList',
        ),
      ],
    ),
  },
);
```

:arrow_forward: Run the app and it should look like this:

![start](images/step01.png)

### Explanation

Takkan uses a `Script` object to define what is displayed. This is what is defined in the *
takkan.dart* file.

In practice, this definition expected to be retrieved from a remote server somewhere, as a JSON
file, but during early development stages, it is simpler to use the `Script` object directly.

These are the properties of `Script` we have defined so far:

#### name

Obvious, but also necessary because it is possible to merge multiple `Script` files together, so a
Takkan application could be defined in a modular way.

#### pages

A Takkan app is a collection of pages, each mapped to a 'route'.

Our route '/' is mapped to a `Page` page definition. The route can be any valid string.

#### page title

Again obvious, and is displayed at the top of the page.

#### page content

Page content is the definition of what is to be displayed within the page. In our example so far,
these are a `PText` and a `PNavButton`.

These are both instances of `Part`, but we will come back to that later. For the moment, just
remember that all of these elements prefixed with 'P' are interpreted by Takkan into an equivalent
Widget - for example a `Part` becomes a `Part` Widget.

##### PText element

Most `Part` types, including `PText`, support a read and an edit mode, potentially using completely
different Widgets. There is also an associated 'traitName'  (think 'styleName' - it would have been
called 'style' but Flutter already uses that term a lot). In this case it is the trait
name `PText.title`.

The `isStatic` property declares that this Part holds static data - that is, it is not connected to
dynamic data, and `staticData` holds that data.

:::tip

**Internationalization**

Takkan takes a different approach to most applications. It
uses a different Script instance for each language supported, removing the need for the client to
do the translation at run time. The appropriate language instance will be loaded for the client's
selected locale.
:::

##### PNavButton

A 'navigation button' this simply navigates to the specified route when the button is tapped. If you
do that now, an error page will be shown, as we have not created the other pages yet.

This is a case where a `Part` only has a read state - you wouldn't want the user to edit the button.

It still needs to have it's label text set through `staticData` but `isStatic` is `isStatic.yes` by
default.

## Step 02 - Styling text

Takkan uses the term 'trait' rather than 'style'. This is mainly because Flutter uses 'style' a lot
already, but also because in Takkan's case the trait may also define behaviour as well as
appearance.

Traits use the existing [Theme](https://flutter.dev/docs/cookbook/design/themes) functionality of
Flutter.

### Add a Text element

To demonstrate traits let's add a couple of `PText` elements using different traits.

????????????????????????????????????

## Step 03 - Navigation Page

We are now going to develop a very simplistic issue management system, to demonstrate Takkan's
features.

We will start with a 'Navigation Page', whose only purpose is to allow the user to navigate to other
pages by tapping on their chosen button.

????????????????????????

## Step 04 - Page with query

Now let's provide a listing of open issues. Takkan uses GraphQL, because it opens up the option to
have the developer define any query within the `Script` object.

There is support for REST, but that is more limited.

### Inheritance principle

Takkan works on an 'inheritance' model, where elements declared higher in the tree are available to
elements lower down the tree. If an element is then redeclared at a lower level, that declaration
will then override the one made higher up the tree.

### The Data Provider

The inheritance model described above is relevant now that we want to add a Data Provider.

### The Query

It is not essential to separate the query text, but it does make things more readable.

### Background

One of the original motivations behind Takkan was the desire to simplify connecting Widgets to
data, and reduce the coding needed to edit and save data.

Takkan provides support for GraphQL and REST interaction with backend services (called 'Data
Providers' in Takkan).

Takkan is designed to enable multiple Data Providers, but currently aims
at [Back4App](https://www.back4app.com/) and generic REST services.

### Connecting a query

--------------------------------
=================================

We have not told Takkan what it needs to display yet, so that's the next step.

A Takkan App is defined by JSON files:

- `Script` instances define the user interface
- `Schema` instances define the data and validation rules

:::tip

Multiple `Script` files can be used and merged, but we will keep the Tutorial simple with just one.

:::

These JSON files usually start life as Dart code, and that is what we will use here. To prepare:

- create file *lib/app/config/schema.dart*

:::tip 
Note The `Script` and `Schema` definitions do not have to be separated, it just makes it a
bit easier to manage
:::

- paste the following into *takkan.dart*

```dart


```

### Load Your Scripts

We now have to tell Takkan which scripts to use, and where to find them.

Normally, Takkan JSON files are loaded via HTTP from the cloud somewhere, but during development it
is simpler to load them from a local declaration.

To do that, we instantiate the appropriate implementation of `TakkanLoader`.

In this case, we will load them with an instance of `DirectTakkanLoader`, meaning they are loaded
directly from their declaration.

- In *main.dart*, change the **main()** method to be:

``` dart
void main() async {
  await takkan.init(
    loaders: [
      DirectTakkanLoader(script: myScript),
    ],
  );
  runApp(MyApp());
}

```

- :arrow_forward: Run the app

- :white_check_mark:  Make sure it looks like this:

:::tip

**Dependency Injection**

Takkan uses [get_it](https://pub.dev/packages/get_it) for dependency injection. If you are not
familiar with it, it may be worth taking a look at their documentation but you do not need to do
that now.

If you already know something like Guice or Dagger, the concepts are very similar.

:::

- create an empty file *takkan.json* in the project root