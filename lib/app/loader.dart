import 'package:precept_script/script/script.dart';

/// Common interface to load a Precept instance from any source
abstract class PreceptLoader {
  /// Loads the precept JSON file from source.  Implementations must call [PScript.init] after loading
  Future<PScript> load();

  bool get isLoaded;
}

/// Generally only used during development, this implementation of [PreceptLoader] just
/// takes an 'in code' [PScript] model.  The script 'refresh' button will not work with a script
/// loaded this way, as the value of the script is already compiled in.  The refresh option
/// only works when the file is loaded from outside the app, for example, from [RestPreceptLoader] .
class DirectPreceptLoader implements PreceptLoader {
  final PScript script;
  bool _loaded = false;

  DirectPreceptLoader({required this.script});

  @override
  Future<PScript> load() async {
    _loaded = true;
    return script;
  }

  bool get isLoaded => _loaded;
}

class RestPreceptLoader implements PreceptLoader {
  @override
  // TODO: implement isLoaded
  bool get isLoaded => throw UnimplementedError();

  @override
  Future<PScript> load() {
    // TODO: implement load
    throw UnimplementedError();
  }
}
