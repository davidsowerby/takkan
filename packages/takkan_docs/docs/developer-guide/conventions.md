# Coding Conventions


## Injections


## Singletons

Singletons are expressed as top level getters

### Without Replacement

If there is no need to allow the developer to replace the implementation, then use this structure:

``` Dart
final PageLibrary _pageLibrary=PageLibrary();
PageLibrary get pageLibrary=> _pageLibrary;
``` 

### With Replacement

If we want the developer to provide an alternative implementation, then there are two steps:

Define in a function called during injector initialisation:

```dart
 getIt.registerSingleton<Wiggly>(DefaultWiggly());
```


```dart
Wiggly get wiggly=> inject<Wiggly>();
```

We have to be mindful here that the injector needs to be set up before `wiggly` is invoked

:::tip 

**Performance**

For something that is called frequently there may be a small performance optimisation from initialising an instance by injection, then using that instance.

That has not been tested though.

:::
