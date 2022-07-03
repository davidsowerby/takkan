import 'package:takkan_server_code_generator/generator/back4app/schema_generator/schema_generator.dart';
import 'package:takkan_server_code_generator/generator/format.dart';
import 'package:test/test.dart';

import '../compare_file.dart';

void main() {
  group('Formatting', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('Json', () {
      // given
      final Formatter f = Formatter();
      // when
      f.outt('const roleCLP = ');
      final testMap = Map<String, dynamic>.from(roleDefaultCLP);
      testMap['String value'] = 'A String';
      f.outJson(map: testMap);
      // then
      final result = compareLines(
          actual: f.bufContentAsLines, expected: expected.split('\n'));
      expect(result, isEmpty);
    });
  });
}

// ignore: leading_newlines_in_multiline_strings
String expected = r'''const roleCLP = {
    "find": {
        "*": true,
        "requiresAuthentication": true
    },
    "count": {
        "*": true,
        "requiresAuthentication": true
    },
    "get": {
        "*": true,
        "requiresAuthentication": true
    },
    "create": {
        "requiresAuthentication": true
    },
    "update": {},
    "delete": {},
    "addField": {},
    "protectedFields": {
        "*": []
    },
    "String value": "A String"
};''';
