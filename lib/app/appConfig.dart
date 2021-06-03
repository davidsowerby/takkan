import 'package:precept_script/data/provider/dataProviderBase.dart';

class AppConfig {
  final Map<String, dynamic> data;

  const AppConfig(this.data);

  Map<String, String> instanceConfig(PConfigSource configSource) {
    final instance = data[configSource.segment][configSource.instance] as Map<String, dynamic>;
    return instance.cast();
  }

  /// [config] defines the keys used to look up header values from **precept.json**
  /// These are typically API Keys, Client Keys etc, and required for HTTP/GraphQL client
  /// initialisation.
  Map<String, String> headers(PDataProviderBase config) {
    final Map<String, String> headers = Map();
    final Map<String, String> instance = instanceConfig(config.configSource);
    for (String keyName in config.headerKeys) {
      if (instance[keyName] != null) {
        headers[keyName] = instance[keyName]!;
      }
    }
    return headers;
  }
}
