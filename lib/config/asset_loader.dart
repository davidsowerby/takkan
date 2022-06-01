import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:takkan_backend/backend/app/app_config_loader.dart';

/// Reads config from a file loaded as an asset.  Use for API keys etc.
/// Generally the file MUST NOT be under version control. Where this is the case, a CI build script
/// is needed to create it (assuming of course CI is being used!).

class DefaultJsonAssetLoader extends DefaultJsonFileLoader {

  DefaultJsonAssetLoader();

  Future<Map<String, Map<String, dynamic>>> loadFile(
      {required String filePath}) async {
    final String rawFile = await rootBundle.loadString(filePath);
    final map = jsonDecode(rawFile);
    final Map<String, Map<String, dynamic>> result = Map.castFrom(map);
    return result;
  }

}
