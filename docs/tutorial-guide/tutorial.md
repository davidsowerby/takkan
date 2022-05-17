# Tutorial

Provides a step by step guide to building the Takkan sample app but does not give much in the way
of explanation. If you want more information, see the [detailed version](tutorial-explanation.md)

:::caution

**Early Stage Development**

Takkan is at Proof of Concept stage, and it has bugs and missing functionality. It is hoped that
this tutorial and accompanying video will generate enough interest to push the project forward even faster to remedy these limitations.
:::

## Assumptions

You are using Android Studio (with apologies to anyone using a different IDE).

## Prior knowledge

It would be helpful but not essential to have some knowledge of:

- Flutter
- GraphQL
- Back4App 


## Create a Flutter App

In Android Studio, 

- File | New | New Flutter Project
- Select 'Flutter' on the left
- Next
- enter 'myapp' as the project name
- Finish


This will provide a copy of the default sample Flutter application, which we will modify later.

:arrow_forward: Run the app

:white_check_mark:  Make sure it works.

## Prepare Server

- Follow the steps to [prepare back4app](prepare-back4app.md).  

- Note the App Id and Client Key from the Back4App instance you have just created.  (Server settings | Core Settings)  


## Set up Takkan on Client

### Create takkan.json

- Create an [application configuration file](../user-guide/app-configuration.md), *takkan.json* in the project root.
- Copy the App Id and Client Key from your Back4App instance, and place into the JSON structure below.


```json
{
  "main": {
    "type": "back4app",
    "dev": {
      "headers": {
        "X-Parse-Application-Id": "your App Id",
        "X-Parse-Client-Key": "Your Client Key"
      }
    }
  }
}
```

- Add *takkan.json* to .gitignore (We do not want to commit keys to the repository)

### Takkan dependencies

- in pubspec.yaml, add dependencies:

```yaml
  takkan_client:
    path: ../takkan_client
  takkan_script:
    path: ../takkan_script
  takkan_backend:
    path: ../takkan_backend
  takkan_back4app_client:
    path: ../takkan_back4app_client
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
    - takkan.json
```

- Run 'pub get'


## Step 01 - Hello World

- delete the test file *widget_test.dart*
- create a file *lib/app/config/takkan.dart* containing:

```dart
import 'package:takkan_script/common/script/common.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/part/text.dart';
import 'package:takkan_script/script/version.dart';

final myScript = Script(
  name: 'Tutorial',
  version: const PVersion(number: 0),
  routes: {
    '/': Page(
      title: 'Home Page',
      content: [
        PText(
          readTraitName: PText.title,
          isStatic: IsStatic.yes,
          staticData: 'Takkan',
        ),
      ],
    ),
  },
  schema: Schema(
    name: 'Tutorial Schema',
    version: const PVersion(number: 0),
  ),
);

```
This script is what will define our application.

<details>
  <summary>Explanation</summary>
  <div>
    <div>Our first page will have purely static data, so we do not need a schema yet</div>
  </div>
</details>

- In *main.dart*, leave `MyHomePage` as it is but replace the `main()` method and `MyApp` with:

```dart
import 'package:flutter/material.dart';
import 'package:takkan_client/app/app.dart';
import 'package:takkan_client/app/loader.dart';
import 'package:takkan_client/app/takkan.dart';
import 'package:takkan_tutorial/app/config/takkan.dart';

void main() async {
  await takkan.init(
    loaders: [
      DirectTakkanLoader(script: myScript),
    ],
  );
  final ThemeData theme = ThemeData(
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  runApp(TakkanApp(theme: theme));
}

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

[detail](tutorial-explanation.md#step-01---hello-world)

## Step 02 - Styling text

- Update *takkan.dart* to show text element with different traits, and add a `PNavButton`

```dart {18-32}
import 'package:takkan_script/common/script/common.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/part/text.dart';
import 'package:takkan_script/part/navigation.dart';


final myScript = Script(
  name: 'Tutorial',
  routes: {
    '/': Page(
      title: 'Home Page',
      content: [
        PText(
          readTraitName: PText.title,
          isStatic: IsStatic.yes,
          staticData: 'Takkan',
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

- Update *takkan.dart* to:

```dart {35-48}
import 'package:takkan_script/common/script/common.dart';
import 'package:takkan_script/common/script/layout.dart';
import 'package:takkan_script/part/navigation.dart';
import 'package:takkan_script/part/text.dart';
import 'package:takkan_script/script/script.dart';

final myScript = Script(
  name: 'Tutorial',
  routes: {
    '/': Page(
      title: 'Home Page',
      content: [
        PText(
          readTraitName: PText.title,
          isStatic: IsStatic.yes,
          staticData: 'Takkan',
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
    'chooseList': Page(
      layout: PageLayout(margins: PMargins(top: 50)),
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

We will use Takkan to generate the Back4App schema and populate some test data.

[:point_right:](tutorial-explanation.md#step-04---page-with-query)

### Create Back4App instance

- Create a [Back4app](https://www.back4app.com/) instance
- Note the application and client keys

### Generate Back4App schema

### Populate test data

### Set up Takkan to display data

We need a Takkan `DataProvider` to support the query, and an 'openIssues' route to display it.

- Update *takkan.dart* to be:

<<< docs/tutorial/step04/takkan.dart{16-22,63-84}

- Install the **takkan_back4app** package:

?????????

- Update *main.dart* to register Back4App **after** takkan.init

<<< docs/tutorial/step04/main.dart{9-9}

- Create a schema for this `DataProvider`, at *lib/app/config/schema.dart*:

<<< docs/tutorial/step04/schema.dart

- Create the query in at *lib/app/query/issue.dart*:

<<< docs/tutorial/step04/issue.dart

- Update *takkan.json* with the keys from your Back4App instance:

<<< docs/tutorial/step04/takkan.json

:arrow_forward:

- tap OK.
- tap 'Open Issues'.

:white_check_mark: This will fail again, but this time because it will be looking for the 'signin'
route, which we have not yet defined.

## Step 05 - Authentication and Permissions

- Update *takkan.dart* to:

[![Boo](images/notes.svg)](tutorial-explanation.md#step-04---page-with-query)
