import 'dart:io';

import 'package:precept_dev_generator/generator/back4app/back4app_schema_generator.dart';
import 'package:precept_dev_generator/generator/back4app/framework_copy.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

void main() {
  group('generate', () {
    late Directory temp;
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() async {
      temp = await Directory.systemTemp.createTemp('dev-generator-test-');
    });

    tearDown(() async {
      await temp.delete(recursive: true);
    });

    test('schema and validation', () {
      // given
      PSchema schema = PSchema(name: 'test', documents: {
        'address': PDocument(fields: {'line 1': PString()}),
      });
      schema.init();
      // when
      final generator = Back4AppSchemaGenerator();
      generator.generate(pSchema: schema);
      // then

      expect(1, 0);
    });
    test('framework', () async {
      // given

      // when
      await copyFrameworkCode(outputDirectory: temp);
      final copiedFiles = await temp.list().toList();
      final copiedFilenames =
          copiedFiles.map((e) => path.basename(e.absolute.path));
      // then
      expect(copiedFiles.length, 3);
      expect(copiedFilenames, contains('main.js'));
      expect(copiedFilenames, contains('frameworkTriggers.js'));
      expect(copiedFilenames, contains('frameworkFunctions.js'));
    });
  });
}
