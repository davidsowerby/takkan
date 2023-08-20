import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_schema/common/log.dart';

MultiChildResult row(Key rowKey) {
  final r = find.byKey(rowKey);
  final int resultCount = r.evaluate().toList().length;
  if (resultCount < 1) {
    final msg = "Row with key '$rowKey' not found";
    testThrow(msg);
  }
  if (resultCount > 1) {
    final msg = "There are $resultCount rows with key '$rowKey'";
    testThrow(msg);
  }
  return MultiChildResult(rowKey);
}

testThrow(String msg) {
  logName('row').e(msg);
  throw TestException(msg);
}

class MultiChildResult {
  final Key parentKey;

  const MultiChildResult(this.parentKey);

  contains(List<Key> keys) {
    final parentFinder = find.byKey(parentKey);
    for (Key key in keys) {
      expect(find.descendant(of: parentFinder, matching: find.byKey(key)),
          findsOneWidget);
    }
  }
}

class TestException implements Exception {
  final String msg;

  const TestException(this.msg);

  String errMsg() => msg;
}
