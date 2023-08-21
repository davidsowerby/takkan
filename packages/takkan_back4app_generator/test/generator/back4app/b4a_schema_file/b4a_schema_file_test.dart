// ignore_for_file: avoid_print

import 'dart:io';

import 'package:takkan_back4app_generator/generator/back4app/b4a_schema_file.dart';
import 'package:takkan_medley_orchestrator/schema/medley_schema.dart';
import 'package:test/test.dart';

import '../../../compare_file.dart';

void main() {
  group('B4a Schema File', () {
    setUpAll(() {
      for (final schema in schemaVersions) {
        schema.init(schemaName: 'test');
      }
    });

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () async {
      // given

      final B4ASchemaJavaScriptFile appFile = B4ASchemaJavaScriptFile();
      // when
      appFile.writeToBuffer(schemaVersions: schemaVersions);
      final buf = appFile.buf;
      final actual = buf.toString().split('\n');
      // then
      final comparison = await compareGeneratedToReferenceFile(
          generated: actual,
          reference: _referenceFile('b4a_schema_file_ref.txt'));
      if (comparison.isNotEmpty) {
        print('Comparison failed:\n\n');
        print(comparison);
        print('\n\n============= Output File ===================\n\n');
        print(buf.toString());
      }
      expect(comparison.length, 0);
      print(buf.toString());
    });
  });
}

File _referenceFile(String fileName) {
  return File('test/generator/back4app/b4a_schema_file/$fileName');
}
