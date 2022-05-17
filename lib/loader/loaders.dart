import 'package:takkan_script/script/script.dart';

/// Common interface to load a Takkan instance from any source
abstract class TakkanLoader {
  /// Loads the takkan JSON file from source.  Implementations must call [Script.init] after loading
  Future<Script> load();

  bool get isLoaded;
}

/// Generally only used during development, this implementation of [TakkanLoader] just
/// takes an 'in code' [Script] model.  The script 'refresh' button will not work with a script
/// loaded this way, as the value of the script is already compiled in.  The refresh option
/// only works when the file is loaded from outside the app, for example, from [RestTakkanLoader] .
class DirectTakkanLoader implements TakkanLoader {
  final Script script;
  bool _loaded = false;

  DirectTakkanLoader({required this.script});

  @override
  Future<Script> load() async {
    _loaded = true;
    return script;
  }

  bool get isLoaded => _loaded;
}

class RestTakkanLoader implements TakkanLoader {
  @override
  // TODO: implement isLoaded
  bool get isLoaded => throw UnimplementedError();

  @override
  Future<Script> load() {
    // TODO: implement load
    throw UnimplementedError();
  }
}
