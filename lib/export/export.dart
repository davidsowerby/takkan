import 'package:takkan_script/schema/schema.dart';

import 'export_file.dart';

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
