import 'dart:convert';
import 'dart:io';

import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';

import 'app_config.dart';

/// The default is to hold app configuration in a file *takkan.json* in the project root.
///
/// Except for testing, any deviation from this convention is discouraged, as Takkan
/// assumes that is where the configuration is.
///
/// It is therefore usually unnecessary to specify [filePath], except when testing
///
///
/// If loading through a Flutter client, this loader will not work, use the
/// JSONAssetLoader in the *takkan_client* package instead
class DefaultJsonFileLoader implements JsonFileLoader {

  const DefaultJsonFileLoader();

  /// If [returnEmptyIfAbsent] is true, a missing *takkan.json* returns an empty
  /// [AppConfig] - if false, a [TakkanException] is thrown if no *takkan.json*
  /// exists in [fileName]
  @override
  Future<Map<String, dynamic>> loadFile(
      {required String filePath}) async {
    final File f=File(filePath);
    if (!f.existsSync()) {
      final String msg = 'There is no file at ${f.path}';
      logType(runtimeType).e(msg);
      throw TakkanException(msg);
    }

    final content = f.readAsStringSync();
    return json.decode(content) as Map<String, dynamic>;

  }

  @override
  Future<String> toQuotedJson({required String filePath}) async {
    final data = await loadFile(filePath: filePath);
    return jsonEncode(json.encode(data));
  }
}

abstract class JsonFileLoader {
  Future<Map<String, dynamic>> loadFile({required String filePath});
  Future<String> toQuotedJson({required String filePath});
}

/// Not really a file loader at all, just uses data directly loaded, but can
/// be used with inject<JsonFileLoader>, usually only for testing
class DirectFileLoader extends DefaultJsonFileLoader {

  const DirectFileLoader({required this.data});
  final Map<String, dynamic> data;
  @override
  Future<Map<String, dynamic>> loadFile({required String filePath}) async {
    return data;
  }
}
