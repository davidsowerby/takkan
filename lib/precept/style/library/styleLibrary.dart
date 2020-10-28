import 'package:flutter/foundation.dart';
import 'package:precept/inject/inject.dart';

enum StandardStyle { defaultStyle }

class StyleLibrary {
  final List<StyleLibraryModule> modules;

  const StyleLibrary({@required this.modules});

  Style findStyle(Object key) {
    for (var module in modules) {
      final result = module.findStyle(key);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}

abstract class StyleLibraryModule {
  final Type keyType;

  const StyleLibraryModule({@required this.keyType});

  Style findStyle(Object key) {
    if (key.runtimeType == keyType) {
      return doFindStyle(key);
    }
    return null;
  }

  Style doFindStyle(Object key);
}

class PreceptStyleLibraryModule extends StyleLibraryModule {
  PreceptStyleLibraryModule() : super(keyType: StandardStyle);

  @override
  Style doFindStyle(Object key) {
    final StandardStyle k = key;
    switch (k) {
      case StandardStyle.defaultStyle:
        return Style();
      default:
        return null;
    }
  }
}

StyleLibrary get styleLibrary => inject<StyleLibrary>();

class Style {}
