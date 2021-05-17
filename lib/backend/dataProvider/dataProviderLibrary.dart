import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/dataProvider.dart';

/// A lookup facility for instances of [DataProvider] implementations.
/// Provides an instance from the [find] method, from a supplied [PDataProvider]
/// Also acts as a cache, as most [DataProvider] implementations are stateful and should be retained once
/// connected
///
/// Note: The original plan was to use GetIt for this, but there are a couple of obstacles to that approach:
/// - the GetIt.registerFactory signature is type based, and does not fit for returning a DataProvider instance from a PDataProvider
/// - the use of 'instanceName' is discouraged, although it is not clear why.
class DataProviderLibrary {
  final Map<Type, DataProvider Function(PDataProvider)> builders = Map();
  final Map<String, DataProvider> instances = Map();

  DataProviderLibrary() : super();

  /// Finds an entry in the library matching [key], and returns an instance of it with [config].
  /// [config] must be of the type appropriate to the [DataProvider] implementation required.
  /// [config.instanceName] is only needed if you require two instances of the same [DataProvider] type.
  ///
  /// Throws a [PreceptException] if a builder for this config has not been registered
  DataProvider find({required PDataProvider config}) {
    final lookupKey = '${config.runtimeType.toString()}';
    logType(this.runtimeType).d("Finding DataProvider for lookupKey: $lookupKey");

    /// Use existing instance if there is one
    final instance = instances[lookupKey];
    if (instance != null) return instance;

    /// Otherwise create instance from builder, store and return it
    final builder = builders[config.runtimeType];
    if (builder != null) {
      final newInstance = builder(config);
      instances[lookupKey] = newInstance;
      return newInstance;
    }

    /// Failed
    String msg = "No entry is defined for ${config.runtimeType.toString()} in $runtimeType";
    logType(this.runtimeType).e(msg);
    throw PreceptException(msg);
  }

  /// Is there a way to check that [config] is a [PDataProvider] ?
  register({required Type config, required DataProvider Function(PDataProvider) builder}) {
    builders[config] = builder;
  }

  /// Clears all [builders] and [instances]
  clear() {
    builders.clear();
    instances.clear();
  }
}

final DataProviderLibrary _dataProviderLibrary = DataProviderLibrary();

DataProviderLibrary get dataProviderLibrary => _dataProviderLibrary;
