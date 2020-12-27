import 'dart:convert';

import 'package:precept_script/example/kitchenSinkSchema.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  group('PScript JSON Round trip', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});
    test('full model', () {
      // given
      PSchema script = kitchenSinkSchema;

      // when
      script.doInit();
      Map<String, dynamic> jsonMap = script.toJson();
      PSchema script2 = PSchema.fromJson(jsonMap);

      expect(script2.documents.length, 2);
      script2.doInit();
      // then



      final PDocument accountDoc = script2.documents['Account'];
      expect(accountDoc.name, 'Account');
      expect(accountDoc.parent, script2);

      expect(json.encode(script.toJson()), json.encode(script2.toJson()));
    });

  });
}
