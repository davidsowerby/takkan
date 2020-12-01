import 'dart:convert';

import 'package:precept_client/app/data/kitchenSink.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:test/test.dart';

void main() {
  group('Round trip Precept Script to JSON', () {
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
      PScript model2 = PScript.fromJson(jsonMap);

      expect(model2.components.length, 1);
      model2.init();
      final c0 = model2.components[0];
      expect(c0.name, "core");
      expect(c0.routes.length, 1);
      final r0 = c0.routes[0];
      expect(r0.path, "/");
      final p = r0.page;
      expect(p.title, "Home Page");
      expect(p.document.sections.length, 1);
      expect(p.document.backend.connection['id'], 'mock1');

      expect(json.encode(script.toJson()), json.encode(model2.toJson()));
    });

  });
}
