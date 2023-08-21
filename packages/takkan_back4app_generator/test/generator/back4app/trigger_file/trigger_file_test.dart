import 'dart:io';

import 'package:takkan_back4app_generator/generator/back4app/trigger_file.dart';
import 'package:takkan_medley_orchestrator/schema/medley_schema.dart';
import 'package:test/test.dart';

import '../../../compare_file.dart';

void main() {
  group('Trigger', () {
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
      final TriggerJavaScriptFile trigger =
          TriggerJavaScriptFile(documentClassName: 'Person');
      // when
      trigger.writeToBuffer(schemaVersions: [
        medleySchema2,
        medleySchema1,
        medleySchema0,
      ]);
      final actual = trigger.buf.toString().split('\n');
      // then
      // ignore: avoid_print
      print(trigger.buf.toString());
      final comparison = await compareGeneratedToReferenceFile(
          generated: actual, reference: _referenceFile('trigger_file_ref.js'));
      if (comparison.isNotEmpty) {
        // ignore: avoid_print
        print(comparison);
      }
      expect(comparison.length, 0);
    });
  });
}

File _referenceFile(String fileName) {
  return File('test/generator/back4app/trigger_file/$fileName');
}
