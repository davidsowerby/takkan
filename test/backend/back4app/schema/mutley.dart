import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:precept_back4app_backend/backend/back4app/schema/schemaConverter.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      final Back4AppSchema schema =
          Back4AppSchema(results: List.empty(growable: true));
      // when
      schema.addClass(SchemaClass(fields: {}, className: 'Account'));
      // then

      final output = json.encode(schema.toJson());
      File f = File('x.json');
      f.writeAsStringSync(output);
      expect(1, 0);
    });
  });
}
