import 'dart:io';

import 'package:takkan_medley_script/schema/medley_schema.dart';
import 'package:takkan_server_code_generator/generator/back4app/function_file.dart';
import 'package:test/test.dart';

import '../../../compare_file.dart';

void main() {
  group('Function File', () {
    setUpAll(() {
      for (final schema in medleySchema) {
        schema.init();
      }
    });

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () async {
      // given

      final FunctionJavaScriptFile functionFile = FunctionJavaScriptFile(
        documentClassName: 'Issue',
      );
      // when
      functionFile.writeToBuffer(schemaVersions: medleySchema);
      final buf = functionFile.buf;
      final actual = buf.toString().split('\n');
      // then
      // ignore: avoid_print
      print(buf.toString());
      final comparison = await compareGeneratedToReferenceFile(
          generated: actual,
          reference: _referenceFile('function_file_ref.txt'));
      if (comparison.isNotEmpty) {
        // ignore: avoid_print
        print(comparison);
      }
      expect(comparison.length, 0);
    });
  });
}

File _referenceFile(String fileName) {
  return File('test/generator/back4app/function_file/$fileName');
}
