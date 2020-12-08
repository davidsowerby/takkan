import 'package:flutter/widgets.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_client/precept/part/pPart.dart';
import 'package:precept_client/precept/part/string/stringPart.dart';

class PartLibrary extends Library<Type, Widget, PPart> {

  @override
  setDefaults() {
    entries[PString] = (config) => StringPart(config: config as PString);
  }
}

PartLibrary _partLibrary = PartLibrary();
PartLibrary get partLibrary => _partLibrary;

