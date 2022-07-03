import 'dart:io';

import 'package:takkan_medley_script/schema/medley_schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_server_code_generator/generator/back4app/trigger_file.dart';
import 'package:test/test.dart';

import '../../../compare_file.dart';

void main() {
  group('Trigger', () {
    setUpAll(() {
      for (final schema in medleySchema) {
        final Script script = Script(
            name: 'Generation Dummy', version: schema.version, schema: schema);
        script.init();
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
          generated: actual, reference: _referenceFile('trigger_file_ref.txt'));
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
