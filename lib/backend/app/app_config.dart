import 'dart:core';
import 'dart:io';

import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/inject/inject.dart';

import '../data_provider/constants.dart';
import 'app_config_loader.dart';

/// A wrapper for the JSON application configuration held in *takkan.json*
/// The entire contents of *takkan.json* are loaded through the constructor.
///
/// The configuration for a specific backend instance can be accessed via [instanceConfig]
/// All property values, including any custom properties* a developer may wish to add,
/// can be accessed directly from [data]
///
/// Headers for HTTP / GraphQL clients can be obtained from [InstanceConfig.headers],
/// assuming of course that they have been declared in *takkan.json*
///
/// Many properties are 'inherited', which means they can be defined at
/// app, group or instance level.  An inherited property value is valid for all lower
/// levels, unless overridden at a lower level:
///
/// See https://takkan.org/docs/user-guide/app-configuration
///
/// A singleton instance is available within a Takkan app, via a call to:
///
/// ```
/// inject<AppConfig>();
/// ```
///
/// **Testing**
///
/// From within the Flutter client, the AppConfig singleton is loaded as a JSON
/// asset.  For testing outside Flutter, however, a direct file loading mechanism
/// is needed.  This can be set up with the following snippet:
///
/// ```
/// import 'package:takkan_backend/backend/app/app_config.dart';
/// import 'package:takkan_script/inject/inject.dart';
///
/// appConfigFromFileBindings(filePath:'myFilePath');
/// await getIt.isReady<AppConfig>(); // make sure file load is complete
/// final AppConfig=inject<AppConfig>();
/// ```
///
/// *NOTE: Custom properties cannot currently be a map. https://gitlab.com/takkan/takkan_backend/-/issues/22
class AppConfig {
  static const String keyGroup = 'group';
  static const String keyInstance = 'instance';
  static const String keyServerUrl = 'serverUrl';
  static const String keyCloudCodeDir = 'cloudCode';
  static const String keyAppName = 'appName';
  static const String keyGraphqlEndpoint = 'graphqlEndpoint';
  static const String keyDocumentEndpoint = 'documentEndpoint';
  static const String keyFunctionEndpoint = 'functionEndpoint';
  static const String keySelectedInstance = 'selectedInstance';
  static const String keyServiceType = 'type';
  static const String defaultServiceType = 'back4app';

  final Map<String, GroupConfig> _groups = {};
  final Map<String, dynamic> _data = {};
  final Map<String, dynamic> _properties = {};
  bool _ready = false;

  AppConfig();

  AppConfig.fromData({required Map<String, dynamic> data}) {
    _processData(data);
  }

  Future<AppConfig> load({String filePath = 'takkan.json'}) async {
    _ready = false;
    final fileContent =
        await inject<JsonFileLoader>().loadFile(filePath: filePath);
    return _processData(fileContent);
  }

  AppConfig _processData(Map<String, dynamic> data) {
    _data.clear();
    _data.addAll(data);

    /// Copy the groups into GroupConfig instances, properties into _properties
    for (String key in _data.keys) {
      final entry = _data[key];
      if (entry is Map) {
        _groups[key] = GroupConfig(
          parent: this,
          data: _data[key],
          name: key,
        );
      } else {
        _properties[key] = entry;
      }
    }
    _ready = true;
    return this;
  }

  InstanceConfig instanceConfig(DataProvider providerConfig) {
    final g = group(providerConfig.instanceConfig.group);
    final instanceName = g.selectedInstanceName;
    final i = g.instance(instanceName);
    return i;
  }

  GroupConfig group(String groupName) {
    final group = _groups[groupName];
    if (group == null) {
      String msg =
          'File takkan.json in project root does not define a group \'${groupName}\'';
      logType(this.runtimeType).e(msg);
      throw TakkanException(msg);
    }
    return group;
  }

  List<GroupConfig> get groups => _groups.values.toList();

  bool get isReady => _ready;

  Map<String, dynamic> get data => Map.from(_data);

  /// Returns all instances from all groups
  List<InstanceConfig> get instances {
    final _instances = List<InstanceConfig>.empty(growable: true);
    for (GroupConfig group in _groups.values) {
      _instances.addAll(group.instances);
    }
    return _instances;
  }
}

/// [_properties] holds any group properties not part of an [InstanceConfig]
class GroupConfig {
  final AppConfig parent;
  final String name;
  final Map<String, InstanceConfig> _instances = {};
  final Map<String, dynamic> _properties = {};

  GroupConfig(
      {required this.parent,
      required this.name,
      required Map<String, dynamic> data}) {
    for (String key in data.keys) {
      if (data[key] is Map) {
        final instanceKey = key;
        final Map untypedMap = data[instanceKey];
        final Map<String, dynamic> t = Map.castFrom(untypedMap);
        _instances[instanceKey] = InstanceConfig(
          name: instanceKey,
          parent: this,
          data: t,
        );
      } else {
        this._properties[key] = data[key];
      }
    }
  }

