import 'dart:io';

import 'package:precept_backend/backend/data_provider/constants.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/constants.dart';
import 'package:precept_script/data/provider/data_provider.dart';

/// A wrapper for the JSON application configuration held in *precept.json*
/// The entire contents of *precept.json* are loaded through the constructor.
///
/// The configuration for a specific backend instance can be accessed via [instanceConfig]
/// All property values can be accessed directly from [data]
///
/// Headers for HTTP / GraphQL clients can be obtained from [headers], assuming
/// of course that they have been declared in *precept.json*
///
/// Many properties are 'inherited', which means they can be defined at
/// app, group or instance level.  An inherited property value is valid for all lower
/// levels, unless overridden at a lower level:
///
/// See https://preceptblog.co.uk/docs/user-guide/app-configuration
class AppConfig extends BaseConfig with Appendage {
  static const String keyGroup = 'group';
  static const String keyInstance = 'instance';
  static const String keyServerUrl = 'serverUrl';
  static const String keyCloudCodeDir = 'cloudCode';
  static const String keyAppName = 'appName';
  static const String keyGraphqlEndpoint = 'graphqlEndpoint';
  static const String keyDocumentEndpoint = 'documentEndpoint';
  static const String keyFunctionEndpoint = 'functionEndpoint';
  static const String keyGraphqlStub = 'graphqlStub';
  static const String keyDocumentStub = 'documentStub';
  static const String keyFunctionStub = 'functionStub';
  static const String keyStages = 'stages';
  static const String keyType = 'type';
  static const String defaultInstanceType = 'back4app';
  final Map<String, GroupConfig> _groups = Map();
  final String currentStage;

  AppConfig({
    this.currentStage = notSet,
    required Map<String, dynamic> data,
    String? type,
  }) : super(ConfigPropsRoot(data), null) {
    for (String groupKey in data.keys) {
      _groups[groupKey] = GroupConfig(
        parent: this,
        data: data[groupKey],
        name: groupKey,
      );
    }
  }

  InstanceConfig instanceConfig(DataProvider providerConfig) {
    final g = group(providerConfig.instanceConfig.group);
    final instanceName =
        (g.staged) ? currentStage : providerConfig.instanceConfig.instance;
    if (instanceName == null) {
      String msg =
          'Either a current stage must be set from precept.json or DataProvider must define an instance name';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    final i = g.instance(instanceName);
    return i;
  }

  GroupConfig group(String groupName) {
    final group = _groups[groupName];
    if (group == null) {
      String msg =
          'File precept.json in project root does not define a group \'${groupName}\'';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return group;
  }
}

class GroupConfig extends BaseConfig with Appendage {
  final Map<String, InstanceConfig> _instances = Map();
  final Map<String, dynamic> data = Map();
  final String name;

  GroupConfig(
      {required this.name,
      required AppConfig parent,
      required Map<String, dynamic> data})
      : super(ConfigProps(data, parent), parent) {
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
        this.data[key] = data[key];
      }
    }
  }

  List<String> get stages => (data[AppConfig.keyStages] == null)
      ? ['dev', 'test', 'qa', 'prod']
      : List.castFrom(data[AppConfig.keyStages]);


  bool get staged => stages.isNotEmpty;

  InstanceConfig instance(String instanceName) {
    final instanceConfig = _instances[instanceName];

    if (instanceConfig == null) {
      String msg =
          'File precept.json in project root does not define an instance \'${instanceName}\' in group \'${name}\'';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return instanceConfig;
  }

  bool hasInstance(String? instanceName) {
    if (instanceName == null) {
      return false;
    }
    return _instances.containsKey(instanceName);
  }
}

/// Headers are grouped together under 'headers'
class InstanceConfig extends BaseConfig with Appendage {
  final String? name;

  InstanceConfig(
      {required GroupConfig parent,
      required Map<String, dynamic> data,
      required this.name})
      : super(ConfigProps(data, parent), parent) {}

