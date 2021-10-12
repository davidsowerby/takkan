---
slug: dart2js-ubuntu
title: Finding Dart2JS on Ubuntu, Snap install
description: Locating the dart2js executable on a Snap installation of Flutter 
authors: david
tags: [dart2js, ubuntu, snap]
---

If you want to access the [Dart to Javascript](https://dart.dev/tools/dart2js) compiler (dart2js) on Ubuntu, and you already have [Flutter](https://flutter.dev/) installed via Snap, you will find it at:


``` bash
~/snap/flutter/common/flutter/bin/cache/dart-sdk/bin/dart2js
```

You could then create a link so it can be executed easily from the command line:

``` bash
sudo ln -s  ~/snap/flutter/common/flutter/bin/cache/dart-sdk/bin/dart2js /usr/bin/d2 
```
