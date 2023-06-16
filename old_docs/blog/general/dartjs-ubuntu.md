---
slug: dart2js-ubuntu
title: Finding dart2js on Ubuntu, Snap install
description: Locating the dart2js executable on a Snap installation of Flutter 
authors: david
date: 2021-10-12
tags: [dart2js, ubuntu, snap]
---

If you want to access the [Dart to Javascript](https://dart.dev/tools/dart2js) compiler (dart2js) on Ubuntu, and you already have [Flutter](https://flutter.dev/) installed via Snap, you will find it at:


``` bash
~/snap/flutter/common/flutter/bin/cache/dart-sdk/bin/dart2js
```

You could then create a link:

``` bash
sudo ln -s  ~/snap/flutter/common/flutter/bin/cache/dart-sdk/bin/dart2js /usr/bin/d2 
```

so it can be executed easily from the command line:

``` bash
dartjs  x.dart
```

 
