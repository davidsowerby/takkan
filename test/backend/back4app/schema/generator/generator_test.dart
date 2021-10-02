import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:precept_back4app_backend/backend/back4app/schema/generator/back4AppSchemaGenerator.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/schema.dart';

void main() {
  group('Schema Generator', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('Integer Validation', () async {
      // given
      final refIntFile = File(
          'test/backend/back4app/schema/generator/ref-integerValidation.js');
      final refStringFile = File(
          'test/backend/back4app/schema/generator/ref-stringValidation.js');
      List<String> refInt = await refIntFile.readAsLines();
      List<String> refString = await refStringFile.readAsLines();
      final PSchema pSchema = PSchema(name: 'test', documents: {
        'Issue': PDocument(fields: {'weight': PInteger()})
      });
      // when
      Back4AppSchemaGenerator generator = Back4AppSchemaGenerator();
      generator.generate(pSchema: pSchema);
      // then

      final intJs = compareLines(refInt, generator.files[0].lines);
      final stringJs = compareLines(refString, generator.files[1].lines);
      expect(intJs.length, 0);
      expect(stringJs.length, 0);
    });
  });
}

List<LineComparison> compareText(String a, String b) {
  final aList = a.split('\n');
  final bList = b.split('\n');
  return compareLines(aList, bList);
}

List<LineComparison> compareLines(List<String> aList, List<String> bList) {
  final List<LineComparison> result = List.empty(growable: true);
  final int longest =
      (aList.length >= bList.length) ? aList.length : bList.length;
  for (int j = 0; j < longest; j++) {
    final a = (j < aList.length) ? aList[j] : '';
    final b = (j < bList.length) ? bList[j] : '';
    if (a != b) {
      result.add(LineComparison(a: a, b: b, lineNumber: j));
    }
  }
  return result;
}

class LineComparison {
  final String a;
  final String b;
  final int lineNumber;

  const LineComparison(
      {required this.a, required this.b, required this.lineNumber});
}
