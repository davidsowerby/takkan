import 'dart:convert';

import 'package:precept_script/example/kitchen_sink_schema.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  group('PSchema JSON Round trip', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});
    test('full model', () {
      // given
      PSchema script = kitchenSinkSchema;

      // when
      script.doInit(name: 'A schema',parent: script);
      Map<String, dynamic> jsonMap = script.toJson();
      PSchema script2 = PSchema.fromJson(jsonMap);

      expect(script2.documentCount, 2);
      script2.doInit(name: 'A schema',parent: script);
      // then



      final PDocument accountDoc = script2.document('Account');
      expect(accountDoc.name, 'Account');
      expect(accountDoc.parent, script2);

      expect(json.encode(script.toJson()), json.encode(script2.toJson()));
    });

  });
}
