import 'dart:convert';
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
    return instance(
        segment: configSource.segment, instance: configSource.instance);
  }

  InstanceConfig instance({required String segment, required String instance}) {
    final segmentData = data[segment];
    if (segmentData == null) {
      String msg =
          'File precept.json in project root must define a segment for \'${segment}\'';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    final instanceData = segmentData[instance];
    if (instanceData == null) {
      String msg =
          'File precept.json in project root must define an instance \'${instance}\' in segment \'${segment}\'';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return InstanceConfig(
        data: instanceData,
        instanceName: instance,
        identifiedType: _identifyType(segment: segment, instance: instance));
  }

  String _identifyTypeFromSource(PConfigSource configSource) {
    return _identifyType(
        segment: configSource.segment, instance: configSource.instance);
  }

  String _identifyType({required String segment, required String instance}) {
    if (data.containsKey('type')) {
      return data['type'];
    }
    if (segment.contains('back4app')) {
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
  Map<String, dynamic> headers(
    PDataProvider providerConfig,
  ) {
    final instanceHeaders = instanceConfig(providerConfig).headers;
    return instanceHeaders;
  }
}

/// The default is to hold app configuration in a file *precept.json* in the project root.
///
/// Except for testing, any deviation from this convention is discouraged, as Precept will
/// assumes that is where the configuration is.
///
/// It is therefore usually unnecessary to specify [file], except when testing
///
///
/// If loading through a Flutter client, this loader will not work, use the
/// JSONAssetLoader in the *precept_client* package instead
class AppConfigFileLoader {
  final File? file;

  const AppConfigFileLoader({this.file});

  /// If [returnEmptyIfAbsent] is true, a missing *precept.json* returns an empty
  /// [AppConfig] - if false, a [PreceptException] is thrown if no *precept.json*
  /// exists in [file]
  Future<AppConfig> load({bool returnEmptyIfAbsent = false}) async {
    final f = file ?? File('${Directory.current.path}/precept.json');
    if (!f.existsSync()) {
      if (returnEmptyIfAbsent) {
        return AppConfig(Map());
      } else {
        throw PreceptException('There is no file at ${f.path}');
      }
    }
    final content = f.readAsStringSync();
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
      ? Directory(
          '${Platform.environment['HOME']!}/b4a/$appName/$instanceName/cloud')
      : Directory(data[AppConfig.keyCloudCodeDir]);

  /// This seems unnecessarily complicated just to get a Map<String,String> from a
  /// Map<String,dynamic> but was the only way I found to get around Dart's typing
  Map<String, String> get headers {
    final Map<String, dynamic>? h1 = data['headers'];
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
