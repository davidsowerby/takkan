import 'dart:convert';
import 'dart:io';

import 'package:precept_backend/backend/dataProvider/constants.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/constants.dart';
import 'package:precept_script/data/provider/dataProvider.dart';

/// A wrapper for the JSON application configuration held in *precept.json*
/// The entire contents of *precept.json* are loaded through the constructor.
///
/// The configuration for a specific backend instance can be accessed via [instanceConfig]
/// All property values can be accessed directly from [data]
///
/// Headers for HTTP / GraphQL clients can be obtained from [headers], assuming
/// of course that they have been declared in *precept.json*
///
class AppConfig {
  static const String keySegment = 'segment';
  static const String keyInstance = 'instance';
  static const String keyServerUrl = 'serverUrl';
  static const String keyCloudCodeDir = 'cloudCode';
  static const String keyAppName = 'appName';
  static const String keyGraphqlEndpoint = 'graphqlEndpoint';
  static const String keyDocumentEndpoint = 'documentEndpoint';
  static const String defaultInstanceType = 'generic REST';
  final Map<String, dynamic> data;

  const AppConfig(this.data);

  InstanceConfig instanceConfig(PDataProvider config) {
    return instanceCfg(config.configSource);
  }

  InstanceConfig instanceCfg(PConfigSource configSource) {
    final segment = data[configSource.segment];
    if (segment == null) {
      String msg =
          'File precept.json in project root must define a segment for \'${configSource.segment}\'';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    final instanceData = segment[configSource.instance];
    if (instanceData == null) {
      String msg =
          'File precept.json in project root must define an instance \'${configSource.instance}\' in segment \'${configSource.segment}\'';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return InstanceConfig(
        data: instanceData,
        instanceName: configSource.instance,
        identifiedType: _identifyType(configSource));
  }

  String _identifyType(PConfigSource configSource) {
    if (configSource.segment.contains('back4app')) {
      return 'back4app';
    }
    return defaultInstanceType;
  }

  /// Headers are loaded from the appropriate instance definition within *precept.json*
  ///
  /// These are typically API Keys, Client Keys etc, and required for HTTP/GraphQL client
  /// initialisation.
  ///
  /// The header keys must be declared in *precept.json* exactly as they are to be used
  ///
  Map<String, String> headers(
    PDataProvider providerConfig,
  ) {
    final instanceHeaders = instanceConfig(providerConfig).headers;
    return instanceHeaders;
  }
}

/// Assumes that AppConfig is held in a file *precept.json* - if no [directory]
/// is specified, the current directory is assumed.
///
///
/// If loading through a Flutter client, this will not work, use the
/// JSONAssetLoader in the *precept_client* package instead
class AppConfigFileLoader {
  final Directory? directory;

  const AppConfigFileLoader({this.directory});

  /// If [returnEmptyIfAbsent] is true, a missing *precept.json* returns an empty
  /// [AppConfig] - if false, a [PreceptException] is thrown if no *precept.json*
  /// exists in [directory]
  Future<AppConfig> load({bool returnEmptyIfAbsent = false}) async {
    final dir = directory ?? Directory.current;
    File file = File('${dir.path}/precept.json');
    if (!file.existsSync()) {
      if (returnEmptyIfAbsent) {
        return AppConfig(Map());
      } else {
        throw PreceptException('There is no precept.json file in ${dir.path}');
      }
    }
    final content = file.readAsStringSync();
    final j = json.decode(content);
    return AppConfig(j);
  }
}

/// Headers are grouped together under 'headers'
class InstanceConfig {
  final Map<String, dynamic> data;
  final String instanceName;
  final String identifiedType;

  String get serverUrl =>
      data[AppConfig.keyServerUrl] ?? 'https://parseapi.back4app.com';

  String get appId => headers[keyHeaderApplicationId] ?? notSet;

  String get clientKey => headers[keyHeaderClientKey] ?? notSet;

  String get appName => data[AppConfig.keyAppName] ?? 'MyApp';

  String get documentEndpoint =>
      data[AppConfig.keyDocumentEndpoint] ?? _appendToServerUrl('classes');

  String get graphqlEndpoint =>
      data[AppConfig.keyGraphqlEndpoint] ?? _appendToServerUrl('graphql');

  Directory get cloudCodeDirectory => (data[AppConfig.keyCloudCodeDir] == null)
      ? Directory('${Platform.environment['HOME']!}/b4a/$appName/$instanceName')
      : Directory(data[AppConfig.keyCloudCodeDir]);

  Map<String, String> get headers => data['headers'] ?? {};

  String get type => data['type'] ?? identifiedType;

  InstanceConfig(
      {required this.data,
      required this.instanceName,
      required this.identifiedType}) {}

  String _appendToServerUrl(String appendage) {
    return serverUrl.endsWith('/')
        ? '$serverUrl$appendage'
        : '$serverUrl/$appendage';
  }
}
