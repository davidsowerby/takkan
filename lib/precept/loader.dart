import 'package:flutter/foundation.dart';
import 'package:precept_client/precept/script/script.dart';

/// Common interface to load a Precept instance from any source
abstract class PreceptLoader {
  /// Loads the precept JSON file from source.  Implementations must call [PScript.init] after loading
  Future<PScript> load();

  bool get isLoaded;
}

/// Generally only used for testing this implementation of [PreceptLoader] just
/// takes a pre-built [PScript] model
class DirectPreceptLoader implements PreceptLoader {
  final PScript script;
  bool _loaded = false;

  DirectPreceptLoader({@required this.script}) : assert(script != null);

  @override
  Future<PScript> load() {
    _loaded = true;
    return Future.value(script);
  }

  bool get isLoaded => _loaded;
}
