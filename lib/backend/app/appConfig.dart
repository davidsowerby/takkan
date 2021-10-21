import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/delegate.dart';

/// A wrapper for the JSON application configuration held in *precept.json*
/// The entire contents of *precept.json* are loaded through the constructor.
///
/// The configuration for a specific backend instance can be accessed via [instanceConfig]
///
/// Headers for HTTP / GraphQL clients can be obtained from [headers], assuming
/// of course that they have been declared in *precept.json*
///
/// Some properties are defined for convenience (for example serverUrl),
/// but all property values can be accessed directly from [data]
class AppConfig {
  final Map<String, dynamic> data;

  const AppConfig(this.data);

  Map<String, String> instanceConfig(PDataProvider config) {
    return instanceCfg(config.configSource);
  }

  Map<String, String> instanceCfg(PConfigSource configSource) {
    final segment = data[configSource.segment];
    if (segment == null) {
      String msg =
          'File precept.json in project root must define a segment for \'${configSource.segment}\'';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    final instance = segment[configSource.instance];
    if (instance == null) {
      String msg =
          'File precept.json in project root must define an instance \'${configSource.instance}\' in segment \'${configSource.segment}\'';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return Map<String, String>.from(instance);
  }

  /// [providerConfig] and [delegateConfig] are merged to define the keys used
  /// to look up header values from *precept.json*
  ///
  /// These are typically API Keys, Client Keys etc, and required for HTTP/GraphQL client
  /// initialisation.
  ///
  /// The header keys must be declared in *precept.json* exactly as they are to be used
  Map<String, String> headers(
    PDataProvider providerConfig,
    PDataProviderDelegate delegateConfig,
  ) {
    final combinedHeaderKeys =
        List.from(providerConfig.headerKeys, growable: true);
    combinedHeaderKeys.addAll(delegateConfig.headerKeys);
    final Map<String, String> headers = Map();
    final Map<String, String> instance = instanceConfig(providerConfig);
    for (String keyName in combinedHeaderKeys) {
      if (instance[keyName] != null) {
        headers[keyName] = instance[keyName]!;
      }
    }
    return headers;
  }

  String serverUrl(PDataProvider providerConfig) {
    final Map<String, String> instance = instanceConfig(providerConfig);
    String? serverUrl = instance['serverUrl'];

    if (serverUrl == null) {
      String msg =
          'A serverUrl must be defined for ${providerConfig.configSource}';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    if (serverUrl.endsWith('/')) {
      serverUrl = serverUrl.substring(0, serverUrl.length - 1);
    }
    return serverUrl;
  }
}
