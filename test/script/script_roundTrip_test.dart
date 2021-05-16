import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/example/kitchenSink.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/script/script.dart';

void main() {
  group('PScript JSON Round trip', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
    });

    tearDown(() {});
    test('with DataProvider', () {
      // given
      PScript script = kitchenSinkScript;

      // when
      script.init();
      // then
      Map<String, dynamic> jsonMap = script.toJson();
      PScript script2 = PScript.fromJson(jsonMap);

      expect(script2.pages.length, 1);
      script2.init();
      final c0 = script2.pages['/'];
      expect(c0.route, '/');

      expect(c0.title, "Home Page");
      expect(c0.content.length, 2);

      expect(json.encode(script.toJson()), json.encode(script2.toJson()));
    });

    test('without DataProvider', () {
      // given
      PScript script = kitchenSinkScriptWithoutDataProvider;

      // when
      script.init();
      // then
      Map<String, dynamic> jsonMap = script.toJson();
      PScript script2 = PScript.fromJson(jsonMap);

      expect(script2.pages.length, 1);
      script2.init();
      final c0 = script2.pages['/'];
      expect(c0.route, '/');
      expect(c0.title, "Home Page");
      expect(c0.content.length, 2);

      expect(json.encode(script.toJson()), json.encode(script2.toJson()));
    });

  });
}
