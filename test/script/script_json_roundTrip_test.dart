import 'dart:convert';

import 'package:precept_script/data/kitchenSink.dart';
import 'package:precept_script/script/script.dart';
import 'package:test/test.dart';

void main() {
  group('PScript JSON Round trip', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});
    test('full model', () {
      // given
      PScript script = kitchenSinkScript;

      // when
      script.init();
      // then
      Map<String, dynamic> jsonMap = script.toJson();
      PScript script2 = PScript.fromJson(jsonMap);

      expect(script2.components.length, 1);
      script2.init();
      final c0 = script2.components[0];
      expect(c0.name, "core");
      expect(c0.routes.length, 1);
      final r0 = c0.routes[0];
      expect(r0.path, "/");
      final p = r0.page;
      expect(p.title, "Home Page");
      expect(p.content.length, 1);
      expect(p.backend.connection['id'], 'mock1');

      expect(json.encode(script.toJson()), json.encode(script2.toJson()));
    });

  });
}
