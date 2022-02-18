import 'package:takkan_server_code_generator/generator/format.dart';
import 'package:takkan_server_code_generator/generator/back4app/back4app_schema_generator.dart';
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

      // when
      outt('const roleCLP = ');
      final testMap = Map<String, dynamic>.from(roleDefaultCLP);
      testMap['String value'] = 'A String';
      outJson(map: testMap);
      // then
      final result=compareLines(actual: bufContentAsLines,expected: expected.split('\n'));
      expect(result,isEmpty);
    });
  });
}

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