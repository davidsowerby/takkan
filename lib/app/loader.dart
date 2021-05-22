
import 'package:precept_script/script/script.dart';

/// Common interface to load a Precept instance from any source
abstract class PreceptLoader {
  /// Loads the precept JSON file from source.  Implementations must call [PScript.init] after loading
  Future<PScript> load();

  bool get isLoaded;
}

/// Generally only used during development, this implementation of [PreceptLoader] just
/// takes an 'in code' [PScript] model
class DirectPreceptLoader implements PreceptLoader {
  final PScript script;
  bool _loaded = false;

  DirectPreceptLoader({required this.script}) : assert(script != null);

  @override
  Future<PScript> load() async {
    _loaded = true;
    return script;
  }

  bool get isLoaded => _loaded;
}

class RestPreceptLoader implements PreceptLoader{
  @override
  // TODO: implement isLoaded
  bool get isLoaded => throw UnimplementedError();

  @override
  Future<PScript> load() {
    // TODO: implement load
    throw UnimplementedError();
  }

}
