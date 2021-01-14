import 'package:precept_backend/backend/delegate.dart';
import 'package:precept_common/common/exception.dart';
import 'package:precept_common/common/log.dart';
import 'package:precept_script/script/backend.dart';

class BackendLibrary {
  final Map<String, BackendDelegate Function(PBackend)> mappings = Map();

  BackendLibrary() : super();

  /// Finds an entry in the library matching [key], and returns an instance of it with [config]
  /// Throws a [PreceptException] if not found
  BackendDelegate find(PBackend config) {
    logType(this.runtimeType)
        .d("Finding BackendDelegate for ${config.runtimeType.toString()} in $runtimeType");
    final delegateCreator = mappings[config.backendType];
    if (delegateCreator == null) {
      String msg = "No entry is defined for ${config.runtimeType.toString()} in $runtimeType";
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return delegateCreator(config);
  }

  void init({Map<String, BackendDelegate Function(PBackend)> entries}) {
    mappings.addAll(entries ?? {});
  }
}

final BackendLibrary _backendLibrary = BackendLibrary();

BackendLibrary get backendLibrary => _backendLibrary;
