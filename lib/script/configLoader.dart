import 'package:flutter/foundation.dart';

abstract class ConfigLoader {
  Future<Map<String, dynamic>> loadFile({@required String filePath});

  Future<String>  toQuotedJson({@required String filePath});
}