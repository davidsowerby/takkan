import 'package:flutter/foundation.dart';
import 'package:precept/precept/model/model.dart';

/// Common interface to load a Precept instance from any source
abstract class PreceptLoader {
  /// Loads the precept JSON file from source.  Implementations must call [PreceptModel.init] after loading
  Future<PreceptModel> load();

  bool get isLoaded;
}

/// Generally only used for testing this implementation of [PreceptLoader] just
/// takes a pre-built [PreceptModel] model
class DirectPreceptLoader implements PreceptLoader {
  final PreceptModel model;
  bool _loaded = false;

  DirectPreceptLoader({@required this.model}) : assert(model != null);

  @override
  Future<PreceptModel> load() {
    _loaded = true;
    return Future.value(model);
  }

  bool get isLoaded => _loaded;
}
