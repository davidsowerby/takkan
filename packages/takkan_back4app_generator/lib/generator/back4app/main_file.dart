import 'dart:io';

import 'package:takkan_schema/schema/schema.dart';

import '../generated_file.dart';

class MainJavaScriptFile extends JavaScriptFile {
  final List<String> requires = List.empty(growable: true);

  @override
  String get fileName => 'main.js';

  @override
  void specify({required List<Schema> schemaVersions}) {
    elements.add(RequireStatement(requiredModule: './framework.js'));
    elements.addAll(
      requires.map(
        (e) => RequireStatement(requiredModule: e),
      ),
    );
  }

  void writeToBuffer({required List<Schema> schemaVersions}) {
    specify(schemaVersions: schemaVersions);
    for (final element in elements) {
      element.writeToBuffer(buf, conditions: const OutputConditions());
    }
  }

  /// Writes to buffer first, as this file is constructed from other generated files
  @override
  Future<File> writeFile(Directory outputDirectory) async {
    writeToBuffer(schemaVersions: const []);
    return super.writeFile(outputDirectory);
  }
}
