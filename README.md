# Precept

A declarative Flutter application framework for use where forms are required

## Objectives

1. Reduce the number of app updates needed, by generating part or all of an app's UI in Flutter using a declarative file sourced from a server.
1. Reduce the effort needed to code page layouts, forms and wizards, by using simplified declarations and re-usable elements.
1. Support multiple backends (for example Parse Server, Firebase)
1. Achieve the above without restricting the developer's access to native Flutter
1. Be Open Source for ever








## Build

``` bash
flutter packages pub run build_runner watch --delete-conflicting-outputs

```

## Build Docs

To build:

```bash
npm run docs:dev
```

If the *node_modules* folder is absent just call npm on its own first

```bash
npm
```