import 'package:precept_backend/backend/delegate.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_mock_backend/precept_mock_backend.dart';
import 'package:precept_script/script/backend.dart';

class BackendLibrary extends Library<String, BackendDelegate, PBackend> {
  BackendLibrary() : super();

  setDefaults() {
    entries["mock"] = (config) => MockBackendDelegate(config: config);
  }
}

final BackendLibrary _backendLibrary = BackendLibrary();

BackendLibrary get backendLibrary => _backendLibrary;
