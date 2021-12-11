# Brief Tutorial

Provides a step by step guide to building the Precept sample app but does not give much in the way
of explanation. If you want more information, see the [detailed version](detailed.md)

:::caution

**Early Stage Development**

Precept is at Proof of Concept stage, and it has bugs and missing functionality. It is hoped that
this tutorial and accompanying video will generate enough interest to push the project forward even faster to remedy these limitations.
:::

## Assumptions

You are using Android Studio (with apologies to anyone using any other IDE).

## Prior knowledge

It would be helpful but not essential to have some knowledge of:

- Flutter
- GraphQL
- Back4App 

## Initialiise the App

Steps to [init](init.md) the app.

## Create a Flutter App

File | New | New Flutter Project



:arrow_forward: Run the app

:white_check_mark:  Make sure it works.

## Install the Package

// TODO

## Step 01 - Hello World

- Completely replace the contents of *main.dart* with:

```dart
import 'package:flutter/material.dart';
import 'package:precept_client/app/app.dart';
import 'package:precept_client/app/loader.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_tutorial/app/config/precept.dart';

void main() async {
  await precept.init(
    loaders: [
      DirectPreceptLoader(script: myScript),
    ],
  );
  final ThemeData theme = ThemeData(
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  runApp(PreceptApp(theme: theme));
}

```

- delete the test file *widget_test.dart*
- create folder *lib/app/config*
- create file *lib/app/config/precept.dart*
- create a *precept.json* in project root, containing just empty braces:

```json
{}
```

- in pubspec.yaml, replace:

```yaml
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg
```

with:

```yaml
  assets:
    - precept.json
```

- paste the following into *lib/app/config/precept.dart*:

```dart
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/part/text.dart';


final myScript = PScript(
  name: 'Tutorial',
  routes: {
    '/': PPage(
      title: 'Home Page',
      content: [
        PText(
          readTraitName: PText.title,
          isStatic: IsStatic.yes,
          staticData: 'Precept',
        ),
      ],
    ),
  },
);
```

:arrow_forward:

:white_check_mark:  It should look like this:

![start](images/step01.png)

<details>
  <summary>Explanation</summary>
  <div>
    <div>These are the details</div>
  </div>
</details>

[detail](detailed.md#step-01---hello-world)

## Step 02 - Styling text

- Update *precept.dart* to show text element with different traits, and add a `PNavButton`

```dart {18-32}
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/part/navigation.dart';


final myScript = PScript(
  name: 'Tutorial',
  routes: {
    '/': PPage(
      title: 'Home Page',
      content: [
        PText(
          readTraitName: PText.title,
          isStatic: IsStatic.yes,
          staticData: 'Precept',
        ),
        PText(
          readTraitName: PText.subtitle,
          isStatic: IsStatic.yes,
          staticData: 'Proof of Concept',
        ),
        PText(
          readTraitName: PText.strapText,
          isStatic: IsStatic.yes,
          staticData: 'A brief introduction to faster Flutter development',
        ),
        PNavButton(
          isStatic: IsStatic.yes,
          staticData: 'OK',
          route: 'chooseList',
        ),
      ],
    ),
  },
);
```

:arrow_forward:

:white_check_mark:  It should look like this:

![start](images/step02.png)

:white_check_mark: Tapping the 'OK' button will go to error page, as the 'chooseList' route is not
yet defined.

## Step 03 - Navigation Page

A simple page construct for users to choose where to go.

Route 'chooseList' added, with `PNavButtonSet` providing list of routes for user to select.

- Update *precept.dart* to:

```dart {35-48}
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/layout.dart';
import 'package:precept_script/part/navigation.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/script/script.dart';

final myScript = PScript(
  name: 'Tutorial',
  routes: {
    '/': PPage(
      title: 'Home Page',
      content: [
        PText(
          readTraitName: PText.title,
          isStatic: IsStatic.yes,
          staticData: 'Precept',
        ),
        PText(
          readTraitName: PText.subtitle,
          isStatic: IsStatic.yes,
          staticData: 'Proof of Concept',
        ),
        PText(
          readTraitName: PText.strapText,
          isStatic: IsStatic.yes,
          staticData: 'A brief introduction to faster Flutter development',
        ),
        PNavButton(
          isStatic: IsStatic.yes,
          staticData: 'OK',
          route: 'chooseList',
        ),
      ],
    ),
    'chooseList': PPage(
      layout: PPageLayout(margins: PMargins(top: 50)),
      title: 'Select List to View',
      content: [
        PNavButtonSet(
          buttons: {
            'Open Issues': 'openIssues',
            'Closed Issues': 'closedIssues',
            'Search Issues': 'search',
            'Account': 'account',
          },
        ),
      ],
    ),
  },
);
```

:arrow_forward:

- tap OK.

:white_check_mark: It should look like this:

![start](images/step03.png)

- tap 'Open Issues'. It will fail because the 'openIssues' route is not defined. All the buttons
  will fail for this reason.

## Step 04 - Creating Database

We need a backend now to demonstrate data retrieval.

We will use Precept to generate the Back4App schema and populate some test data.

[:point_right:](detailed.md#step-04---page-with-query)

### Create Back4App instance

- Create a [Back4app](https://www.back4app.com/) instance
- Note the application and client keys

### Generate Back4App schema

### Populate test data

### Set up Precept to display data

We need a Precept `PDataProvider` to support the query, and an 'openIssues' route to display it.

- Update *precept.dart* to be:

<<< docs/tutorial/step04/precept.dart{16-22,63-84}

- Install the **precept_back4app** package:

?????????

- Update *main.dart* to register Back4App **before** precept.init

<<< docs/tutorial/step04/main.dart{9-9}

- Create a schema for this `DataProvider`, at *lib/app/config/schema.dart*:

<<< docs/tutorial/step04/schema.dart

- Create the query in at *lib/app/query/issue.dart*:

<<< docs/tutorial/step04/issue.dart

- Update *precept.json* with the keys from your Back4App instance:

<<< docs/tutorial/step04/precept.json

:arrow_forward:

- tap OK.
- tap 'Open Issues'.

:white_check_mark: This will fail again, but this time because it will be looking for the 'signin'
route, which we have not yet defined.

## Step 05 - Authentication and Permissions

- Update *precept.dart* to:

[![Boo](images/notes.svg)](detailed.md#step-04---page-with-query)
