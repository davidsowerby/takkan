import 'dart:convert';
import 'dart:io';

import 'package:precept_server_code_generator/generator/generated_file.dart';

Future<List<LineComparison>> compareFileToGenerated(
    {required File reference, required GeneratedFile generated}) async {
  final referenceContent = await reference.readAsLines();
  return compareLines(expected: referenceContent, actual: generated.lines);
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

  @override
  String toString() {
    return '\nline:$lineNumber\nexpect:$expected\nactual:$actual\n\n';
  }
}

bool hasFile(List<GeneratedFile> files, String filename) {
  for (GeneratedFile f in files) {
    if (f.fileName == filename) {
      return true;
    }
  }
  return false;
}
