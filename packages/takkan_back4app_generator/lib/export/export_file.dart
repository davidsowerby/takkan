import 'dart:convert';
import 'dart:io';

import 'package:takkan_schema/schema/schema.dart';

Future<dynamic> exportSchemaToFile({required Schema schema}) async {
  final output = json.encode(schema.toJson());
  final String filename =
      'exported_schemas/schema${schema.version.number}.json';
  final File f = File(filename);
  f.createSync(recursive: true);
  return f.writeAsString(output, flush: true);
}
