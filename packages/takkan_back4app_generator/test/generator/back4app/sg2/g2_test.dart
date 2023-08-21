import 'dart:io';

import 'package:fire_line_diff/fire_line_diff.dart';
import 'package:takkan_back4app_generator/generator/back4app/sg2/g2.dart';
import 'package:takkan_medley_orchestrator/schema/medley_schema.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  group('medleySchema0', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      final File ref = File('test/reference/0/cloud/before_save.js');
      final schemas = [medleySchema0];
      final compare = CompareWithReference();
      // when
      for (final Schema schema in schemas) {
        schema.init(schemaName: 'test');
      }
      final actual = generateValidation(schemas);
      compare.string2File(actual, ref);
      // then

      expect(compare.errors, isEmpty, reason: compare.outputMessage());
    });
  });
}

class CompareWithReference {
  late List<ItemResult<String?, String?>> diff;
  late int errorLineNumber;
  late List<ItemResult<String?, String?>> errors;
  late List<String> actualLines;
  late List<String> expectedLines;

  String outputMessage({bool showActual = true}) {
    return hasErrors ? _upToErrorLine(showActual: showActual) : 'No differences found';
  }

  void string2List(String actual, List<String> expectedLines) {
    actualLines = actual.split('\n');
    this.expectedLines = expectedLines;
    _doDiff();
  }

  void string2Filename(String actual, String expectedFileName) {
    final ref = File(expectedFileName);
    string2File(actual, ref);
  }

  void string2File(String actual, File ref) {
    actualLines = actual.split('\n');
    expectedLines = ref.readAsLinesSync();
    _doDiff();
  }

  void linesToFilename(List<String> actualLines, String expectedFileName) {
    final ref = File(expectedFileName);
    linesToFile(actualLines, ref);
  }

  void linesToFile(List<String> actualLines, File ref) {
    expectedLines = ref.readAsLinesSync();
    this.actualLines = actualLines;
    _doDiff();
  }

  bool get hasErrors => errors.isNotEmpty;

  void _doDiff() {
    diff = FireLineDiff.diff<String, String>(actualLines, expectedLines);
    errors = diff
        .where((element) => element.state != LineDiffState.neutral)
        .toList();
    errorLineNumber = errors.isEmpty ? -1 : diff.indexOf(errors.first);
  }

  String get _errorLineCompare {
    final firstErr = errors.first;
    return 'line $errorLineNumber: \n${firstErr.left}\n${firstErr.right}';
  }

  String _upToErrorLine({bool showActual = true}) {
    final buffer = StringBuffer();
    int lineCount = 0;
    while (lineCount <= errorLineNumber) {
      final r = diff[lineCount];
      if (lineCount == errorLineNumber) {
        buffer.writeln(_errorLineCompare);
      } else {
        buffer.writeln('$lineCount: ${r.left}');
      }
      lineCount++;
    }
    if (showActual) {
      buffer.writeln();
      buffer.writeln('actual output:');
      buffer.writeln();
      buffer.writeln(actualLines.join('\n'));
    }
    return buffer.toString();
  }
}
