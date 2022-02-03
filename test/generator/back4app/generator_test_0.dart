import 'dart:convert';
import 'dart:io';

import 'package:precept_server_code_generator/generator/back4app/back4app_schema_generator.dart';
import 'package:precept_server_code_generator/generator/diff.dart';
import 'package:precept_script/example/medley_schema.dart';
import 'package:test/test.dart';

import '../../compare_file.dart';

void main() {
  group('Generated files', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('all files', () async {
      // given
      Directory systemTemp = Directory.systemTemp;
      final Directory tempDir = await systemTemp.createTemp();
      final schema = medleySchema0;
      schema.init();
      final generator = Back4AppSchemaGenerator();
      final refAppJs = File('test/reference/0/cloud/app.js');
      final refMainJs = File('test/reference/0/cloud/main.js');
      final refIntValJs = File('test/reference/0/cloud/integer_validation.js');
      final refStringValJs =
          File('test/reference/0/cloud/string_validation.js');
      final refPackageJson = File('test/reference/0/cloud/package.json');

      // when
      generator.generateCode(schemas: [schema]);
      await generator.writeFiles(tempDir);
      // then
      final appJsResult = await compareFileToGenerated(
        reference: refAppJs,
        generated: generator.appJs,
      );
      final mainJsResult = await compareFileToGenerated(
        reference: refMainJs,
        generated: generator.mainJs,
      );
      final intValJsResult = await compareFileToGenerated(
        reference: refIntValJs,
        generated: generator.integerValidation,
      );
      final stringValJsResult = await compareFileToGenerated(
        reference: refStringValJs,
        generated: generator.stringValidation,
      );
      final referenceContent = await refPackageJson.readAsString();
      final packageJsonRef = json.decode(referenceContent);

      expect(tempDir.listSync().length,
          Directory('test/reference/0/cloud').listSync().length);
      expect(appJsResult, isEmpty);
      expect(mainJsResult, isEmpty);
      expect(intValJsResult, isEmpty);
      expect(stringValJsResult, isEmpty);
      expect(generator.packageJson.json, packageJsonRef);
    });
  });
}
