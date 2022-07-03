import 'dart:io';

import 'package:takkan_medley_script/schema/medley_schema.dart';
import 'package:takkan_server_code_generator/export/export.dart';
import 'package:test/test.dart';

void main() {
  group('export files', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      final schemaSet = [medleySchema0, medleySchema1, medleySchema2];
      // when
      exportSchemaVersions(schemaVersions: schemaSet);
      // then

      final File f0 = File('exported_schemas/schema0.json');
      expect(f0.existsSync(), isTrue);
      final File f1 = File('exported_schemas/schema1.json');
      expect(f1.existsSync(), isTrue);
      final File f2 = File('exported_schemas/schema2.json');
      expect(f2.existsSync(), isTrue);
    });
  });
}
