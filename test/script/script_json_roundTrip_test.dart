import 'dart:convert';

import 'package:precept_script/example/kitchenSink.dart';
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

      expect(script2.routes.length, 1);
      script2.init();
      final c0 = script2.routes['/'];
      expect(c0.path, '/');
      final p = c0.page;
      expect(p.title, "Home Page");
      expect(p.content.length, 1);
      expect(p.backend.connection['id'], 'mock1');

      expect(json.encode(script.toJson()), json.encode(script2.toJson()));
    });

  });
}