  InstanceConfig get selectedInstance {
    return instance(selectedInstanceName);
  }

  /// Returns value of key [AppConfig.keySelectedInstance] or the first declared instance name
  String get selectedInstanceName =>
      _properties[AppConfig.keySelectedInstance] ?? _instances.keys.first;

  InstanceConfig instance(String instanceName) {
    final instanceConfig = _instances[instanceName];

    if (instanceConfig == null) {
      String msg =
          'File takkan.json in project root does not define an instance \'${instanceName}\' in group \'${name}\'';
      logType(this.runtimeType).e(msg);
      throw TakkanException(msg);
    }
    return instanceConfig;
  }

  bool hasInstance(String? instanceName) {
    if (instanceName == null) {
      return false;
    }
    return _instances.containsKey(instanceName);
  }

  Iterable<InstanceConfig> get instances => _instances.values;
}

class InstanceConfig {
  final String name;
  final GroupConfig parent;
  final Map<String, dynamic> _properties;

  InstanceConfig(
      {required this.name,
      required this.parent,
      required Map<String, dynamic> data})
      : _properties = data;

  String get serviceType => _property(
        propertyName: AppConfig.keyServiceType,
        defaultValue: AppConfig.defaultServiceType,
      );

  String get graphqlEndpoint => _property(
        propertyName: AppConfig.keyGraphqlEndpoint,
        defaultValue: _appendToServerUrl(serverUrl, 'graphql'),
      );

  String get documentEndpoint => _property(
        propertyName: AppConfig.keyDocumentEndpoint,
        defaultValue: _appendToServerUrl(serverUrl, 'classes'),
      );

  String get functionEndpoint => _property(
        propertyName: AppConfig.keyFunctionEndpoint,
        defaultValue: _appendToServerUrl(serverUrl, 'functions'),
      );

  String get serverUrl => _property(
        propertyName: AppConfig.keyServerUrl,
        defaultValue: 'https://parseapi.back4app.com',
      );

  /// These are typically API Keys, Client Keys etc, and required for HTTP/GraphQL client
  /// initialisation.
  ///
  /// The header keys must be declared in *takkan.json* exactly as they are to be used
  ///
  /// This conversion seems unnecessarily complicated just to get a Map<String,String> from a
  /// Map<String,dynamic> but was the only way I found to get around Dart's typing
  ///
  Map<String, String> get headers {
    final Map h1 = _requiredMapProperty('headers');
    return Map.castFrom(h1);
  }

  String get appName =>
      _property(propertyName: AppConfig.keyAppName, defaultValue: 'MyApp');

  /// Unique within its [AppConfig]
  String get uniqueName => '${parent.name}:$name';

  String get appId =>
      headers[keyHeaderApplicationId] ??
      _requiredProperty(keyHeaderApplicationId);

  String get clientKey =>
      headers[keyHeaderClientKey] ?? _requiredProperty(keyHeaderClientKey);

  Directory get cloudCodeDirectory => Directory(
        _property(
            propertyName: AppConfig.keyCloudCodeDir,
            defaultValue:
                '${Platform.environment['HOME']!}/b4a/${appName}/$name/cloud'),
      );

  String _requiredProperty(String propertyName) {
    final String? value = _properties[propertyName];
    if (value != null) return value;
    final String msg =
        'A String property \'$propertyName\' must be defined in InstanceConfig $uniqueName or its parent chain';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  Map _requiredMapProperty(String propertyName) {
    final Map? value = _properties[propertyName];
    if (value != null) return value;
    final String msg =
        'A Map property \'$propertyName\' must be defined in InstanceConfig $uniqueName or its parent chain';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  String _property(
      {required String propertyName, required String defaultValue}) {
    final instanceValue = _properties[propertyName];
    if (instanceValue != null) return instanceValue;
    final groupValue = parent._properties[propertyName];
    if (groupValue != null) return groupValue;
    final appValue = parent.parent._properties[propertyName];
    if (appValue != null) return appValue;
    return defaultValue;
  }
}

String _appendToServerUrl(String serverUrl, String appendage) {
  return serverUrl.endsWith('/')
      ? '$serverUrl$appendage'
      : '$serverUrl/$appendage';
}

/// Creates GetIt bindings to create an [AppConfig] instance, with data from
/// a JSON file at [filePath]
appConfigFromFileBindings({String filePath = 'takkan.json'}) {
  getIt.registerFactory<JsonFileLoader>(() => DefaultJsonFileLoader());
  getIt.registerSingletonAsync<AppConfig>(() {
    final AppConfig appConfig = AppConfig();
    return appConfig.load(filePath: filePath);
  });
}

/// Creates GetIt bindings to create an [AppConfig] instance with [data]
appConfigFromDataBindings({required Map<String, dynamic> data}) {
  getIt.registerFactory<JsonFileLoader>(() => DirectFileLoader(data: data));
  getIt.registerSingletonAsync<AppConfig>(() {
    final AppConfig appConfig = AppConfig();
    return appConfig.load();
  });
}
