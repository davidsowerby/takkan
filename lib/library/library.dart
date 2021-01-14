import 'package:precept_common/common/exception.dart';
import 'package:precept_common/common/log.dart';

abstract class LibraryModule<KEY, VALUE, CONFIG> {
  Map<KEY, VALUE Function(CONFIG)> get mappings;
}

abstract class Library<KEY, VALUE, CONFIG> {
  static const String simpleKey = 'simple';
  static const String simpleListKey = 'simple-list';
  final Map<KEY, VALUE Function(CONFIG)> entries = Map();

  Library();

  /// Finds an entry in the library matching [key], and returns an instance of it with [config]
  /// Throws a [PreceptException] if not found
  VALUE find(KEY key, CONFIG config) {
    logType(this.runtimeType).d("Finding $key in $runtimeType");
    final func = entries[key];
    if (func==null){
      String msg = "No entry is defined for ${key.toString()} in $runtimeType";
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return (func == null) ? null : func(config);
  }

  /// Loads library entries defined by the developer
  ///
  /// If there are duplicate keys, later additions will override earlier
  /// Defaults are loaded first, so to replace, define another with the key 'default'
  /// There should be no need to call this directly, init for all libraries is carried out in
  /// a call to [Precept.init] which should be before your runApp statement
  init({Map<KEY, VALUE Function(CONFIG)> entries}) {
    setDefaults();

    if (entries != null) {
      this.entries.addAll(entries);
    }
    logType(this.runtimeType).d("$runtimeType Library initialised");
  }

  /// Override for each library
  setDefaults();
}
