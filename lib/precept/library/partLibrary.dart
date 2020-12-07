import 'package:flutter/widgets.dart';
import 'package:precept_client/common/logger.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/part/pPart.dart';
import 'package:precept_client/precept/part/string/stringPart.dart';

class PartLibrary {
  final Map<String, Widget Function(PPart, ModelBinding)> entries=Map();

  /// Finds an entry in the library matching [key], and returns an instance of it with [config]
  /// and [parentBinding].  Return null if [key] not found
  Widget find(String key, PPart config, ModelBinding parentBinding) {
    logType(this.runtimeType).d("Finding $key in $runtimeType");
    final func = entries[key];
    return (func == null) ? null : func(config, parentBinding);
  }

  setDefaults() {
    entries["PString"] = (config, parentBinding) => StringPart(config: config, parentBinding: parentBinding, );
  }

  /// Loads library entries defined by the developer
  ///
  /// If there are duplicate keys, later additions will override earlier
  /// Defaults are loaded first, so to replace, define another with the key 'default'
  /// There should be no need to call this directly, init for all libraries is carried out in
  /// a call to [Precept.init] which should be before your runApp statement
  init({Map<String, Widget Function(PPart, ModelBinding)> entries}) {
    setDefaults();

    if (entries != null) {
      this.entries.addAll(entries);
    }
    logType(this.runtimeType).d("$runtimeType Library initialised");
  }
}

PartLibrary _partLibrary = PartLibrary();
PartLibrary get partLibrary => _partLibrary;

