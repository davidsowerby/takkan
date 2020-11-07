import 'package:flutter/foundation.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/part/part.dart';
import 'package:precept/precept/part/string/stringPart.dart';

enum StandardPart { StringPart }

class PartLibrary {
  final List<PartLibraryModule> modules;

  const PartLibrary({@required this.modules});

  Part findPart(Object key) {
    for (var module in modules) {
      final result = module.findPart(key);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  init({@required List<PreceptModel> models}) {}
}

abstract class PartLibraryModule {
  final Type keyType;

  const PartLibraryModule({@required this.keyType});

  Part findPart(Object key) {
    if (key.runtimeType == keyType) {
      return doFindPart(key);
    }
    return null;
  }

  Part doFindPart(Object key);
}

class PreceptPartLibraryModule extends PartLibraryModule {
  PreceptPartLibraryModule() : super(keyType: StandardPart);

  @override
  Part doFindPart(Object key) {
    final StandardPart k = key;
    switch (k) {
      case StandardPart.StringPart:
        return StringPart();
      default:
        return null;
    }
  }
}

PartLibrary get partLibrary => inject<PartLibrary>();
