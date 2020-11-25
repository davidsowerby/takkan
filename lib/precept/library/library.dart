

abstract class LibraryModule<KEY, VALUE, CONFIG> {
  Map<KEY, VALUE Function(CONFIG)> get mappings;
}



abstract class Library<KEY, VALUE, CONFIG> {
  Map<KEY, VALUE Function(CONFIG)> _mappings = Map();

  /// Finds an entry in the library matching [key], and returns an instance of it with [config]
  /// Return null if [key] not found
  VALUE find(KEY key, CONFIG config) {
    final func = _mappings[key];
    return (func == null) ? null : func(config);
  }

  /// [DefaultPageLibraryModule] will be loaded unless [useDefault] is false.
  /// Your own [modules] will be merged together, and will include [DefaultPageLibraryModule] unless [useDefault] is false.
  init({List<LibraryModule<KEY, VALUE, CONFIG>> modules, bool useDefault = true}) {
    assert(useDefault != null);
    assert((useDefault) || ((modules != null) && (modules.length > 0)));
    if (useDefault) {
      _mappings.addAll(defaultMappings);
    }

    if (modules != null) {
      for (var module in modules) {
        _mappings.addAll(module.mappings);
      }
    }
  }

  Map<KEY, VALUE Function(CONFIG)> get defaultMappings;
}



