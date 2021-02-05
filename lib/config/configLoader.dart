import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:precept_script/script/configLoader.dart';

/// Reads config from a file loaded as an asset.  Use for API keys etc.
/// Generally the file MUST NOT be under version control. Where this is the case, a CI build script
/// is needed to create it (assuming of course CI is being used!).

class DefaultConfigLoader implements ConfigLoader {
  const DefaultConfigLoader();

  Future<Map<String, dynamic>> loadFile({@required String filePath}) async {
    assert(filePath != null);
    Map<dynamic, dynamic> rawMap = await rootBundle.loadStructuredData<Map<dynamic, dynamic>>(
        filePath, (value) => Future.value(json.decode(value)));
    final data = Map.castFrom(rawMap);
    return data;
  }

  Future<String>  toQuotedJson({@required String filePath}) async {
    final data = await loadFile(filePath: filePath);
    return jsonEncode(json.encode(data));
  }
}


