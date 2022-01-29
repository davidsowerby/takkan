import 'dart:io';

import 'package:precept_dev_generator/generator/back4app/back4app_schema_generator.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  group('Schema Generator', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});
    test('correct files generated', () async {
      // given
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
      // then

      expect(generator.stringValidation, isA<JavaScriptFile>());
      expect(generator.integerValidation, isA<JavaScriptFile>());
      expect(generator.main, isA<JavaScriptFile>());
      expect(generator.packageJson, isA<JSONFile>());
    });
    test('integerValidation.js', () async {
      // given
      final refIntFile = File(
          'test/generator/back4app/ref-integerValidation.js');

      List<String> refInt = await refIntFile.readAsLines();
      final PSchema pSchema = PSchema(name: 'test', documents: {
        'Issue': PDocument(fields: {'weight': PInteger()})
      });
      pSchema.init();
      // when
      Back4AppSchemaGenerator generator = Back4AppSchemaGenerator();
      generator.generate(pSchema: pSchema);
      // then

      final intJs = compareLines(
          expected: refInt, actual: generator.integerValidation.lines);
      expect(intJs.length, 0);
    });
    test('stringValidation.js', () async {
      // given
      final refStringFile = File(
          'test/generator/back4app/ref-stringValidation.js');
      List<String> refString = await refStringFile.readAsLines();
      final PSchema pSchema = PSchema(name: 'test', documents: {
        'Issue': PDocument(fields: {'weight': PInteger()})
      });
      pSchema.init();
      // when
      Back4AppSchemaGenerator generator = Back4AppSchemaGenerator();
      generator.generate(pSchema: pSchema);

      Directory systemTemp = Directory.systemTemp;
      final Directory td = await systemTemp.createTemp();
      await generator.writeFiles(td);
      // then

      final stringJs = compareLines(
          expected: refString, actual: generator.stringValidation.lines);
      expect(stringJs.length, 0);
    });
    test('main.js', () async {
      // given
      final refMainFile =
          File('test/generator/back4app/ref-main.js');
      List<String> refMain = await refMainFile.readAsLines();

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
      // then

      final mainJs =
          compareLines(expected: refMain, actual: generator.main.lines);
      expect(mainJs.length, 0);
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
