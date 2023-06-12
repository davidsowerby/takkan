import 'dart:io';

import 'package:takkan_back4app_generator/generator/generated_file.dart';

Future<List<LineComparison>> compareFileToGenerated(
    {required File reference, required GeneratedFile generated}) async {
  final referenceContent = await reference.readAsLines();
  return compareLines(expected: referenceContent, actual: generated.lines);
}

Future<List<LineComparison>> compareGeneratedToReferenceFile(
    {required File reference, required List<String> generated}) async {
  final referenceContent = await reference.readAsLines();
  return compareLines(expected: referenceContent, actual: generated);
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

  const LineComparison(
      {required this.expected, required this.actual, required this.lineNumber});
  final String expected;
  final String actual;
  final int lineNumber;

  @override
  String toString() {
    return '\nline:$lineNumber\nexpect:$expected\nactual:$actual\n\n';
  }
}

bool hasFile(List<GeneratedFile> files, String filename) {
  for (final GeneratedFile f in files) {
    if (f.fileName == filename) {
      return true;
    }
  }
  return false;
}
