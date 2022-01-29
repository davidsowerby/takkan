import 'dart:io';

import 'package:precept_dev_generator/generator/back4app/back4app_schema_generator.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  group('Writing Schema Generator output', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('compare written files to generated', () async {
      // given
      Directory systemTemp = Directory.systemTemp;
      final Directory tempDir = await systemTemp.createTemp();
      File mainJs = File('${tempDir.path}/main.js');
      File stringValidationJs = File('${tempDir.path}/stringValidation.js');
      File integerValidationJs = File('${tempDir.path}/integerValidation.js');
      File packageJson = File('${tempDir.path}/package.json');

      final PSchema pSchema = PSchema(name: 'test', documents: {
        'Issue': PDocument(fields: {
          'weight': PInteger(validations: [
            VInteger.lessThan(100),
            VInteger.greaterThan(23),
          ]),
          'title': PString(validations: [
            VString.longerThan(3),
            VString.shorterThan(13),
          ]),
        })
      });
      pSchema.init();
      // when
      Back4AppSchemaGenerator generator = Back4AppSchemaGenerator();
      generator.generate(pSchema: pSchema);
      await generator.writeFiles(tempDir);

      // then files exist
      expect(tempDir.listSync().length, 4);
      expect(mainJs.existsSync(), isTrue);
      expect(packageJson.existsSync(), isTrue);
      expect(stringValidationJs.existsSync(), isTrue);
      expect(integerValidationJs.existsSync(), isTrue);

      /// and file content as per generated files
      expectLater(await compareFileToGenerated(mainJs, generator.main), isTrue);
      expectLater(
          await compareFileToGenerated(packageJson, generator.packageJson),
          isTrue);
      expectLater(
          await compareFileToGenerated(
              stringValidationJs, generator.stringValidation),
          isTrue);
      expectLater(
          await compareFileToGenerated(
              integerValidationJs, generator.integerValidation),
          isTrue);
    });
  });
}

List<LineComparison> compareText(
    {required String expected, required String actual}) {
  final aList = expected.split('\n');
  final bList = actual.split('\n');
  return compareLines(expected: aList, actual: bList);
}

List<LineComparison> compareLines(
    {required List<String> expected, required List<String> actual}) {
  final List<LineComparison> result = List.empty(growable: true);
  final int longest =
      (expected.length >= actual.length) ? expected.length : actual.length;
  for (int j = 0; j < longest; j++) {
    final a = (j < expected.length) ? expected[j] : '';
    final b = (j < actual.length) ? actual[j] : '';
    if (a != b) {
      result.add(LineComparison(expected: a, actual: b, lineNumber: j));
    }
  }
  return result;
}

Future<bool> compareFileToGenerated(File f, GeneratedFile gf) async {
  final writtenContent = await f.readAsLines();
  final result = compareLines(expected: gf.lines, actual: writtenContent);
  return result.isEmpty;
}

class LineComparison {
  final String expected;
  final String actual;
  final int lineNumber;

  const LineComparison(
      {required this.expected, required this.actual, required this.lineNumber});
}

bool hasFile(List<GeneratedFile> files, String filename) {
  for (GeneratedFile f in files) {
    if (f.fileName == filename) {
      return true;
    }
  }
  return false;
}
