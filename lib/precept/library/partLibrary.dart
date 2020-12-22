import 'package:flutter/widgets.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_client/precept/part/string/stringPart.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/part/pString.dart';

class PartLibrary extends Library<Type, Widget, PPart> {

  @override
  setDefaults() {
    entries[PString] = (config) => StringPart(config: config as PString);
  }
}

PartLibrary _partLibrary = PartLibrary();
PartLibrary get partLibrary => _partLibrary;