  String get appId => headers[keyHeaderApplicationId] ?? notSet;

  String get clientKey => headers[keyHeaderClientKey] ?? notSet;

  Directory get cloudCodeDirectory => (props.data[AppConfig.keyCloudCodeDir] ==
          null)
      ? Directory('${Platform.environment['HOME']!}/b4a/$appName/$name/cloud')
      : Directory(props.data[AppConfig.keyCloudCodeDir]);

  /// These are typically API Keys, Client Keys etc, and required for HTTP/GraphQL client
  /// initialisation.
  ///
  /// The header keys must be declared in *precept.json* exactly as they are to be used
  ///
  /// This seems unnecessarily complicated just to get a Map<String,String> from a
  /// Map<String,dynamic> but was the only way I found to get around Dart's typing
  ///
  /// TODO: use Map.castFrom
  Map<String, String> get headers {
    final Map<String, dynamic>? h1 = props.data['headers'];
    if (h1 != null) {
      final Map<String, String> h2 = Map();
      h1.entries.forEach((element) {
        h2[element.key] = element.value;
      });
      return h2;
    } else {
      return {};
    }
  }
}

mixin Appendage {
  String _appendToServerUrl(String serverUrl, String appendage) {
    return serverUrl.endsWith('/')
        ? '$serverUrl$appendage'
        : '$serverUrl/$appendage';
  }
}

class ConfigProps extends ConfigPropsRoot with Appendage {
  final BaseConfig parent;

  ConfigProps(Map<String, dynamic> data, this.parent) : super(data);

  String get appName => data[AppConfig.keyAppName] ?? parent.appName;

  String get type => data[AppConfig.keyType] ?? parent.type;

  String get serverUrl => data[AppConfig.keyServerUrl] ?? parent.serverUrl;

  String get documentStub =>
      data[AppConfig.keyDocumentStub] ?? parent.documentStub;

  String get graphqlStub =>
      data[AppConfig.keyGraphqlStub] ?? parent.graphqlStub;

  String get functionStub =>
      data[AppConfig.keyFunctionStub] ?? parent.functionStub;
}

class ConfigPropsRoot with Appendage {
  final Map<String, dynamic> data;

  ConfigPropsRoot(this.data);

  /// Inherited properties
  String get type => data[AppConfig.keyType] ?? 'back4app';

  String get appName => data[AppConfig.keyAppName] ?? 'MyApp';

  String get serverUrl =>
      data[AppConfig.keyServerUrl] ?? 'https://parseapi.back4app.com';

  String get documentStub => data[AppConfig.keyDocumentStub] ?? 'classes';

  String get graphqlStub => data[AppConfig.keyGraphqlStub] ?? 'graphql';

  String get functionStub => data[AppConfig.keyFunctionStub] ?? 'functions';

  String get documentEndpoint =>
      data[AppConfig.keyDocumentEndpoint] ??
      _appendToServerUrl(serverUrl, documentStub);

  String get graphqlEndpoint =>
      data[AppConfig.keyGraphqlEndpoint] ??
      _appendToServerUrl(serverUrl, graphqlStub);

  String get functionEndpoint =>
      data[AppConfig.keyFunctionEndpoint] ??
      _appendToServerUrl(serverUrl, functionStub);
}

abstract class BaseConfig {
  final ConfigPropsRoot props;
  final BaseConfig? parent;

  const BaseConfig(this.props, this.parent);

  String get type => props.type;

  String get appName => props.appName;

  String get serverUrl => props.serverUrl;

  String get documentStub => props.documentStub;

  String get graphqlStub => props.graphqlStub;

  String get functionStub => props.functionStub;

  String get documentEndpoint => props.documentEndpoint;

  String get graphqlEndpoint => props.graphqlEndpoint;

  String get functionEndpoint => props.functionEndpoint;
}
