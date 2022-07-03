import 'dart:convert';
import 'dart:io';

import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';

Future<dynamic> exportSchemaToFile({required Schema schema}) async {
  final output = json.encode(schema.toJson());
  final String filename =
      'exported_schemas/schema${schema.version.number}.json';
  final File f = File(filename);
  f.createSync(recursive: true);
  return f.writeAsString(output, flush: true);
}

Future<dynamic> exportScript(
    {required Script script, bool toFile = true, bool toCloud = false}) {
  final output = json.encode(script.toJson());
  final String filename = 'script${script.version.number}.json';
  final File f = File(filename);
  return f.writeAsString(output, flush: true);
}
