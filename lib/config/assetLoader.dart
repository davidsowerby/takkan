import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Reads config from a file loaded as an asset.  Use for API keys etc.
/// Generally the file MUST NOT be under version control. Where this is the case, a CI build script
/// is needed to create it (assuming of course CI is being used!).

class DefaultJsonAssetLoader implements JsonAssetLoader {
  bool _isLoaded = false;

  DefaultJsonAssetLoader();

  Future<Map<String, Map<String, dynamic>>> loadFile({required String filePath}) async {
    final String rawFile = await rootBundle.loadString(filePath);
    final map = jsonDecode(rawFile);
    final Map<String, Map<String, dynamic>> result = Map.castFrom(map);
    return result;
  }

  Future<String> toQuotedJson({required String filePath}) async {
    final data = await loadFile(filePath: filePath);
    return jsonEncode(json.encode(data));
  }

  @override
  bool get isLoaded => _isLoaded;
}

abstract class JsonAssetLoader {
  bool get isLoaded;

  Future<Map<String, dynamic>> loadFile({required String filePath});

  Future<String> toQuotedJson({required String filePath});
}
