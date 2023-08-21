
import 'dart:convert';
import 'dart:io';

import 'package:takkan_medley_orchestrator/schema/medley_schema.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_script/script/script.dart';

Future<List<dynamic>> exportSchemaVersions({
  required List<Schema> schemaVersions,
  bool toFile = true,
  bool toCloud = false,
  String outputDirPath = '.',
}) async {
  final futures = List<Future<dynamic>>.empty(growable: true);
  for (final schema in schemaVersions) {
    futures.add(exportSchemaToFile(schema: schema));
  }
  final result = await Future.wait(futures);
  return result;
}


void main(List<String> args) async{
  await exportSchemaVersions(schemaVersions: [medleySchema0, medleySchema1,medleySchema2], toFile: true, toCloud: false);
}



Future<dynamic> exportSchemaToFile({required Schema schema}) async {
  final output = json.encode(schema.toJson());
  final String filename =
      'exported_schemas/schema${schema.version.versionIndex}.json';
  final File f = File(filename);
  f.createSync(recursive: true);
  return f.writeAsString(output, flush: true);
}

Future<dynamic> exportScript(
    {required Script script, bool toFile = true, bool toCloud = false}) {
  final output = json.encode(script.toJson());
  final String filename = 'script${script.version.versionIndex}.json';
  final File f = File(filename);
  return f.writeAsString(output, flush: true);
}
