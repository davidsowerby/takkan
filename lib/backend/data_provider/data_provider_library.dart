import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/user/precept_user.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/inject/inject.dart';

/// A lookup facility for instances of [IDataProvider] implementations.
/// Provides an instance using the [find] method, from a supplied type name, defined in *precept.json*
///
/// Also acts as a cache, as most [IDataProvider] implementations are stateful and should be retained once
/// connected
///
/// Note: The original plan was to use GetIt for this, but there are a couple of obstacles to that approach:
/// - the GetIt.registerFactory signature is type based, and does not fit for returning a DataProvider instance from a DataProvider
/// - the use of 'instanceName' is discouraged, although it is not clear why.
///
/// [appConfig] is initialised during Precept start up
///
/// injected via GetIt primarily for testing
///
abstract class DataProviderLibrary {
  init(AppConfig appConfig);

  IDataProvider find({required DataProvider providerConfig});

  register({
    required String type,
    required IDataProvider Function(DataProvider) builder,
  });

  clear();
}

class DefaultDataProviderLibrary implements DataProviderLibrary {
  final Map<String, IDataProvider Function(DataProvider)> builders = Map();
  final Map<String, IDataProvider> instances = Map();
  late AppConfig _appConfig;

  DefaultDataProviderLibrary() : super();

  AppConfig get appConfig => _appConfig;

  init(AppConfig appConfig) {
    this._appConfig = appConfig;
  }

  /// Finds a previously cached, or creates a [IDataProvider] instance appropriate to the
  /// type of provider (identified by [instanceConfig.type])
  ///
  /// An instance of DataProvider is identified uniquely by [providerConfig.instanceConfig],
  /// thus allowing multiple instances of the same DataProvider type.  This is
  /// especially important as the DataProvider contains a [PreceptUser] object,
  /// which differ from one instance to another.
  ///
  /// Requires that the [instanceConfig.type] has been registered using [register].
  /// This is usually done in your main.dart file, using for example, `Back4App.register()`
  ///
  /// Note: The [instanceConfig] is retrieved from [AppConfig], which is the in-app
  /// representation of precept.json.
  ///
  /// Throws a [PreceptException] if a builder for this config has not been registered
  IDataProvider find({required DataProvider providerConfig}) {
    if (providerConfig is NullDataProvider) {
      logType(this.runtimeType).d("Returning a NoDataProvider");
      return NoDataProvider();
    }

    final InstanceConfig instanceConfig =
        appConfig.instanceConfig(providerConfig);
    final String key = providerConfig.instanceConfig.toString();
    logType(this.runtimeType)
        .d("Finding DataProvider for instanceConfig: $key");

    /// Use existing instance if there is one
    final instance = instances[key];
    if (instance != null) return instance;

    /// Otherwise create instance from builder, cache and return it
    final builder = builders[instanceConfig.type];
    if (builder != null) {
      final newInstance = builder(providerConfig);
      newInstance.init(appConfig);
      instances[key] = newInstance;
      return newInstance;
    }

    /// Failed
    String msg =
        "No entry is defined for ${instanceConfig.type} in $runtimeType.\n  Have you forgotten to call register() for your DataProvider in your 'main.dart'?";
    logType(this.runtimeType).e(msg);
    throw PreceptException(msg);
  }

  register({
    required String type,
    required IDataProvider Function(DataProvider) builder,
  }) {
    builders[type] = builder;
  }

  /// Clears all [builders] and [instances]
  clear() {
    builders.clear();
    instances.clear();
  }
}

final DataProviderLibrary _dataProviderLibrary = inject<DataProviderLibrary>();

DataProviderLibrary get dataProviderLibrary => _dataProviderLibrary;
