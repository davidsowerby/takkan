import 'package:precept_client/common/logger.dart';

abstract class LibraryModule<KEY, VALUE, CONFIG> {
  Map<KEY, VALUE Function(CONFIG)> get mappings;
}

abstract class Library<KEY, VALUE, CONFIG> {
  static const String defaultKey = 'default';
  static const String defaultListKey = 'default-list';
  final Map<KEY, VALUE Function(CONFIG)> entries=Map();

   Library();

  /// Finds an entry in the library matching [key], and returns an instance of it with [config]
  /// Return null if [key] not found
  VALUE find(KEY key, CONFIG config) {
    logType(this.runtimeType).d("Finding $key in $runtimeType");
    final func = entries[key];
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
