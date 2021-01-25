
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/script/backend.dart';

/// Reads Back4App config from file secrets.json, held at project root.  Use for API keys etc, that MUST NOT be under
/// version control.  Build script in CI creates the file

class Back4AppKeyLoader {
  Map<String, dynamic> _data;
  final String secretPath;

  Back4AppKeyLoader({this.secretPath = "secrets.json"});

  Future<ParseServerConfig> load(Env env) async {
    final environment = env.toString().split('.').last;
    if (_data == null) {
      await loadFile();
      if (_data == null) {
        logType(this.runtimeType).e("Failed to locate Application configuration asset");
      } else {
        logType(this.runtimeType).i("Application configuration asset loaded");
      }
    }

    return ParseServerConfig(data: Map.castFrom(_data[environment]));
  }

  String get testValue => _data["testValue"];

  /// Tries to load secrets from an environmental variable with key [envVariableName], and or if that is not
  /// available, tries to load a file from [secretPath]
  ///
  Future<bool> loadFile() async {
    Map<dynamic, dynamic> rawMap = await rootBundle.loadStructuredData<Map<dynamic, dynamic>>(
        this.secretPath, (value) => Future.value(json.decode(value)));
    _data = Map.castFrom(rawMap);
    return true;
  }

  String get toQuotedJson => jsonEncode(json.encode(_data));
}

class ParseServerConfig {
  final Map<String, String> data;

  const ParseServerConfig({@required this.data});

  String get restId => data["restId"];

  String get clientId => data["clientId"];

  String get appId => data["applicationId"];

  String get serverUrl => data["serverUrl"];
}
