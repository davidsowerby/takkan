import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:precept_back4app_backend/backend/back4app/back4AppConfig.dart';
import 'package:precept_back4app_backend/backend/back4app/backendInitialiser.dart';

class Back4AppInitialiser extends BackendInitialiser {
  Parse _parse;

  Back4AppInitialiser() : super();

  @override
  connect() async {
    final config = await Back4AppConfig().config(env);
    _parse = await Parse().initialize(
      config.appId, config.serverUrl,
      autoSendSessionId: true,
      // Required for authentication and ACL
      debug: true,
      // When enabled, prints logs to console
      coreStore: coreStore,
      masterKey: config.restId,
      clientKey: config.clientId,
    );
//    initInstallation();
  }

  @override
  Future<String> healthCheck() async {
    final health = await _parse.healthCheck();
    return "Parse health check status code: ${health.statusCode}";
  }

  Future<void> initInstallation() async {
    final ParseInstallation installation = await ParseInstallation.currentInstallation();
    final ParseResponse response = await installation.create();
    print(response);
  }

  Parse get parse => _parse;
}
