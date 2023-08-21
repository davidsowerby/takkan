import 'dart:io';

import 'package:takkan_back4app_generator/generator/back4app/api_file.dart';
import 'package:takkan_medley_orchestrator/schema/medley_schema.dart';
import 'package:test/test.dart';

import '../../../compare_file.dart';

void main() {
  group('API File', () {
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

      final APIJavaScriptFile apiFile = APIJavaScriptFile(
        documentClassName: 'Issue',
      );
      // when
      apiFile.writeToBuffer(schemaVersions: schemaVersions);
      final buf = apiFile.buf;
      final actual = buf.toString().split('\n');
      // then
      // ignore: avoid_print
      print(buf.toString());
      final comparison = await compareGeneratedToReferenceFile(
          generated: actual, reference: _referenceFile('api_file_ref.txt'));
      if (comparison.isNotEmpty) {
        // ignore: avoid_print
        print(comparison);
      }
      expect(comparison.length, 0);
    });
  });
}

File _referenceFile(String fileName) {
  return File('test/generator/back4app/api_file/$fileName');
}
